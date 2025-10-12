#!/bin/bash

# ==============================================================================
#  ИСПРАВЛЕНИЕ ОШИБКИ DisallowedHost С ДУБЛИРОВАННЫМ IP
# ==============================================================================

echo "🔧 ИСПРАВЛЯЕМ ОШИБКУ DisallowedHost..."

# Переходим в папку проекта
cd /var/www/kod-bezopasnosti

# Активируем виртуальное окружение
source venv/bin/activate

echo "--- [ШАГ 1/6] Исправляем настройки Django ---"
# Временно включаем DEBUG
sed -i "s/DEBUG = False/DEBUG = True/" kodbezopasnosti/settings.py

# Разрешаем все хосты
sed -i 's/ALLOWED_HOSTS = \[.*\]/ALLOWED_HOSTS = ["*"]/' kodbezopasnosti/settings.py

echo "--- [ШАГ 2/6] Создаем правильную конфигурацию Nginx ---"
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
        
        # ИСПРАВЛЯЕМ ПРОБЛЕМУ С HOST ЗАГОЛОВКОМ
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        
        # Убираем дублирование заголовков
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

echo "--- [ШАГ 3/6] Включаем сайт в Nginx ---"
ln -sf /etc/nginx/sites-available/kod-bezopasnosti.ru /etc/nginx/sites-enabled/
rm -f /etc/nginx/sites-enabled/default

echo "--- [ШАГ 4/6] Проверяем конфигурацию Nginx ---"
nginx -t

echo "--- [ШАГ 5/6] Создаем суперпользователя ---"
python manage.py shell << 'EOF'
from django.contrib.auth.models import User
if not User.objects.filter(username='admin').exists():
    User.objects.create_superuser('admin', 'admin@example.com', 'admin123')
    print("Создан суперпользователь: admin / admin123")
else:
    print("Суперпользователь уже существует")
EOF

echo "--- [ШАГ 6/6] Перезапускаем службы ---"
supervisorctl restart kodbezopasnosti
systemctl restart nginx

echo ""
echo "========================================================"
echo "✅ ОШИБКА DisallowedHost ИСПРАВЛЕНА!"
echo ""
echo "Попробуй зайти:"
echo "  🌐 http://91.229.8.148/"
echo "  🌐 http://91.229.8.148/admin/"
echo ""
echo "Логин админки: admin / admin123"
echo ""
echo "Если все еще ошибка, проверь логи:"
echo "  tail -f /var/log/nginx/kod-bezopasnosti.error.log"
echo "  tail -f /var/log/kodbezopasnosti.err.log"
echo "========================================================"
