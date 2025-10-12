#!/bin/bash

# ==============================================================================
#  ПРОВЕРКА СТАТИЧЕСКИХ ФАЙЛОВ
# ==============================================================================

echo "🔍 ПРОВЕРЯЕМ СТАТИЧЕСКИЕ ФАЙЛЫ..."

# Переходим в папку проекта
cd /var/www/kod-bezopasnosti

echo "--- [ШАГ 1/6] ПРОВЕРЯЕМ СТРУКТУРУ ПРОЕКТА ---"
echo "Структура проекта:"
ls -la

echo ""
echo "--- [ШАГ 2/6] ПРОВЕРЯЕМ СТАТИЧЕСКИЕ ФАЙЛЫ ---"
echo "Папка static:"
ls -la static/ 2>/dev/null || echo "Папка static не найдена"

echo ""
echo "Папка staticfiles:"
ls -la staticfiles/ 2>/dev/null || echo "Папка staticfiles не найдена"

echo ""
echo "--- [ШАГ 3/6] ПРОВЕРЯЕМ CSS ФАЙЛЫ ---"
echo "CSS файлы в static:"
find static/ -name "*.css" 2>/dev/null || echo "CSS файлы в static не найдены"

echo ""
echo "CSS файлы в staticfiles:"
find staticfiles/ -name "*.css" 2>/dev/null || echo "CSS файлы в staticfiles не найдены"

echo ""
echo "--- [ШАГ 4/6] ПРОВЕРЯЕМ JS ФАЙЛЫ ---"
echo "JS файлы в static:"
find static/ -name "*.js" 2>/dev/null || echo "JS файлы в static не найдены"

echo ""
echo "JS файлы в staticfiles:"
find staticfiles/ -name "*.js" 2>/dev/null || echo "JS файлы в staticfiles не найдены"

echo ""
echo "--- [ШАГ 5/6] ПРОВЕРЯЕМ ДОСТУПНОСТЬ ЧЕРЕЗ HTTP ---"
echo "Проверяем доступность CSS:"
curl -I http://91.229.8.148/static/css/style.css 2>/dev/null || echo "CSS файл недоступен"

echo ""
echo "Проверяем доступность JS:"
curl -I http://91.229.8.148/static/js/main.js 2>/dev/null || echo "JS файл недоступен"

echo ""
echo "--- [ШАГ 6/6] ПРОВЕРЯЕМ КОНФИГУРАЦИЮ NGINX ---"
echo "Конфигурация Nginx:"
cat /etc/nginx/sites-available/kod-bezopasnosti.ru | grep -A 10 "location /static/"

echo ""
echo "========================================================"
echo "✅ ПРОВЕРКА ЗАВЕРШЕНА!"
echo ""
echo "Если файлы не найдены, запусти:"
echo "  ./fix_static_files.sh"
echo "========================================================"
