# Mini App de Registro y Perfil de Usuario

Aplicación Flutter que permite registrar información básica de un usuario a través de un formulario validado, persiste los datos localmente con SQLite y muestra el último registro en una pantalla de perfil usando widgets reutilizables.

## Tecnologías utilizadas

- Flutter 3.x / Dart 3
- sqflite (SQLite para Flutter)
- path para construir rutas de base de datos en dispositivos
- image_picker para selección de foto de perfil
- flutter_test para pruebas unitarias

## Explicación breve de SQLite

La app crea una base de datos local llamada `usuarios.db` en el almacenamiento interno del dispositivo. La tabla `usuarios` guarda id, nombre, email, edad, teléfono, ruta de foto y fecha de registro. Las operaciones de inserción y consulta se realizan a través de la clase singleton `DatabaseHelper`. En `lib/docs/SQLITE_GUIDE.md` se incluye una guía técnica con estructura y ejemplos de consultas.

## Instalación y ejecución

1. Clonar el repositorio:
   ```bash
   git clone <url-del-repo>
   cd actividad_integradora_2
   ```
2. Obtener dependencias:
   ```bash
   flutter pub get
   ```
3. Ejecutar en dispositivo o emulador:
   ```bash
   flutter run
   ```
4. Para correr los tests de base de datos (requiere FFI):
   ```bash
   flutter test lib/database/database_test.dart
   ```

## Capturas de pantalla

![Formulario de registro](docs/images/registro.png)
*Pantalla de registro con campos validados y botón para seleccionar imagen.*

![Perfil del usuario](docs/images/perfil.png)
*Visualización del último usuario registrado con avatar y tarjetas.*

## Estructura del proyecto

```
lib/
  main.dart                    # punto de entrada y rutas
  models/usuario.dart          # modelo de datos
  database/
    database_helper.dart       # operaciones SQLite
    database_test.dart         # pruebas unitarias
  screens/
    registro_screen.dart       # formulario de registro
    perfil_screen.dart         # vista de perfil
  widgets/
    campo_texto_personalizado.dart  # TextFormField reutilizable
  utils/
    validadores.dart           # funciones de validación
docs/
  SQLITE_GUIDE.md              # documentación técnica SQLite

android/ios/...               # configuraciones de plataforma
```

## GitHub y commits

El repositorio contiene múltiples commits progresivos y usa las ramas `main` y `feature/sqlite`. Los cambios clave incluyen:

- `feat: modelo Usuario y base de datos SQLite básica`
- `feat: widgets reutilizables y validaciones`
- `feat: pantalla de registro con formulario completo`
- `feat: pantalla de perfil con visualización de datos`
- `perf: optimización de consultas SQLite con índices` (rama `feature/sqlite`)
- `docs: documentación técnica de SQLite` (rama `feature/sqlite`)

---
*Este README ha sido actualizado para cumplir los requisitos del enunciado.*
