#!/bin/bash

# ==============================================================================
#  ИСПРАВЛЕНИЕ СТАТИЧЕСКИХ ФАЙЛОВ - CSS/JS НЕ ЗАГРУЖАЮТСЯ
# ==============================================================================

echo "🎨 ИСПРАВЛЯЕМ СТАТИЧЕСКИЕ ФАЙЛЫ..."

# Переходим в папку проекта
cd /var/www/kod-bezopasnosti

# Активируем виртуальное окружение
source venv/bin/activate

echo "--- [ШАГ 1/8] ОСТАНОВКА СЛУЖБ ---"
supervisorctl stop kodbezopasnosti
systemctl stop nginx

echo "--- [ШАГ 2/8] ОЧИСТКА СТАРЫХ СТАТИЧЕСКИХ ФАЙЛОВ ---"
rm -rf staticfiles/*
rm -rf static/*

echo "--- [ШАГ 3/8] ПРОВЕРЯЕМ НАЛИЧИЕ СТАТИЧЕСКИХ ФАЙЛОВ ---"
echo "CSS файлы:"
ls -la static/css/ 2>/dev/null || echo "Папка static/css не найдена"
echo ""
echo "JS файлы:"
ls -la static/js/ 2>/dev/null || echo "Папка static/js не найдена"
echo ""
echo "Изображения:"
ls -la static/images/ 2>/dev/null || echo "Папка static/images не найдена"

echo "--- [ШАГ 4/8] СОЗДАЕМ ПРАВИЛЬНУЮ КОНФИГУРАЦИЮ NGINX ---"
cat > /etc/nginx/sites-available/kod-bezopasnosti.ru << 'EOF'
server {
    listen 80;
    server_name kod-bezopasnosti.ru www.kod-bezopasnosti.ru 91.229.8.148;

    # Логи
    access_log /var/log/nginx/kod-bezopasnosti.access.log;
    error_log /var/log/nginx/kod-bezopasnosti.error.log;

    # Статические файлы Django - ИСПРАВЛЯЕМ ПУТИ
    location /static/ {
        alias /var/www/kod-bezopasnosti/staticfiles/;
        expires 30d;
        add_header Cache-Control "public, immutable";
        add_header Access-Control-Allow-Origin "*";
    }

    # Медиа файлы
    location /media/ {
        alias /var/www/kod-bezopasnosti/media/;
        expires 30d;
        add_header Cache-Control "public, immutable";
        add_header Access-Control-Allow-Origin "*";
    }

    # Основное приложение Django
    location / {
        proxy_pass http://unix:/var/www/kod-bezopasnosti/kodbezopasnosti.sock;
        proxy_set_header Host 91.229.8.148;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header Connection "";
        proxy_http_version 1.1;
    }

    # Favicon
    location = /favicon.ico {
        access_log off;
        log_not_found off;
    }
}
EOF

echo "--- [ШАГ 5/8] ВКЛЮЧАЕМ САЙТ В NGINX ---"
ln -sf /etc/nginx/sites-available/kod-bezopasnosti.ru /etc/nginx/sites-enabled/
rm -f /etc/nginx/sites-enabled/default

echo "--- [ШАГ 6/8] СОБИРАЕМ СТАТИЧЕСКИЕ ФАЙЛЫ ---"
python manage.py collectstatic --noinput --clear

echo "--- [ШАГ 7/8] ИСПРАВЛЯЕМ ПРАВА ДОСТУПА ---"
chown -R www-data:www-data /var/www/kod-bezopasnosti
chmod -R 755 /var/www/kod-bezopasnosti
chmod -R 644 /var/www/kod-bezopasnosti/staticfiles/*

echo "--- [ШАГ 8/8] ЗАПУСКАЕМ СЛУЖБЫ ---"
supervisorctl start kodbezopasnosti
systemctl start nginx

echo ""
echo "========================================================"
echo "✅ СТАТИЧЕСКИЕ ФАЙЛЫ ИСПРАВЛЕНЫ!"
echo ""
echo "Проверь сайт:"
echo "  🌐 http://91.229.8.148/"
echo ""
echo "Если стили все еще не загружаются, проверь:"
echo "  ls -la /var/www/kod-bezopasnosti/staticfiles/"
echo "  curl -I http://91.229.8.148/static/css/style.css"
echo ""
echo "Логи ошибок:"
echo "  tail -f /var/log/nginx/kod-bezopasnosti.error.log"
echo "========================================================"
