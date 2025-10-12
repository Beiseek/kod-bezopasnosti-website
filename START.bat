@echo off
echo ========================================
echo    Код Безопасности - Запуск сервера
echo ========================================
echo.
echo Активация виртуального окружения...
call venv\Scripts\activate
echo.
echo Запуск Django сервера...
echo.
echo Сайт будет доступен по адресу: http://127.0.0.1:8000/
echo Админка: http://127.0.0.1:8000/admin/
echo.
echo Логин админки: admin
echo Пароль: admin123
echo.
echo Для остановки сервера нажмите Ctrl+C
echo ========================================
echo.
py manage.py runserver
pause

