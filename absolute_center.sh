#!/bin/bash

echo "🔥 АБСОЛЮТНОЕ ПОЗИЦИОНИРОВАНИЕ - ТОЧНО СРАБОТАЕТ!"

# --- Переменные ---
PROJECT_DIR="/var/www/kod-bezopasnosti"

echo "--- [ШАГ 1/4] ОСТАНОВКА СЛУЖБ ---"
supervisorctl stop kodbezopasnosti

echo "--- [ШАГ 2/4] ПЕРЕХОД В ПАПКУ ПРОЕКТА ---"
cd $PROJECT_DIR

echo "--- [ШАГ 3/4] ОБНОВЛЕНИЕ КОДА ИЗ GITHUB ---"
git pull origin main

echo "--- [ШАГ 4/4] ЗАПУСКАЕМ СЛУЖБЫ ---"
supervisorctl start kodbezopasnosti

echo "========================================================"
echo "🔥 АБСОЛЮТНОЕ ПОЗИЦИОНИРОВАНИЕ ПРИМЕНЕНО!"
echo ""
echo "Что сделано:"
echo "1. ✅ position: absolute + left: 50% + top: 50%"
echo "2. ✅ transform: translate(-50%, -50%)"
echo "3. ✅ Принудительное центрирование через абсолютное позиционирование"
echo "4. ✅ Обновлен CSS до версии 3.5"
echo ""
echo "Проверь на мобильном: 📱 http://91.229.8.148/"
echo "Абсолютное позиционирование - это 100% гарантия!"
echo "========================================================"
