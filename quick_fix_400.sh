#!/bin/bash

# ==============================================================================
#  БЫСТРОЕ ИСПРАВЛЕНИЕ ОШИБКИ 400 BAD REQUEST
# ==============================================================================

echo "⚡ БЫСТРОЕ ИСПРАВЛЕНИЕ 400 ОШИБКИ..."

# Переходим в папку проекта
cd /var/www/kod-bezopasnosti

# Активируем виртуальное окружение
source venv/bin/activate

echo "--- [ШАГ 1/4] Включаем DEBUG и разрешаем все хосты ---"
# Временно включаем DEBUG для диагностики
sed -i "s/DEBUG = False/DEBUG = True/" kodbezopasnosti/settings.py

# Разрешаем все хосты
sed -i 's/ALLOWED_HOSTS = \[.*\]/ALLOWED_HOSTS = ["*"]/' kodbezopasnosti/settings.py

echo "--- [ШАГ 2/4] Создаем суперпользователя ---"
python manage.py shell << 'EOF'
from django.contrib.auth.models import User
if not User.objects.filter(username='admin').exists():
    User.objects.create_superuser('admin', 'admin@example.com', 'admin123')
    print("Создан суперпользователь: admin / admin123")
else:
    print("Суперпользователь уже существует")
EOF

echo "--- [ШАГ 3/4] Собираем статические файлы ---"
python manage.py collectstatic --noinput

echo "--- [ШАГ 4/4] Перезапускаем службы ---"
supervisorctl restart kodbezopasnosti
systemctl restart nginx

echo ""
echo "========================================================"
echo "✅ БЫСТРОЕ ИСПРАВЛЕНИЕ ЗАВЕРШЕНО!"
echo ""
echo "Попробуй зайти:"
echo "  🌐 http://91.229.8.148/"
echo "  🌐 http://91.229.8.148/admin/"
echo ""
echo "Логин админки: admin / admin123"
echo ""
echo "Если все еще ошибка, запусти полную диагностику:"
echo "  wget https://raw.githubusercontent.com/Beiseek/kod-bezopasnosti-website/main/debug_400.sh"
echo "  chmod +x debug_400.sh && ./debug_400.sh"
echo "========================================================"
