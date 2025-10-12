#!/bin/bash

# ==============================================================================
#  Скрипт для исправления админки Django на сервере
# ==============================================================================

echo "🔧 ИСПРАВЛЯЕМ АДМИНКУ DJANGO..."

# Переходим в папку проекта
cd /var/www/kod-bezopasnosti

# Активируем виртуальное окружение
source venv/bin/activate

echo "--- [ШАГ 1/6] Исправляем настройки Django ---"
# Исправляем ALLOWED_HOSTS
sed -i "s/ALLOWED_HOSTS = \[\]/ALLOWED_HOSTS = ['kod-bezopasnosti.ru', 'www.kod-bezopasnosti.ru', '91.229.8.148', 'localhost', '127.0.0.1']/" kodbezopasnosti/settings.py
sed -i "s/DEBUG = True/DEBUG = False/" kodbezopasnosti/settings.py

echo "--- [ШАГ 2/6] Удаляем старые статические файлы ---"
rm -rf staticfiles/*
rm -rf static/*

echo "--- [ШАГ 3/6] Собираем статические файлы заново ---"
python manage.py collectstatic --noinput --clear

echo "--- [ШАГ 4/6] Проверяем права доступа ---"
chown -R www-data:www-data /var/www/kod-bezopasnosti
chmod -R 755 /var/www/kod-bezopasnosti

echo "--- [ШАГ 5/6] Перезапускаем Gunicorn ---"
supervisorctl restart kodbezopasnosti

echo "--- [ШАГ 6/6] Перезапускаем Nginx ---"
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
