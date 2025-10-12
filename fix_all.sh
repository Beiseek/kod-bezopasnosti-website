#!/bin/bash

# ==============================================================================
#  ПОЛНЫЙ СКРИПТ ИСПРАВЛЕНИЯ DJANGO НА СЕРВЕРЕ
# ==============================================================================

echo "🚀 ПОЛНОЕ ИСПРАВЛЕНИЕ DJANGO НА СЕРВЕРЕ..."

# Переходим в папку проекта
cd /var/www/kod-bezopasnosti

# Активируем виртуальное окружение
source venv/bin/activate

echo "--- [ШАГ 1/8] Исправляем настройки Django ---"
# Исправляем ALLOWED_HOSTS
sed -i "s/ALLOWED_HOSTS = \[\]/ALLOWED_HOSTS = ['kod-bezopasnosti.ru', 'www.kod-bezopasnosti.ru', '91.229.8.148', 'localhost', '127.0.0.1']/" kodbezopasnosti/settings.py
sed -i "s/DEBUG = True/DEBUG = False/" kodbezopasnosti/settings.py

echo "--- [ШАГ 2/8] Очищаем старые файлы ---"
rm -rf staticfiles/*
rm -rf static/*

echo "--- [ШАГ 3/8] Собираем статические файлы ---"
python manage.py collectstatic --noinput --clear

echo "--- [ШАГ 4/8] Исправляем права доступа ---"
chown -R www-data:www-data /var/www/kod-bezopasnosti
chmod -R 755 /var/www/kod-bezopasnosti

echo "--- [ШАГ 5/8] Создаем правильную конфигурацию Nginx ---"
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

echo "--- [ШАГ 6/8] Включаем сайт в Nginx ---"
ln -sf /etc/nginx/sites-available/kod-bezopasnosti.ru /etc/nginx/sites-enabled/
rm -f /etc/nginx/sites-enabled/default

echo "--- [ШАГ 7/8] Проверяем конфигурацию Nginx ---"
nginx -t

echo "--- [ШАГ 8/8] Перезапускаем все службы ---"
supervisorctl restart kodbezopasnosti
systemctl restart nginx

echo ""
echo "========================================================"
echo "✅ ВСЕ ИСПРАВЛЕНО!"
echo ""
echo "Проверь сайт:"
echo "  🌐 http://91.229.8.148/"
echo "  🌐 http://91.229.8.148/admin/"
echo ""
echo "Если что-то не работает, проверь логи:"
echo "  tail -f /var/log/nginx/kod-bezopasnosti.error.log"
echo "  tail -f /var/log/kodbezopasnosti.err.log"
echo "========================================================"
