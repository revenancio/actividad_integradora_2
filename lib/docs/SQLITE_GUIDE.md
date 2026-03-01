# Guía de Implementación SQLite

## Estructura de la Base de Datos

### Tabla: usuarios
- **id**: INTEGER PRIMARY KEY AUTOINCREMENT
- **nombre**: TEXT NOT NULL
- **email**: TEXT NOT NULL UNIQUE
- **edad**: INTEGER NOT NULL
- **telefono**: TEXT NOT NULL
- **fotoPerfil**: TEXT
- **fecha_registro**: TIMESTAMP DEFAULT CURRENT_TIMESTAMP

### Índices Optimizados
- `idx_email` - Búsqueda rápida por email
- `idx_nombre` - Búsqueda rápida por nombre

## Versiones
- **Versión 1**: Estructura básica
- **Versión 2**: Agregada columna fecha_registro e índices

## Consultas de Ejemplo
```sql
-- Obtener últimos 10 usuarios
SELECT * FROM usuarios ORDER BY fecha_registro DESC LIMIT 10;

-- Buscar por email
SELECT * FROM usuarios WHERE email = 'usuario@email.com';