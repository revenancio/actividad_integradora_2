import 'package:flutter/material.dart';
import 'dart:io';
import '../models/usuario.dart';
import '../database/database_helper.dart';
import 'registro_screen.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  final _databaseHelper = DatabaseHelper();
  Usuario? _usuario;
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarUltimoUsuario();
  }

  Future<void> _cargarUltimoUsuario() async {
    final usuario = await _databaseHelper.getUltimoUsuario();
    setState(() {
      _usuario = usuario;
      _cargando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _cargarUltimoUsuario,
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Registrar nuevo',
            onPressed: () => Navigator.pushReplacementNamed(context, '/'),
          ),
        ],
      ),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : _usuario == null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('No hay usuarios registrados'),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegistroScreen(),
                        ),
                      );
                    },
                    child: const Text('Registrar'),
                  ),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: _usuario!.fotoPerfil != null
                        ? FileImage(File(_usuario!.fotoPerfil!))
                        : null,
                    child: _usuario!.fotoPerfil == null
                        ? Text(_usuario!.nombre[0].toUpperCase())
                        : null,
                  ),
                  const SizedBox(height: 20),
                  Card(
                    child: ListTile(
                      title: Text(_usuario!.nombre),
                      leading: const Icon(Icons.person),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      title: Text(_usuario!.email),
                      leading: const Icon(Icons.email),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      title: Text('${_usuario!.edad} años'),
                      leading: const Icon(Icons.calendar_today),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      title: Text(_usuario!.telefono),
                      leading: const Icon(Icons.phone),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
