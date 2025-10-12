#!/bin/bash

# ==============================================================================
#  Скрипт для исправления конфигурации Nginx
# ==============================================================================

echo "🔧 ИСПРАВЛЯЕМ NGINX..."

echo "--- [ШАГ 1/4] Создаем правильную конфигурацию Nginx ---"
cat > /etc/nginx/sites-available/kod-bezopasnosti.ru << 'EOF'
server {
    listen 80;
    server_name kod-bezopasnosti.ru www.kod-bezopasnosti.ru 91.229.8.148;

    # Логи
    access_log /var/log/nginx/kod-bezopasnosti.access.log;
    error_log /var/log/nginx/kod-bezopasnosti.error.log;

    # Статические файлы Django
    location /static/ {
        alias /var/www/kod-bezopasnosti/staticfiles/;
        expires 30d;
        add_header Cache-Control "public, immutable";
    }

    # Медиа файлы
    location /media/ {
        alias /var/www/kod-bezopasnosti/media/;
        expires 30d;
        add_header Cache-Control "public, immutable";
    }

    # Основное приложение Django
    location / {
        include proxy_params;
        proxy_pass http://unix:/var/www/kod-bezopasnosti/kodbezopasnosti.sock;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    # Favicon
    location = /favicon.ico {
        access_log off;
        log_not_found off;
    }
}
EOF

echo "--- [ШАГ 2/4] Включаем сайт ---"
ln -sf /etc/nginx/sites-available/kod-bezopasnosti.ru /etc/nginx/sites-enabled/
rm -f /etc/nginx/sites-enabled/default

echo "--- [ШАГ 3/4] Проверяем конфигурацию ---"
nginx -t

echo "--- [ШАГ 4/4] Перезапускаем Nginx ---"
systemctl restart nginx

echo ""
echo "========================================================"
echo "✅ NGINX ИСПРАВЛЕН!"
echo ""
echo "Проверь админку:"
echo "  🌐 http://91.229.8.148/admin/"
echo ""
echo "Если все еще не работает, проверь логи:"
echo "  tail -f /var/log/nginx/kod-bezopasnosti.error.log"
echo "  tail -f /var/log/kodbezopasnosti.err.log"
echo "========================================================"
