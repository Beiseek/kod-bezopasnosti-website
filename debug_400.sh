#!/bin/bash

# ==============================================================================
#  СКРИПТ ДИАГНОСТИКИ И ИСПРАВЛЕНИЯ ОШИБКИ 400 BAD REQUEST
# ==============================================================================

echo "🔍 ДИАГНОСТИРУЕМ ОШИБКУ 400 BAD REQUEST..."

# Переходим в папку проекта
cd /var/www/kod-bezopasnosti

# Активируем виртуальное окружение
source venv/bin/activate

echo "--- [ШАГ 1/8] Проверяем настройки Django ---"
echo "DEBUG = $(grep 'DEBUG =' kodbezopasnosti/settings.py)"
echo "ALLOWED_HOSTS = $(grep 'ALLOWED_HOSTS' kodbezopasnosti/settings.py)"

echo "--- [ШАГ 2/8] Временно включаем DEBUG для диагностики ---"
sed -i "s/DEBUG = False/DEBUG = True/" kodbezopasnosti/settings.py

echo "--- [ШАГ 3/8] Добавляем все возможные хосты ---"
cat > /tmp/allowed_hosts.py << 'EOF'
ALLOWED_HOSTS = [
    'kod-bezopasnosti.ru',
    'www.kod-bezopasnosti.ru', 
    '91.229.8.148',
    'localhost',
    '127.0.0.1',
    '*'
]
EOF

# Заменяем ALLOWED_HOSTS
sed -i '/ALLOWED_HOSTS = \[/,/\]/c\
ALLOWED_HOSTS = [\
    "kod-bezopasnosti.ru",\
    "www.kod-bezopasnosti.ru",\
    "91.229.8.148",\
    "localhost",\
    "127.0.0.1",\
    "*"\
]' kodbezopasnosti/settings.py

echo "--- [ШАГ 4/8] Проверяем миграции ---"
python manage.py showmigrations

echo "--- [ШАГ 5/8] Создаем суперпользователя (если нужно) ---"
echo "from django.contrib.auth.models import User; User.objects.filter(username='admin').exists() or User.objects.create_superuser('admin', 'admin@example.com', 'admin123')" | python manage.py shell

echo "--- [ШАГ 6/8] Собираем статические файлы ---"
python manage.py collectstatic --noinput

echo "--- [ШАГ 7/8] Перезапускаем Gunicorn ---"
supervisorctl restart kodbezopasnosti

echo "--- [ШАГ 8/8] Проверяем логи ---"
echo "=== ЛОГИ GUNICORN ==="
tail -n 20 /var/log/kodbezopasnosti.err.log
echo ""
echo "=== ЛОГИ NGINX ==="
tail -n 20 /var/log/nginx/kod-bezopasnosti.error.log

echo ""
echo "========================================================"
echo "✅ ДИАГНОСТИКА ЗАВЕРШЕНА!"
echo ""
echo "Попробуй зайти:"
echo "  🌐 http://91.229.8.148/"
echo "  🌐 http://91.229.8.148/admin/"
echo ""
echo "Логин админки: admin / admin123"
echo ""
echo "Если все еще ошибка 400, проверь:"
echo "  tail -f /var/log/kodbezopasnosti.err.log"
echo "  tail -f /var/log/nginx/kod-bezopasnosti.error.log"
echo "========================================================"
