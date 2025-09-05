class Aluno {
  final int? id; // nulo ao criar autoincrement
  final String nome;
  final int nota;
  final String materia;
  Aluno(
      {this.id, required this.nome, required this.nota, required this.materia});

  Aluno copyWith({int? id, String? nome, int? nota, String? materia}) {
    return Aluno(
        id: id ?? this.id,
        nome: nome ?? this.nome,
        nota: nota ?? this.nota,
        materia: materia ?? this.materia);
  }

  // Map
  Map<String, dynamic> toMap() =>
      {'id': id, 'nome': nome, 'nota': nota, 'materia': materia};

  factory Aluno.fromMap(Map<String, dynamic> map) => Aluno(
      id: map['id'] as int?,
      nome: map['nome'] as String,
      nota: map['nota'] as int,
      materia: map['materia'] as String);
}
