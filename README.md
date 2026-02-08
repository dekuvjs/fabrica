# Fábrica de Muebles

Aplicación de escritorio en Flutter con base de datos SQLite (Drift) y generación de reportes en Excel.

## Requisitos

- Flutter SDK (con soporte desktop)
- Para **macOS**: Xcode
- Para **Windows**: Visual Studio con "Desktop development with C++"
- Para **Linux**: `clang`, `cmake`, `ninja-build`, `pkg-config`, `libgtk-3-dev`, `libstdc++-12-dev`

## Setup

```bash
# Dependencias
flutter pub get

# Generar código de Drift (tras cambiar tablas en lib/database/app_database.dart)
dart run build_runner build --delete-conflicting-outputs
```

## Ejecutar en escritorio

```bash
# macOS
flutter run -d macos

# Windows
flutter run -d windows

# Linux
flutter run -d linux
```

## Estructura del proyecto

- **`lib/database/app_database.dart`** – Base de datos Drift (SQLite). Tabla de ejemplo: `Productos`. Añade más tablas aquí y vuelve a ejecutar `build_runner`.
- **`lib/reports/excel_report_service.dart`** – Módulo de reportes Excel (.xlsx). Métodos: `generarReporteProductos()`, `generarPlantilla()`.
- **`lib/screens/home_screen.dart`** – Pantalla principal: lista de productos, agregar ejemplo, generar reporte Excel.

## Base de datos (Drift)

- Archivo SQLite: se crea automáticamente en el directorio de la aplicación (nombre: `fabrica_muebles`).
- Para nuevas tablas: define la clase en `app_database.dart`, añádela a `@DriftDatabase(tables: [...])` y ejecuta `dart run build_runner build --delete-conflicting-outputs`.

## Reportes Excel

- Los archivos .xlsx se guardan en el directorio de documentos de la aplicación.
- `ExcelReportService.generarReporteProductos()` exporta la lista de productos.
- `ExcelReportService.generarPlantilla()` genera una plantilla de ejemplo.
