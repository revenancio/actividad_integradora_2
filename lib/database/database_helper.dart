import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/usuario.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;
  static const int _dbVersion = 2;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'usuarios.db');
    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE usuarios(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        edad INTEGER NOT NULL,
        telefono TEXT NOT NULL,
        fotoPerfil TEXT,
        fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    await db.execute('CREATE INDEX idx_email ON usuarios(email)');
    await db.execute('CREATE INDEX idx_nombre ON usuarios(nombre)');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute(
        'ALTER TABLE usuarios ADD COLUMN fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP',
      );
      await db.execute('CREATE INDEX idx_email ON usuarios(email)');
      await db.execute('CREATE INDEX idx_nombre ON usuarios(nombre)');
    }
  }

  Future<int> insertUsuario(Usuario usuario) async {
    Database db = await database;
    return await db.transaction((txn) async {
      return await txn.insert('usuarios', usuario.toMap());
    });
  }

  Future<Usuario?> getUltimoUsuario() async {
    Database db = await database;
    final maps = await db.query('usuarios', orderBy: 'id DESC', limit: 1);
    return maps.isNotEmpty ? Usuario.fromMap(maps.first) : null;
  }

  Future<Usuario?> getUsuarioByEmail(String email) async {
    Database db = await database;
    final maps = await db.query(
      'usuarios',
      where: 'email = ?',
      whereArgs: [email],
      limit: 1,
    );
    return maps.isNotEmpty ? Usuario.fromMap(maps.first) : null;
  }

  Future<int> contarUsuarios() async {
    Database db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM usuarios');
    return Sqflite.firstIntValue(result) ?? 0;
  }
}
