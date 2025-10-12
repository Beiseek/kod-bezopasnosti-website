from django.shortcuts import render, redirect, get_object_or_404
from django.contrib import messages
from .forms import ConsultationRequestForm
from .models import TextPage


def home(request):
    """Главная страница"""
    if request.method == 'POST':
        form = ConsultationRequestForm(request.POST)
        if form.is_valid():
            form.save()
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
            form.save()
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
            form.save()
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
            form.save()
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
            form.save()
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
            form.save()
            messages.success(request, 'Спасибо! Ваша заявка принята. Мы свяжемся с вами в ближайшее время.')
            return redirect('contacts')
    else:
        form = ConsultationRequestForm(initial={'category': 'general'})
    
    return render(request, 'main/contacts.html', {'form': form})


def text_page_view(request, page_slug):
    page = get_object_or_404(TextPage, slug=page_slug)
    return render(request, 'main/text_page.html', {'page': page})
