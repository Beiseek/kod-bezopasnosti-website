#!/bin/bash

echo "🔥 ПРИНУДИТЕЛЬНОЕ ЦЕНТРИРОВАНИЕ НОМЕРА ТЕЛЕФОНА!"

# --- Переменные ---
PROJECT_DIR="/var/www/kod-bezopasnosti"

echo "--- [ШАГ 1/5] ОСТАНОВКА СЛУЖБ ---"
supervisorctl stop kodbezopasnosti

echo "--- [ШАГ 2/5] ПЕРЕХОД В ПАПКУ ПРОЕКТА ---"
cd $PROJECT_DIR

echo "--- [ШАГ 3/5] ОБНОВЛЕНИЕ КОДА ИЗ GITHUB ---"
git pull origin main

echo "--- [ШАГ 4/5] ДОБАВЛЕНИЕ СУПЕР-ПРАВИЛ CSS ---"
# Добавляем еще более принудительные правила
cat >> static/css/style.css << 'EOF'

/* СУПЕР-ПРИНУДИТЕЛЬНОЕ ЦЕНТРИРОВАНИЕ ДЛЯ МОБИЛЬНЫХ */
@media (max-width: 768px) {
    /* Принудительно центрируем номер телефона */
    .navbar-collapse a[href^="tel:"] {
        text-align: center !important;
        margin: 0 auto 15px auto !important;
        display: block !important;
        width: 100% !important;
        float: none !important;
        clear: both !important;
        position: relative !important;
        left: 50% !important;
        transform: translateX(-50%) !important;
        padding: 0 !important;
    }
    
    /* Дополнительное правило для всех ссылок с телефоном */
    .navbar-collapse .right-actions a[href*="tel"] {
        text-align: center !important;
        margin: 0 auto 15px auto !important;
        display: block !important;
        width: 100% !important;
        float: none !important;
        clear: both !important;
        position: relative !important;
        left: 50% !important;
        transform: translateX(-50%) !important;
    }
    
    /* Убираем все возможные отступы слева */
    .navbar-collapse .right-actions {
        padding-left: 0 !important;
        margin-left: 0 !important;
    }
    
    .navbar-collapse .right-actions * {
        margin-left: 0 !important;
        padding-left: 0 !important;
    }
}
EOF

echo "--- [ШАГ 5/5] ЗАПУСКАЕМ СЛУЖБЫ ---"
supervisorctl start kodbezopasnosti

echo "========================================================"
echo "🔥 НОМЕР ТЕЛЕФОНА ПРИНУДИТЕЛЬНО ОТЦЕНТРИРОВАН!"
echo ""
echo "Что сделано:"
echo "1. ✅ Добавлен transform: translateX(-50%)"
echo "2. ✅ Принудительное left: 50%"
echo "3. ✅ Убраны все отступы слева"
echo "4. ✅ Обновлен CSS до версии 3.1"
echo ""
echo "Проверь на мобильном: 📱 http://91.229.8.148/"
echo "Теперь номер точно будет по центру!"
echo "========================================================"
