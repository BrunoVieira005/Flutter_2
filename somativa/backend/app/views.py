from django.shortcuts import render

# Create your views here.
from rest_framework import generics
from django.contrib.auth.models import User
from .serializers import UserSerializer
from rest_framework.permissions import AllowAny

# View apenas para registrar novos usuários (Tela B do documento)
class RegisterView(generics.CreateAPIView):
    queryset = User.objects.all()
    permission_classes = (AllowAny,) # Permite que qualquer um (mesmo não logado) se cadastre
    serializer_class = UserSerializer