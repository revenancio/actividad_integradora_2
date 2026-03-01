import 'package:flutter_test/flutter_test.dart';
import '../database/database_helper.dart';
import '../models/usuario.dart';

void main() {
  group('Database Tests', () {
    late DatabaseHelper dbHelper;

    setUp(() async {
      dbHelper = DatabaseHelper();
      final db = await dbHelper.database;
      await db.delete('usuarios');
    });

    test('Insert and retrieve user', () async {
      final usuario = Usuario(
        nombre: 'Test User',
        email: 'test@test.com',
        edad: 25,
        telefono: '1234567890',
      );

      final id = await dbHelper.insertUsuario(usuario);
      expect(id, greaterThan(0));

      final ultimo = await dbHelper.getUltimoUsuario();
      expect(ultimo, isNotNull);
      expect(ultimo!.nombre, 'Test User');
    });

    test('Prevent duplicate emails', () async {
      final usuario1 = Usuario(
        nombre: 'User 1',
        email: 'duplicate@test.com',
        edad: 25,
        telefono: '1111111111',
      );

      final usuario2 = Usuario(
        nombre: 'User 2',
        email: 'duplicate@test.com',
        edad: 30,
        telefono: '2222222222',
      );

      await dbHelper.insertUsuario(usuario1);
      expect(dbHelper.insertUsuario(usuario2), throwsException);
    });
  });
}
