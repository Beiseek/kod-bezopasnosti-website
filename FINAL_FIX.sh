#!/bin/bash

# ==============================================================================
#  ФИНАЛЬНЫЙ СКРИПТ ИСПРАВЛЕНИЯ ВСЕГО НА СЕРВЕРЕ
#  Переустанавливает проект с нуля и исправляет статику
# ==============================================================================

echo "🔥 ФИНАЛЬНЫЙ СКРИПТ ИСПРАВЛЕНИЯ ЗАПУЩЕН! 🔥"

# --- [ШАГ 1/10] ОСТАНОВКА И УДАЛЕНИЕ СТАРЫХ СЛУЖБ ---
echo "--- [ШАГ 1/10] ОСТАНОВКА И УДАЛЕНИЕ СТАРЫХ СЛУЖБ ---"
supervisorctl stop kodbezopasnosti 2>/dev/null || true
systemctl stop nginx 2>/dev/null || true
rm -f /etc/supervisor/conf.d/kodbezopasnosti.conf
rm -f /etc/nginx/sites-enabled/kod-bezopasnosti.ru
rm -f /etc/nginx/sites-available/kod-bezopasnosti.ru

# --- [ШАГ 2/10] ПОЛНАЯ ОЧИСТКА СТАРОГО ПРОЕКТА ---
echo "--- [ШАГ 2/10] ПОЛНАЯ ОЧИСТКА СТАРОГО ПРОЕКТА ---"
rm -rf /var/www/kod-bezopasnosti

# --- [ШАГ 3/10] КЛОНИРОВАНИЕ РЕПОЗИТОРИЯ ЗАНОВО ---
echo "--- [ШАГ 3/10] КЛОНИРОВАНИЕ РЕПОЗИТОРИЯ ЗАНОВО ---"
git clone https://github.com/Beiseek/kod-bezopasnosti-website.git /var/www/kod-bezopasnosti
cd /var/www/kod-bezopasnosti

# --- [ШАГ 4/10] СОЗДАНИЕ ВИРТУАЛЬНОГО ОКРУЖЕНИЯ И УСТАНОВКА ЗАВИСИМОСТЕЙ ---
echo "--- [ШАГ 4/10] СОЗДАНИЕ ВИРТУАЛЬНОГО ОКРУЖЕНИЯ И УСТАНОВКА ЗАВИСИМОСТЕЙ ---"
python3 -m venv venv
source venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt
pip install gunicorn

# --- [ШАГ 5/10] ПРАВИЛЬНАЯ НАСТРОЙКА SETTINGS.PY ---
echo "--- [ШАГ 5/10] ПРАВИЛЬНАЯ НАСТРОЙКА SETTINGS.PY ---"
sed -i "s/DEBUG = True/DEBUG = False/" kodbezopasnosti/settings.py
sed -i "s/ALLOWED_HOSTS = \[\]/ALLOWED_HOSTS = ['91.229.8.148', 'kod-bezopasnosti.ru', 'www.kod-bezopasnosti.ru']/" kodbezopasnosti/settings.py

# --- [ШАГ 6/10] МИГРАЦИИ И СОЗДАНИЕ СУПЕРПОЛЬЗОВАТЕЛЯ ---
echo "--- [ШАГ 6/10] МИГРАЦИИ И СОЗДАНИЕ СУПЕРПОЛЬЗОВАТЕЛЯ ---"
python manage.py migrate
python manage.py shell << 'EOF'
from django.contrib.auth.models import User
if not User.objects.filter(username='admin').exists():
    User.objects.create_superuser('admin', 'admin@example.com', 'admin123')
EOF

# --- [ШАГ 7/10] ПРАВИЛЬНЫЙ СБОР СТАТИКИ ---
echo "--- [ШАГ 7/10] ПРАВИЛЬНЫЙ СБОР СТАТИКИ ---"
# Сначала собираем статику админки
python manage.py collectstatic --noinput --clear
# Затем копируем статику сайта НАПРЯМУЮ
cp -r static/* staticfiles/

# --- [ШАГ 8/10] НАСТРОЙКА GUNICORN И SUPERVISOR ---
echo "--- [ШАГ 8/10] НАСТРОЙКА GUNICORN И SUPERVISOR ---"
cat > /etc/supervisor/conf.d/kodbezopasnosti.conf << 'EOF'
[program:kodbezopasnosti]
command=/var/www/kod-bezopasnosti/venv/bin/gunicorn --workers 3 --bind unix:/var/www/kod-bezopasnosti/kodbezopasnosti.sock kodbezopasnosti.wsgi:application
directory=/var/www/kod-bezopasnosti
user=root
autostart=true
autorestart=true
stderr_logfile=/var/log/kodbezopasnosti.err.log
stdout_logfile=/var/log/kodbezopasnosti.out.log
EOF

# --- [ШАГ 9/10] НАСТРОЙКА NGINX ---
echo "--- [ШАГ 9/10] НАСТРОЙКА NGINX ---"
cat > /etc/nginx/sites-available/kod-bezopasnosti.ru << 'EOF'
server {
    listen 80;
    server_name kod-bezopasnosti.ru www.kod-bezopasnosti.ru 91.229.8.148;

    location /static/ {
        alias /var/www/kod-bezopasnosti/staticfiles/;
    }

    location /media/ {
        alias /var/www/kod-bezopasnosti/media/;
    }

    location / {
        proxy_pass http://unix:/var/www/kod-bezopasnosti/kodbezopasnosti.sock;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
EOF
ln -sf /etc/nginx/sites-available/kod-bezopasnosti.ru /etc/nginx/sites-enabled/
nginx -t

# --- [ШАГ 10/10] ЗАПУСК ВСЕХ СЛУЖБ ---
echo "--- [ШАГ 10/10] ЗАПУСК ВСЕХ СЛУЖБ ---"
supervisorctl reread
supervisorctl update
supervisorctl start kodbezopasnosti
systemctl restart nginx

echo ""
echo "========================================================"
echo "✅ ФИНАЛЬНЫЙ ФИКС ЗАВЕРШЕН!"
echo "✅ ВСЕ ДОЛЖНО РАБОТАТЬ!"
echo ""
echo "Проверь сайт: http://91.229.8.148/"
echo "Проверь админку: http://91.229.8.148/admin/ (admin / admin123)"
echo "========================================================"
