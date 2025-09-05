import 'package:app_notas/data/app_database.dart';
import 'package:app_notas/models/alunos.dart';
import 'package:sqflite/sqflite.dart';

class Aluno_Dao {
  static const table = 'aluno';

  Future<int> insert(Aluno aluno) async {
    final db = await AppDatabase.instance.database;
    return db.insert(table, aluno.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Cria função para listar todos os Alunos cadastrados
  Future<List<Aluno>> getAll() async {
    final db = await AppDatabase.instance.database;
    final maps = await db.query(table, orderBy: 'id DESC');
    return maps.map((m) => Aluno.fromMap(m)).toList();
  }

  //  Cria uma função para atualizar os Alunos cadastrados
  Future<int> update(Aluno aluno) async {
    final db = await AppDatabase.instance.database;
    return db
        .update(table, aluno.toMap(), where: 'id = ?', whereArgs: [aluno.id]);
  }

  // Cria a função para deletar um arquivo
  Future<int> delete(int id) async {
    final db = await AppDatabase.instance.database;
    return db.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  // Cria a função para fazer a busca por nome (Opcional)
  Future<List<Aluno>> searchByName(String query) async {
    final db = await AppDatabase.instance.database;
    final maps = await db.query(
      table,
      where: 'nome LIKE ?',
      whereArgs: ['%$query%'],
      orderBy: 'nome ASC',
    );
    return maps.map((m) => Aluno.fromMap(m)).toList();
  }
}
