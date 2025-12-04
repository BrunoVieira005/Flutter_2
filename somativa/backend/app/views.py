from django.shortcuts import render

# Create your views here.
from rest_framework import generics, permissions
from django.contrib.auth.models import User
from .serializers import UserSerializer, PedidoSerializer, ProdutoSerializer
from .models import Pedido, Produto
from rest_framework.permissions import AllowAny

# View apenas para registrar novos usuários (Tela B do documento)
class RegisterView(generics.CreateAPIView):
    queryset = User.objects.all()
    permission_classes = (AllowAny,) # Permite que qualquer um (mesmo não logado) se cadastre
    serializer_class = UserSerializer

class ProdutoListView(generics.ListAPIView):
    queryset = Produto.objects.all()
    serializer_class = ProdutoSerializer
    # Exige que o usuário envie o Token para ver a lista
    permission_classes = [permissions.IsAuthenticated]

class PedidoListCreateView(generics.ListCreateAPIView):
    serializer_class = PedidoSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        # Retorna apenas os pedidos do usuário logado
        return Pedido.objects.filter(usuario=self.request.user).order_by('-data_pedido')

    def perform_create(self, serializer):
        # Associa automaticamente o pedido ao usuário logado
        serializer.save(usuario=self.request.user)