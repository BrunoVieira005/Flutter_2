from django.db import models
from django.contrib.auth.models import User

# Classe Produto
class Produto(models.Model):
    CATEGORIAS = [
        ('lanche', 'Lanche'),
        ('pizza', 'Pizza'),
    ]

    nome = models.CharField(max_length=100)
    preco = models.DecimalField(max_digits=10, decimal_places=2)
    categoria = models.CharField(max_length=10, choices=CATEGORIAS)
    imagem_url = models.URLField(max_length=500, blank=True) # URL da foto

    def __str__(self):
        return self.nome


# Classe Pedido
class Pedido(models.Model):
    STATUS_CHOICES = [
        ('P', 'Pendente'),
        ('A', 'Aprovado'),
        ('E', 'Entregue'),
    ]
    
    usuario = models.ForeignKey(User, on_delete=models.CASCADE) # Associação com o Usuário
    endereco_entrega = models.CharField(max_length=255) # O endereço vindo do ViaCEP
    total = models.DecimalField(max_digits=10, decimal_places=2)
    status = models.CharField(max_length=1, choices=STATUS_CHOICES, default='P')
    data_pedido = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"Pedido {self.id} - {self.usuario.username}"

class ItemPedido(models.Model):
    pedido = models.ForeignKey(Pedido, related_name='itens', on_delete=models.CASCADE)
    produto = models.ForeignKey(Produto, on_delete=models.CASCADE)
    quantidade = models.IntegerField(default=1)
    preco_no_momento = models.DecimalField(max_digits=10, decimal_places=2) # Snapshot do preço

    def __str__(self):
        return f"{self.quantidade}x {self.produto.nome}"