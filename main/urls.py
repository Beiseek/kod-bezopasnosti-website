from django.urls import path
from . import views

urlpatterns = [
    path('', views.home, name='home'),
    path('business/', views.business, name='business'),
    path('industry/', views.industry, name='industry'),
    path('city/', views.city, name='city'),
    path('housing/', views.housing, name='housing'),
    path('contacts/', views.contacts, name='contacts'),
    path('info/<slug:page_slug>/', views.text_page_view, name='text_page'),
]

