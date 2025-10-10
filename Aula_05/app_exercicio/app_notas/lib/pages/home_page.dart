import 'package:app_notas/data/aluno_class.dart';
import 'package:app_notas/models/alunos.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _aluno =
      Aluno_Dao(); // variavel que irá permitir a manipulação dos dados
  final _nomeCtrl = TextEditingController();
  final _notaCtrl = TextEditingController();
  final _materiaCtrl = TextEditingController();
  final _searchCtrl = TextEditingController();

  Aluno? _editing; // null = inserindo, not null editando

  Future<List<Aluno>>?
      _futureAluno; // vai carregar os Alunos salvos no banco de dados

  @override
  void initState() {
    super.initState();
    _reload();
  }

  void _reload() {
    setState(() {
      final q = _searchCtrl.text.trim(); // trim remove os espaços em branco
      _futureAluno = q.isEmpty ? _aluno.getAll() : _aluno.searchByName(q);
    });
  }

  void _clearForm() {
    _nomeCtrl.clear();
    _notaCtrl.clear();
    _materiaCtrl.clear();
    _editing = null;
  }

  void _edit(Aluno aluno) {
    setState(() {
      _editing = aluno;
      _nomeCtrl.text = aluno.nome;
      _notaCtrl.text = aluno.nota.toString();
      _materiaCtrl.text = aluno.materia;
    });
  }

  Future<void> _save() async {
    final nome = _nomeCtrl.text.trim();
    final notaStr = _notaCtrl.text.trim();
    final matStr = _materiaCtrl.text.trim();

    if (nome.isEmpty || notaStr.isEmpty || matStr.isEmpty) {
      _snack('Preencha todos os campos.');
      return;
    }

    final nota = int.tryParse(notaStr);
    if (nota == null) {
      _snack('Nota precisa ser um numero inteiro');
      return;
    }

    if (_editing == null) {
      await _aluno.insert(Aluno(nome: nome, nota: nota, materia: matStr));
      _snack('Aluno cadastrado');
    } else {
      await _aluno
          .update(_editing!.copyWith(nome: nome, nota: nota, materia: matStr));
      _snack('Aluno atualizado');
    }
    _clearForm();
    _reload();
  }

  Future<void> _delete(int id) async {
    await _aluno.delete(id);
    _snack('Aluno removido');
    _reload();
  }

  void _cancelEdit() {
    _clearForm();
    _snack('Edição cancelada');
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  void dispose() {
    _nomeCtrl.dispose();
    _notaCtrl.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = _editing != null;
    return Scaffold(
      appBar: AppBar(
        title: Text('App aula 05 - Alunos BD - SQFLITE'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              controller: _searchCtrl,
              decoration: InputDecoration(
                labelText: 'Busca por nome',
                hintText: 'Ex. João',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                    tooltip: 'Limpar busca',
                    onPressed: () {
                      _searchCtrl.clear();
                      _reload();
                    },
                    icon: Icon(Icons.clear)),
              ),
              onChanged: (_) => _reload(),
            ),
          ),
          TextField(
            controller: _nomeCtrl,
            decoration: InputDecoration(
                labelText: 'Nome do Aluno', border: OutlineInputBorder()),
            textInputAction: TextInputAction.next,
          ),
          SizedBox(
            height: 12,
          ),
          TextField(
            controller: _notaCtrl,
            decoration: InputDecoration(
              labelText: 'Nota',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          SizedBox(
            height: 12,
          ),
          TextField(
            controller: _materiaCtrl,
            decoration: InputDecoration(
              labelText: 'Matéria',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(
            height: 12,
          ),
          Row(
            children: [
              Expanded(
                  child: FilledButton.icon(
                      onPressed: _save,
                      icon: Icon(isEditing ? Icons.save : Icons.add),
                      label:
                          Text(isEditing ? 'Salvar alterações' : 'Adicionar'))),
              if (isEditing) ...[
                SizedBox(
                  width: 8,
                ),
                Expanded(
                    child: OutlinedButton.icon(
                        onPressed: _cancelEdit,
                        icon: Icon(Icons.close),
                        label: Text('Cancelar'))),
              ]
            ],
          ),
          Divider(
            height: 8,
          ),
          Expanded(
              child: FutureBuilder<List<Aluno>>(
            future: _futureAluno,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasError) {
                return Center(child: Text('Erro ${snapshot.error}'));
              }
              final alunos = snapshot.data ?? [];
              if (alunos.isEmpty) {
                return Center(
                  child: Text('Nenhum Aluno encontrado'),
                );
              }
              return ListView.builder(
                  itemCount: alunos.length,
                  itemBuilder: (context, index) {
                    final aluno = alunos[index];
                    return ListTile(
                      title: Text(aluno.nome),
                      subtitle: Text(
                          'Nota: ${aluno.nota} - Matéria: ${aluno.materia}'),
                      leading: CircleAvatar(
                        child: Text((aluno.id ?? 0).toString()),
                      ),
                      trailing: Row(
                        mainAxisSize:
                            MainAxisSize.min, // limita a area de exibição
                        children: [
                          IconButton(
                            tooltip: 'Editar',
                            icon: Icon(Icons.edit),
                            onPressed: () => _edit(aluno),
                          ),
                          IconButton(
                              tooltip: 'Excluir',
                              onPressed: () => _delete(aluno.id!),
                              icon: Icon(Icons.delete))
                        ],
                      ),
                    );
                  });
            },
          )),
        ],
      ),
    );
  }
}
