#!/bin/bash

# ==============================================================================
#  СУПЕР-МЕГА-ФИКС СТАТИЧЕСКИХ ФАЙЛОВ
#  Копирует файлы напрямую и исправляет все
# ==============================================================================

echo "🚀 СУПЕР-МЕГА-ФИКС СТАТИЧЕСКИХ ФАЙЛОВ..."

# Останавливаем ВСЕ службы
echo "--- [ШАГ 1/8] ОСТАНОВКА ВСЕХ СЛУЖБ ---"
supervisorctl stop kodbezopasnosti 2>/dev/null || true
systemctl stop nginx 2>/dev/null || true

# Переходим в папку проекта
cd /var/www/kod-bezopasnosti

# Активируем виртуальное окружение
source venv/bin/activate

echo "--- [ШАГ 2/8] ПЕРЕСОЗДАНИЕ ПАПОК ДЛЯ СТАТИКИ ---"
rm -rf staticfiles
mkdir staticfiles
rm -rf static
git checkout -- static

echo "--- [ШАГ 3/8] СОБИРАЕМ СТАТИКУ АДМИНКИ ---"
python manage.py collectstatic --noinput --clear

echo "--- [ШАГ 4/8] КОПИРУЕМ СТАТИКУ САЙТА НАПРЯМУЮ ---"
# Копируем CSS, JS и изображения в папку, которую видит Nginx
cp -r static/* staticfiles/

echo "--- [ШАГ 5/8] ПРОВЕРКА СКОПИРОВАННЫХ ФАЙЛОВ ---"
echo "Содержимое папки staticfiles:"
ls -lR staticfiles/

echo "--- [ШАГ 6/8] ИСПРАВЛЯЕМ ПРАВА ДОСТУПА ---"
chown -R www-data:www-data /var/www/kod-bezopasnosti
chmod -R 755 /var/www/kod-bezopasnosti

echo "--- [ШАГ 7/8] ПЕРЕЗАПУСКАЕМ GUNICORN ---"
supervisorctl reread
supervisorctl update
supervisorctl start kodbezopasnosti

echo "--- [ШАГ 8/8] ПЕРЕЗАПУСКАЕМ NGINX ---"
systemctl start nginx

echo ""
echo "========================================================"
echo "✅ СУПЕР-МЕГА-ФИКС ЗАВЕРШЕН!"
echo ""
echo "Проверь сайт:"
echo "  🌐 http://91.229.8.148/"
echo "  🌐 http://91.229.8.148/admin/"
echo ""
echo "Если что-то не работает, проверь логи:"
echo "  tail -f /var/log/kodbezopasnosti.err.log"
echo "  tail -f /var/log/nginx/kod-bezopasnosti.error.log"
echo "========================================================"
