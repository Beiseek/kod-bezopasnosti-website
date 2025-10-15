from django.shortcuts import render, redirect, get_object_or_404
from django.contrib import messages
from django.core.mail import send_mail
from django.conf import settings
from .forms import ConsultationRequestForm
from .models import TextPage


def send_consultation_email(consultation):
    """Отправка уведомления о новой заявке на email"""
    try:
        subject = f'Новая заявка на консультацию от {consultation.name}'
        message = f"""
Новая заявка на консультацию:

Имя: {consultation.name}
Телефон: {consultation.phone}
Email: {consultation.email or 'Не указан'}
Категория: {consultation.get_category_display()}
Сообщение: {consultation.message or 'Не указано'}
Дата: {consultation.created_at.strftime('%d.%m.%Y %H:%M')}

Ссылка на админку: http://91.229.8.148/admin/main/consultationrequest/
        """
        
        send_mail(
            subject,
            message,
            settings.DEFAULT_FROM_EMAIL,
            ['923sen@mail.ru'],
            fail_silently=True,
            timeout=getattr(settings, 'EMAIL_TIMEOUT', 10),
        )
    except Exception as e:
        print(f"Ошибка отправки email: {e}")


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
