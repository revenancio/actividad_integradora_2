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

    // create indexes for faster lookups
    await db.execute('CREATE INDEX idx_email ON usuarios(email)');
    await db.execute('CREATE INDEX idx_nombre ON usuarios(nombre)');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // SQLite does not allow non-constant defaults on ALTER TABLE.
      // add column without default and then backfill existing rows
      await db.execute(
        'ALTER TABLE usuarios ADD COLUMN fecha_registro TIMESTAMP',
      );
      // set current timestamp for existing records
      await db.execute(
        'UPDATE usuarios SET fecha_registro = CURRENT_TIMESTAMP WHERE fecha_registro IS NULL',
      );
      await db.execute('CREATE INDEX idx_email ON usuarios(email)');
      await db.execute('CREATE INDEX idx_nombre ON usuarios(nombre)');
    }
  }

  Future<int> insertUsuario(Usuario usuario) async {
    final db = await database;
    return await db.transaction((txn) async {
      return await txn.insert('usuarios', usuario.toMap());
    });
  }

  Future<Usuario?> getUltimoUsuario() async {
    final db = await database;
    final maps = await db.query('usuarios', orderBy: 'id DESC', limit: 1);
    return maps.isNotEmpty ? Usuario.fromMap(maps.first) : null;
  }

  Future<Usuario?> getUsuarioByEmail(String email) async {
    final db = await database;
    final maps = await db.query(
      'usuarios',
      where: 'email = ?',
      whereArgs: [email],
      limit: 1,
    );
    return maps.isNotEmpty ? Usuario.fromMap(maps.first) : null;
  }

  Future<int> contarUsuarios() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM usuarios');
    return Sqflite.firstIntValue(result) ?? 0;
  }
}
