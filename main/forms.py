from django import forms
from .models import ConsultationRequest

class ConsultationRequestForm(forms.ModelForm):
    agree_policy = forms.BooleanField(
        label="",
        required=True,
        widget=forms.CheckboxInput(attrs={'class': 'form-check-input'})
    )
    agree_processing = forms.BooleanField(
        label="",
        required=True,
        widget=forms.CheckboxInput(attrs={'class': 'form-check-input'})
    )

    class Meta:
        model = ConsultationRequest
        fields = ['name', 'phone', 'email', 'message', 'category']
        exclude = ['agree_policy', 'agree_processing']
        widgets = {
            'name': forms.TextInput(attrs={'class': 'form-control', 'placeholder': 'Ваше имя'}),
            'phone': forms.TextInput(attrs={'class': 'form-control phone-mask', 'placeholder': '+7 (XXX) XXX-XX-XX'}),
            'email': forms.EmailInput(attrs={'class': 'form-control', 'placeholder': 'Ваш Email (необязательно)', 'required': False}),
            'message': forms.Textarea(attrs={'class': 'form-control', 'rows': 3, 'placeholder': 'Ваше сообщение (необязательно)'}),
            'category': forms.HiddenInput(),
        }
        labels = {
            'name': 'Имя',
            'phone': 'Телефон',
            'email': 'Email',
            'message': 'Сообщение',
        }

