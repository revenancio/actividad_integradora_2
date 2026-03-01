import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../models/usuario.dart';
import '../database/database_helper.dart';
import '../widgets/campo_texto_personalizado.dart';
import '../utils/validadores.dart';
import 'perfil_screen.dart'; // <--- COMENTADO TEMPORALMENTE

class RegistroScreen extends StatefulWidget {
  const RegistroScreen({super.key});

  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  final _formKey = GlobalKey<FormState>();
  final _databaseHelper = DatabaseHelper();

  String? _nombre;
  String? _email;
  int? _edad;
  String? _telefono;
  File? _imagenPerfil;

  Future<void> _seleccionarImagen() async {
    final picker = ImagePicker();
    final imagen = await picker.pickImage(source: ImageSource.gallery);

    if (imagen != null) {
      setState(() {
        _imagenPerfil = File(imagen.path);
      });
    }
  }

  Future<void> _guardarUsuario() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final usuario = Usuario(
        nombre: _nombre!,
        email: _email!,
        edad: _edad!,
        telefono: _telefono!,
        fotoPerfil: _imagenPerfil?.path,
      );

      try {
        await _databaseHelper.insertUsuario(usuario);

        // primero notificamos al usuario con un snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Usuario registrado'),
            backgroundColor: Colors.green,
          ),
        );

        // mostramos diálogo de éxito y, cuando se cierre, navegamos al perfil
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Éxito'),
            content: const Text('Usuario registrado correctamente'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );

        Navigator.pushReplacementNamed(context, '/perfil');
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            tooltip: 'Ver perfil',
            onPressed: () => Navigator.pushNamed(context, '/perfil'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Center(
                child: GestureDetector(
                  onTap: _seleccionarImagen,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: _imagenPerfil != null
                        ? FileImage(_imagenPerfil!)
                        : null,
                    child: _imagenPerfil == null
                        ? const Icon(Icons.camera_alt, size: 30)
                        : null,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              CampoTextoPersonalizado(
                label: 'Nombre',
                icono: Icons.person,
                validador: Validadores.validarNombre,
                onSaved: (valor) => _nombre = valor,
              ),
              CampoTextoPersonalizado(
                label: 'Email',
                icono: Icons.email,
                tipoTeclado: TextInputType.emailAddress,
                validador: Validadores.validarEmail,
                onSaved: (valor) => _email = valor,
              ),
              CampoTextoPersonalizado(
                label: 'Edad',
                icono: Icons.calendar_today,
                tipoTeclado: TextInputType.number,
                validador: Validadores.validarEdad,
                onSaved: (valor) => _edad = int.parse(valor!),
              ),
              CampoTextoPersonalizado(
                label: 'Teléfono',
                icono: Icons.phone,
                tipoTeclado: TextInputType.phone,
                validador: Validadores.validarTelefono,
                onSaved: (valor) => _telefono = valor,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _guardarUsuario,
                child: const Text('Registrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
