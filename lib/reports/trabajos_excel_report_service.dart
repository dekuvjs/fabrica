import 'dart:io';

import 'package:excel/excel.dart';
import 'package:path/path.dart' as p;

import '../database/app_database.dart';

class TrabajosExcelReportService {
  Future<String> exportarTrabajos({
    required List<Trabajo> trabajos,
    required Map<int, Empleado> empleadosById,
    required Map<int, Presupuesto> presupuestosById,
    required Map<int, TiposMuebleData> tiposMuebleById,
    required String nombreArchivo,
  }) async {
    final excel = Excel.createExcel();
    final sheet = excel['Trabajos'];

    sheet.appendRow([
      TextCellValue('Fecha'),
      TextCellValue('Empleado'),
      TextCellValue('Tipo empleado'),
      TextCellValue('Tipo mueble'),
      TextCellValue('Cantidad'),
      TextCellValue('Precio unitario'),
      TextCellValue('Total'),
    ]);

    double total = 0;
    for (final t in trabajos) {
      final emp = empleadosById[t.empleadoId];
      final pres = presupuestosById[t.presupuestoId];
      final tipoMueble = pres == null ? null : tiposMuebleById[pres.tipoMuebleId];

      total += t.precioTotal;

      sheet.appendRow([
        TextCellValue(_fmtDate(t.fecha)),
        TextCellValue(emp?.nombre ?? '—'),
        TextCellValue(emp?.tipoEmpleado ?? '—'),
        TextCellValue(tipoMueble?.nombre ?? '—'),
        IntCellValue(t.cantidad),
        DoubleCellValue(t.precioUnitario),
        DoubleCellValue(t.precioTotal),
      ]);
    }

    sheet.appendRow([
      TextCellValue(''),
      TextCellValue(''),
      TextCellValue(''),
      TextCellValue(''),
      TextCellValue(''),
      TextCellValue('TOTAL'),
      DoubleCellValue(total),
    ]);

    for (int i = 0; i < 7; i++) {
      sheet.setColumnWidth(i, 18);
    }
    sheet.setColumnWidth(1, 26); // empleado
    sheet.setColumnWidth(3, 26); // tipo mueble

    final bytes = excel.encode();
    if (bytes == null) throw Exception('No se pudo generar el Excel');

    // Nota: al ejecutar con `flutter run`, `Directory.current` suele ser la raíz del proyecto.
    // En release, el "current directory" depende de cómo se lance el ejecutable.
    final exportsDir = Directory(p.join(Directory.current.path, 'exports'));
    if (!exportsDir.existsSync()) {
      exportsDir.createSync(recursive: true);
    }
    final path = p.join(exportsDir.path, '$nombreArchivo.xlsx');
    await File(path).writeAsBytes(bytes);
    return path;
  }

  String _fmtDate(DateTime d) {
    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    return '$dd/$mm/${d.year}';
  }
}

