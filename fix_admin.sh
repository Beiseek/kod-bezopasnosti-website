#!/bin/bash

# ==============================================================================
#  Скрипт для исправления админки Django на сервере
# ==============================================================================

echo "🔧 ИСПРАВЛЯЕМ АДМИНКУ DJANGO..."

# Переходим в папку проекта
cd /var/www/kod-bezopasnosti

# Активируем виртуальное окружение
source venv/bin/activate

echo "--- [ШАГ 1/4] Исправляем настройки Django ---"
# Исправляем ALLOWED_HOSTS
sed -i "s/ALLOWED_HOSTS = \[\]/ALLOWED_HOSTS = ['kod-bezopasnosti.ru', 'www.kod-bezopasnosti.ru', '91.229.8.148', 'localhost', '127.0.0.1']/" kodbezopasnosti/settings.py
sed -i "s/DEBUG = True/DEBUG = False/" kodbezopasnosti/settings.py

echo "--- [ШАГ 2/4] Собираем статические файлы ---"
python manage.py collectstatic --noinput

echo "--- [ШАГ 3/4] Перезапускаем Gunicorn ---"
supervisorctl restart kodbezopasnosti

echo "--- [ШАГ 4/4] Перезапускаем Nginx ---"
systemctl restart nginx

echo ""
echo "========================================================"
echo "✅ АДМИНКА ИСПРАВЛЕНА!"
echo ""
echo "Попробуй зайти в админку:"
echo "  🌐 http://91.229.8.148/admin/"
echo "  🌐 http://kod-bezopasnosti.ru/admin/"
echo ""
echo "Если не работает, проверь логи:"
echo "  tail -f /var/log/kodbezopasnosti.err.log"
echo "  tail -f /var/log/kodbezopasnosti.out.log"
echo "========================================================"
