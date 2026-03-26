import 'dart:io';

import 'package:excel/excel.dart';
import 'package:path/path.dart' as p;

import '../database/app_database.dart';

/// Módulo para generar reportes en Excel (.xlsx).
/// Usa el paquete [excel] y puede exportar datos desde Drift.
class ExcelReportService {
  ExcelReportService();

  /// Genera un reporte de productos y devuelve la ruta del archivo guardado.
  /// [productos] lista de productos desde la base de datos.
  /// [nombreArchivo] nombre sin extensión (ej: "reporte_productos").
  Future<String> generarReporteProductos(
    List<Producto> productos, {
    String nombreArchivo = 'reporte_productos',
  }) async {
    final excel = Excel.createExcel();
    final sheet = excel['Productos'];

    // Encabezados
    sheet.appendRow([
      TextCellValue('ID'),
      TextCellValue('Nombre'),
      TextCellValue('Descripción'),
      TextCellValue('Precio'),
      TextCellValue('Stock'),
      TextCellValue('Fecha creación'),
    ]);

    // Datos
    for (final p in productos) {
      sheet.appendRow([
        IntCellValue(p.id),
        TextCellValue(p.nombre),
        TextCellValue(p.descripcion ?? ''),
        DoubleCellValue(p.precio),
        IntCellValue(p.stock),
        TextCellValue(p.createdAt.toIso8601String()),
      ]);
    }

    // Ajustar ancho de columnas (opcional)
    for (int i = 0; i < 6; i++) {
      sheet.setColumnWidth(i, 18);
    }

    final bytes = excel.encode();
    if (bytes == null) throw Exception('No se pudo generar el Excel');

    final exportsDir = Directory(p.join(Directory.current.path, 'exports'));
    if (!exportsDir.existsSync()) {
      exportsDir.createSync(recursive: true);
    }
    final path = p.join(exportsDir.path, '$nombreArchivo.xlsx');
    final file = File(path);
    await file.writeAsBytes(bytes);

    return path;
  }

  /// Genera un Excel vacío con una hoja de ejemplo (útil como plantilla).
  Future<String> generarPlantilla({String nombreArchivo = 'plantilla'}) async {
    final excel = Excel.createExcel();
    final sheet = excel['Datos'];
    sheet.appendRow([
      TextCellValue('Columna A'),
      TextCellValue('Columna B'),
      TextCellValue('Columna C'),
    ]);
    sheet.appendRow([
      TextCellValue('Ejemplo 1'),
      TextCellValue('Ejemplo 2'),
      TextCellValue('Ejemplo 3'),
    ]);

    final bytes = excel.encode();
    if (bytes == null) throw Exception('No se pudo generar el Excel');

    final exportsDir = Directory(p.join(Directory.current.path, 'exports'));
    if (!exportsDir.existsSync()) {
      exportsDir.createSync(recursive: true);
    }
    final path = p.join(exportsDir.path, '$nombreArchivo.xlsx');
    final file = File(path);
    await file.writeAsBytes(bytes);

    return path;
  }
}
