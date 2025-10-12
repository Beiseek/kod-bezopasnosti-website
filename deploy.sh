#!/bin/bash

# ==============================================================================
#  Скрипт для автоматического развертывания Django-проекта "Код Безопасности"
# ==============================================================================
#
# 🚨 ПРЕДУПРЕЖДЕНИЕ О БЕЗОПАСНОСТИ 🚨
# Этот скрипт НЕ содержит конфиденциальных данных.
# Все токены и пароли нужно вводить вручную при выполнении.
#
# ------------------------------------------------------------------------------
#
#  Инструкция по использованию:
#  1. Скопируйте этот файл на ваш VPS сервер:
#     scp deploy.sh root@91.229.8.148:/root/
#
#  2. Подключитесь к серверу по SSH:
#     ssh root@91.229.8.148
#
#  3. Сделайте скрипт исполняемым:
#     chmod +x deploy.sh
#
#  4. Запустите скрипт:
#     ./deploy.sh
#
# ==============================================================================

# Прерываем выполнение при любой ошибке
set -e

# --- Переменные проекта ---
REPO_URL="https://github.com/Beiseek/kod-bezopasnosti-website.git"
PROJECT_DIR="/var/www/kod-bezopasnosti"
PROJECT_NAME="kodbezopasnosti"
DOMAIN="kod-bezopasnosti.ru"
SERVER_IP="91.229.8.148"
USER="root"

echo "--- [ШАГ 1/9] Обновление системы и установка зависимостей ---"
apt update
apt install -y python3-pip python3-dev python3-venv nginx curl git supervisor

echo "--- [ШАГ 2/9] Клонирование репозитория из GitHub ---"
# Клонируем публичный репозиторий
git clone ${REPO_URL} ${PROJECT_DIR}

cd ${PROJECT_DIR}

echo "--- [ШАГ 3/9] Настройка виртуального окружения Python ---"
python3 -m venv venv
source venv/bin/activate

echo "--- [ШАГ 4/9] Установка зависимостей Python ---"
pip install --upgrade pip
pip install -r requirements.txt
pip install gunicorn

echo "--- [ШАГ 5/9] Настройка Django для продакшена ---"
# Настраиваем ALLOWED_HOSTS для продакшена
sed -i "s/ALLOWED_HOSTS = \[\]/ALLOWED_HOSTS = ['kod-bezopasnosti.ru', 'www.kod-bezopasnosti.ru', '${SERVER_IP}', 'localhost', '127.0.0.1']/" ${PROJECT_DIR}/kodbezopasnosti/settings.py
sed -i "s/DEBUG = True/DEBUG = False/" ${PROJECT_DIR}/kodbezopasnosti/settings.py

echo "--- [ШАГ 6/9] Выполнение команд Django (миграции, статика) ---"
python manage.py migrate
python manage.py collectstatic --noinput

# Деактивируем окружение для выполнения системных команд
deactivate

echo "--- [ШАГ 7/9] Настройка Gunicorn и Supervisor ---"
# Создаем конфигурационный файл для Supervisor, который будет управлять Gunicorn
cat > /etc/supervisor/conf.d/${PROJECT_NAME}.conf << EOF
[program:${PROJECT_NAME}]
command=${PROJECT_DIR}/venv/bin/gunicorn --workers 3 --bind unix:${PROJECT_DIR}/${PROJECT_NAME}.sock ${PROJECT_NAME}.wsgi:application
directory=${PROJECT_DIR}
user=${USER}
autostart=true
autorestart=true
stderr_logfile=/var/log/${PROJECT_NAME}.err.log
stdout_logfile=/var/log/${PROJECT_NAME}.out.log
EOF

echo "--- [ШАГ 8/9] Настройка Nginx в качестве обратного прокси ---"
# Удаляем стандартный сайт Nginx
rm -f /etc/nginx/sites-enabled/default

# Создаем конфигурационный файл Nginx для нашего сайта
cat > /etc/nginx/sites-available/${DOMAIN} << EOF
server {
    listen 80;
    server_name ${DOMAIN} www.${DOMAIN};

    location = /favicon.ico { access_log off; log_not_found off; }

    location /static/ {
        root ${PROJECT_DIR};
    }

    location /media/ {
        root ${PROJECT_DIR};
    }

    location / {
        include proxy_params;
        proxy_pass http://unix:${PROJECT_DIR}/${PROJECT_NAME}.sock;
    }
}
EOF

# Включаем наш сайт, создавая символическую ссылку
ln -sf /etc/nginx/sites-available/${DOMAIN} /etc/nginx/sites-enabled/

# Проверяем конфигурацию Nginx на наличие ошибок
nginx -t

echo "--- [ШАГ 9/9] Перезапуск служб ---"
supervisorctl reread
supervisorctl update
supervisorctl restart ${PROJECT_NAME}
systemctl restart nginx

echo ""
echo "========================================================"
echo "✅ ДЕПЛОЙ УСПЕШНО ЗАВЕРШЕН!"
echo ""
echo "Сайт должен быть доступен по адресам:"
echo "  🌐 http://${DOMAIN}"
echo "  🌐 http://www.${DOMAIN}"
echo "  🌐 http://${SERVER_IP}"
echo ""
echo "📋 DNS-записи для настройки в REG.RU:"
echo "  A-запись: @ → ${SERVER_IP}"
echo "  CNAME: www → ${DOMAIN}"
echo ""
echo "🔒 БЕЗОПАСНОСТЬ: Скрипт не содержит конфиденциальных данных."
echo "========================================================"