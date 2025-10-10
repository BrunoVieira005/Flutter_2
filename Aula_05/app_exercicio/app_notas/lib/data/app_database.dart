import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AppDatabase {
  // Singleton
  AppDatabase._internal();
  static final AppDatabase instance = AppDatabase._internal();

  static const _dbName = 'aluno.db';
  static const _dbVersion = 1;

  Database? _db;

  // Getter para o banco de dados (garante que o banco será aberto corretamente)
  Future<Database> get database async {
    if (_db != null) return _db!;

    // Inicializa o banco de dados se ainda não estiver inicializado
    _db = await _open();
    return _db!;
  }

  // Função que abre o banco de dados e cria a tabela, caso não exista
  Future<Database> _open() async {
    final dbPath = await getDatabasesPath(); // Caminho onde o banco será salvo
    final path = join(dbPath, _dbName); // Nome do banco de dados

    // Abre o banco de dados ou cria ele se não existir
    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: (db, version) async {
        // Criação da tabela se o banco for novo
        await db.execute('''
          CREATE TABLE aluno(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT NOT NULL,
            nota INTEGER NOT NULL,
            materia TEXT NOT NULL
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < newVersion) {}
      },
    );
  }
}
