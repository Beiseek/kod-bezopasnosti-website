#!/bin/bash
set -euo pipefail

# === Config ===
DOMAIN=${1:-"kod-bezopasnosti.ru"}
WWW_DOMAIN="www.${DOMAIN}"
SERVER_IP=${2:-"91.229.8.148"}
EMAIL=${3:-"923sen@mail.ru"}
PROJECT_DIR="/var/www/kod-bezopasnosti"
SOCKET_PATH="/var/www/kod-bezopasnosti/kodbezopasnosti.sock"
STATIC_ROOT="/var/www/kod-bezopasnosti/staticfiles"
MEDIA_ROOT="/var/www/kod-bezopasnosti/media"
SITE_NAME="${DOMAIN}"
NGINX_AVAILABLE="/etc/nginx/sites-available/${SITE_NAME}.conf"
NGINX_ENABLED="/etc/nginx/sites-enabled/${SITE_NAME}.conf"
RETRY_SCRIPT="/usr/local/bin/obtain_ssl_${SITE_NAME}.sh"
CRON_FILE="/etc/cron.d/obtain_ssl_${SITE_NAME}"

info() { echo -e "\033[1;34m[INFO]\033[0m $*"; }
success() { echo -e "\033[1;32m[SUCCESS]\033[0m $*"; }
warn() { echo -e "\033[1;33m[WARN]\033[0m $*"; }
err() { echo -e "\033[1;31m[ERROR]\033[0m $*"; }

if [[ $EUID -ne 0 ]]; then
  err "Запусти от root (sudo -i)"; exit 1
fi

info "Устанавливаю зависимости (nginx, certbot)..."
apt-get update -y
DEBIAN_FRONTEND=noninteractive apt-get install -y nginx certbot python3-certbot-nginx

info "Создаю доменную конфигурацию Nginx (IP доступ не трогаю)..."
cat > "${NGINX_AVAILABLE}" <<'EOF'
# Доменный сервер-блок (HTTP). SSL прикрутим certbot'ом потом
server {
    listen 80;
    server_name DOMAIN_PLACEHOLDER WWW_DOMAIN_PLACEHOLDER;

    client_max_body_size 50M;

    location /static/ {
        alias STATIC_ROOT_PLACEHOLDER/;
        expires 30d;
        add_header Cache-Control "public, immutable";
    }

    location /media/ {
        alias MEDIA_ROOT_PLACEHOLDER/;
        expires 30d;
        add_header Cache-Control "public, immutable";
    }

    location / {
        include proxy_params;
        proxy_set_header Host $host;
        proxy_pass http://unix:SOCKET_PATH_PLACEHOLDER;
    }
}

# Доступ по IP/дефолтный — оставляем как есть существующими конфигами.
# Наша задача — добавить домен и не ломать IP.
EOF

# Подставим реальные пути и домены
sed -i \
  -e "s|DOMAIN_PLACEHOLDER|${DOMAIN}|g" \
  -e "s|WWW_DOMAIN_PLACEHOLDER|${WWW_DOMAIN}|g" \
  -e "s|STATIC_ROOT_PLACEHOLDER|${STATIC_ROOT}|g" \
  -e "s|MEDIA_ROOT_PLACEHOLDER|${MEDIA_ROOT}|g" \
  -e "s|SOCKET_PATH_PLACEHOLDER|${SOCKET_PATH}|g" \
  "${NGINX_AVAILABLE}"

ln -sf "${NGINX_AVAILABLE}" "${NGINX_ENABLED}"

info "Проверяю и перезагружаю Nginx..."
nginx -t && systemctl reload nginx

issue_cert() {
  set +e
  certbot --nginx -d "${DOMAIN}" -d "${WWW_DOMAIN}" \
    --redirect --agree-tos -m "${EMAIL}" -n
  local rc=$?
  set -e
  return $rc
}

info "Пробую получить сертификат Let's Encrypt..."
if issue_cert; then
  success "SSL установлен! Включен редирект на HTTPS."
  # Удалим авто-повтор, если был
  if [[ -f "${CRON_FILE}" ]]; then rm -f "${CRON_FILE}"; fi
  if [[ -f "${RETRY_SCRIPT}" ]]; then rm -f "${RETRY_SCRIPT}"; fi
  systemctl reload nginx || true
else
  warn "Не удалось получить SSL сейчас (возможно, DNS ещё не обновился). Настраиваю автоповтор каждые 10 минут..."

  cat > "${RETRY_SCRIPT}" <<RETRY
#!/bin/bash
set -e
certbot --nginx -d "${DOMAIN}" -d "${WWW_DOMAIN}" --redirect --agree-tos -m "${EMAIL}" -n && {
  rm -f "${CRON_FILE}" "${RETRY_SCRIPT}"
  systemctl reload nginx || true
}
RETRY
  chmod +x "${RETRY_SCRIPT}"

  echo "*/10 * * * * root ${RETRY_SCRIPT} >> /var/log/letsencrypt/obtain_${SITE_NAME}.log 2>&1" > "${CRON_FILE}"
  chmod 644 "${CRON_FILE}"
  systemctl restart cron || systemctl restart crond || true
  success "Готово: будет автоповтор каждые 10 минут до успешной выдачи сертификата. Доступ по IP сохранён."
fi

success "Завершено. Проверь:\n- http://${DOMAIN}\n- http://${WWW_DOMAIN}\n- http://${SERVER_IP}\nПосле обновления DNS — HTTPS заработает автоматически."
