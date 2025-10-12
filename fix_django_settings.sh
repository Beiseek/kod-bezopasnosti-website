#!/bin/bash

# ==============================================================================
#  ИСПРАВЛЕНИЕ НАСТРОЕК DJANGO ДЛЯ ПРОДАКШЕНА
# ==============================================================================

echo "🔧 ИСПРАВЛЯЕМ НАСТРОЙКИ DJANGO..."

# Переходим в папку проекта
cd /var/www/kod-bezopasnosti

# Активируем виртуальное окружение
source venv/bin/activate

echo "--- [ШАГ 1/5] Создаем правильные настройки Django ---"
cat > kodbezopasnosti/settings.py << 'EOF'
"""
Django settings for kodbezopasnosti project.
"""

from pathlib import Path

# Build paths inside the project like this: BASE_DIR / 'subdir'.
BASE_DIR = Path(__file__).resolve().parent.parent

# SECURITY WARNING: keep the secret key used in production secret!
SECRET_KEY = 'django-insecure-n9l-5-lab(bhho6z+bl9j354x5gjwf#9s^z9+sn-8omzgz-#e-'

# SECURITY WARNING: don't run with debug turned on in production!
DEBUG = True

ALLOWED_HOSTS = [
    'kod-bezopasnosti.ru',
    'www.kod-bezopasnosti.ru',
    '91.229.8.148',
    'localhost',
    '127.0.0.1',
    '*'
]

# Application definition
INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'main',
]

MIDDLEWARE = [
    'django.middleware.security.SecurityMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
]

ROOT_URLCONF = 'kodbezopasnosti.urls'

TEMPLATES = [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        'DIRS': [BASE_DIR / 'templates'],
        'APP_DIRS': True,
        'OPTIONS': {
            'context_processors': [
                'django.template.context_processors.debug',
                'django.template.context_processors.request',
                'django.contrib.auth.context_processors.auth',
                'django.contrib.messages.context_processors.messages',
                'main.context_processors.site_images',
            ],
        },
    },
]

WSGI_APPLICATION = 'kodbezopasnosti.wsgi.application'

# Database
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': BASE_DIR / 'db.sqlite3',
    }
}

# Password validation
AUTH_PASSWORD_VALIDATORS = [
    {
        'NAME': 'django.contrib.auth.password_validation.UserAttributeSimilarityValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.MinimumLengthValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.CommonPasswordValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.NumericPasswordValidator',
    },
]

# Internationalization
LANGUAGE_CODE = 'ru-ru'
TIME_ZONE = 'Asia/Omsk'
USE_I18N = True
USE_TZ = True

# Static files (CSS, JavaScript, Images)
STATIC_URL = 'static/'
STATICFILES_DIRS = [BASE_DIR / 'static']
STATIC_ROOT = BASE_DIR / 'staticfiles'

MEDIA_URL = 'media/'
MEDIA_ROOT = BASE_DIR / 'media'

# Default primary key field type
DEFAULT_AUTO_FIELD = 'django.db.models.BigAutoField'
EOF

echo "--- [ШАГ 2/5] Выполняем миграции ---"
python manage.py migrate

echo "--- [ШАГ 3/5] Создаем суперпользователя ---"
python manage.py shell << 'EOF'
from django.contrib.auth.models import User
if not User.objects.filter(username='admin').exists():
    User.objects.create_superuser('admin', 'admin@example.com', 'admin123')
    print("Создан суперпользователь: admin / admin123")
else:
    print("Суперпользователь уже существует")
EOF

echo "--- [ШАГ 4/5] Собираем статические файлы ---"
python manage.py collectstatic --noinput

echo "--- [ШАГ 5/5] Перезапускаем службы ---"
supervisorctl restart kodbezopasnosti
systemctl restart nginx

echo ""
echo "========================================================"
echo "✅ НАСТРОЙКИ DJANGO ИСПРАВЛЕНЫ!"
echo ""
echo "Попробуй зайти:"
echo "  🌐 http://91.229.8.148/"
echo "  🌐 http://91.229.8.148/admin/"
echo ""
echo "Логин админки: admin / admin123"
echo "========================================================"
