from django.shortcuts import render, redirect, get_object_or_404
from django.contrib import messages
from django.core.mail import send_mail, get_connection
from django.conf import settings
from .forms import ConsultationRequestForm
from .models import TextPage


def send_consultation_email(consultation):
    """Отправка уведомления о новой заявке на email (без права уронить запрос)."""
    try:
        safe_name = (getattr(consultation, 'name', '') or '').strip()
        safe_phone = (getattr(consultation, 'phone', '') or '').strip()
        safe_email = (getattr(consultation, 'email', '') or '')
        safe_message = (getattr(consultation, 'message', '') or '')
        # Категория может быть пустой/нестандартной — не ломаемся
        try:
            safe_category = consultation.get_category_display()
        except Exception:
            safe_category = getattr(consultation, 'category', '') or ''
        # Дата создаётся на save(); если что — не падаем
        try:
            safe_created = consultation.created_at.strftime('%d.%m.%Y %H:%M')
        except Exception:
            safe_created = ''

        subject_base = f'Новая заявка на консультацию от {safe_name}'.strip()
        subject = subject_base or 'Новая заявка на консультацию'

        message = (
            "Новая заявка на консультацию:\n\n"
            f"Имя: {safe_name}\n"
            f"Телефон: {safe_phone}\n"
            f"Email: {safe_email or 'Не указан'}\n"
            f"Категория: {safe_category or '—'}\n"
            f"Сообщение: {safe_message or 'Не указано'}\n"
            f"Дата: {safe_created}\n\n"
            "Ссылка на админку: https://kod-bezopasnosti.ru/admin/main/consultationrequest/\n"
        )

        # Используем явное подключение для таймаута
        connection = get_connection(timeout=getattr(settings, 'EMAIL_TIMEOUT', 10))
        send_mail(
            subject,
            message,
            settings.DEFAULT_FROM_EMAIL,
            ['923sen@mail.ru'],
            fail_silently=True,
            connection=connection,
        )
    except Exception:
        # Никогда не пробрасываем ошибку наружу
        pass


def home(request):
    """Главная страница"""
    if request.method == 'POST':
        form = ConsultationRequestForm(request.POST)
        if form.is_valid():
            consultation = form.save(commit=False)
            # Страхуемся от специфики некоторых браузеров (Яндекс)
            consultation.email = consultation.email or None
            consultation.message = consultation.message or ''
            consultation.save()
            send_consultation_email(consultation)
            messages.success(request, 'Спасибо! Ваша заявка принята. Мы свяжемся с вами в ближайшее время.')
            return redirect('home')
    else:
        form = ConsultationRequestForm(initial={'category': 'general'})
    
    return render(request, 'main/home.html', {'form': form})


def business(request):
    """Страница для бизнеса"""
    if request.method == 'POST':
        form = ConsultationRequestForm(request.POST)
        if form.is_valid():
            consultation = form.save(commit=False)
            consultation.email = consultation.email or None
            consultation.message = consultation.message or ''
            consultation.save()
            send_consultation_email(consultation)
            messages.success(request, 'Спасибо! Ваша заявка принята. Мы свяжемся с вами в ближайшее время.')
            return redirect('business')
    else:
        form = ConsultationRequestForm(initial={'category': 'business'})
    
    return render(request, 'main/business.html', {'form': form})


def industry(request):
    """Страница для промышленности"""
    if request.method == 'POST':
        form = ConsultationRequestForm(request.POST)
        if form.is_valid():
            consultation = form.save(commit=False)
            consultation.email = consultation.email or None
            consultation.message = consultation.message or ''
            consultation.save()
            send_consultation_email(consultation)
            messages.success(request, 'Спасибо! Ваша заявка принята. Мы свяжемся с вами в ближайшее время.')
            return redirect('industry')
    else:
        form = ConsultationRequestForm(initial={'category': 'industry'})
    
    return render(request, 'main/industry.html', {'form': form})


def city(request):
    """Страница для города"""
    if request.method == 'POST':
        form = ConsultationRequestForm(request.POST)
        if form.is_valid():
            consultation = form.save(commit=False)
            consultation.email = consultation.email or None
            consultation.message = consultation.message or ''
            consultation.save()
            send_consultation_email(consultation)
            messages.success(request, 'Спасибо! Ваша заявка принята. Мы свяжемся с вами в ближайшее время.')
            return redirect('city')
    else:
        form = ConsultationRequestForm(initial={'category': 'city'})
    
    return render(request, 'main/city.html', {'form': form})


def housing(request):
    """Страница для жилых комплексов"""
    if request.method == 'POST':
        form = ConsultationRequestForm(request.POST)
        if form.is_valid():
            consultation = form.save(commit=False)
            consultation.email = consultation.email or None
            consultation.message = consultation.message or ''
            consultation.save()
            send_consultation_email(consultation)
            messages.success(request, 'Спасибо! Ваша заявка принята. Мы свяжемся с вами в ближайшее время.')
            return redirect('housing')
    else:
        form = ConsultationRequestForm(initial={'category': 'housing'})
    
    return render(request, 'main/housing.html', {'form': form})


def contacts(request):
    """Страница контактов"""
    if request.method == 'POST':
        form = ConsultationRequestForm(request.POST)
        if form.is_valid():
            consultation = form.save(commit=False)
            consultation.email = consultation.email or None
            consultation.message = consultation.message or ''
            consultation.save()
            send_consultation_email(consultation)
            messages.success(request, 'Спасибо! Ваша заявка принята. Мы свяжемся с вами в ближайшее время.')
            return redirect('contacts')
    else:
        form = ConsultationRequestForm(initial={'category': 'general'})
    
    return render(request, 'main/contacts.html', {'form': form})


def text_page_view(request, page_slug):
    page = get_object_or_404(TextPage, slug=page_slug)
    return render(request, 'main/text_page.html', {'page': page})
