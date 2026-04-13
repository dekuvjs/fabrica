import 'dart:io';

import 'package:excel/excel.dart';
import 'package:path/path.dart' as p;

import '../database/app_database.dart';

class VentasExcelReportService {
  Future<String> exportarVentas({
    required List<VentasMueble> ventas,
    required Map<int, TiposMuebleData> tiposMuebleById,
    required String nombreArchivo,
  }) async {
    final excel = Excel.createExcel();
    final sheet = excel['Ventas'];

    sheet.appendRow([
      TextCellValue('Fecha'),
      TextCellValue('Tipo mueble'),
      TextCellValue('Cantidad'),
      TextCellValue('Precio venta'),
      TextCellValue('Costo total'),
      TextCellValue('Utilidad'),
    ]);

    double totalVentas = 0;
    double totalCostos = 0;

    for (final v in ventas) {
      final tipoMueble = tiposMuebleById[v.tipoMuebleId];
      final utilidad = v.precioVenta - v.costoTotal;

      totalVentas += v.precioVenta;
      totalCostos += v.costoTotal;

      sheet.appendRow([
        TextCellValue(_fmtDate(v.fecha)),
        TextCellValue(tipoMueble?.nombre ?? '—'),
        IntCellValue(v.cantidad),
        DoubleCellValue(v.precioVenta),
        DoubleCellValue(v.costoTotal),
        DoubleCellValue(utilidad),
      ]);
    }

    sheet.appendRow([
      TextCellValue(''),
      TextCellValue('TOTAL'),
      TextCellValue(''),
      DoubleCellValue(totalVentas),
      DoubleCellValue(totalCostos),
      DoubleCellValue(totalVentas - totalCostos),
    ]);

    for (int i = 0; i < 6; i++) {
      sheet.setColumnWidth(i, 18);
    }
    sheet.setColumnWidth(1, 28);

    final bytes = excel.encode();
    if (bytes == null) throw Exception('No se pudo generar el Excel');

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
