import 'dart:typed_data';

import 'file_exporter_stub.dart'
    if (dart.library.html) 'file_exporter_web.dart'
    if (dart.library.io) 'file_exporter_io.dart' as exporter;

Future<String> saveExcelFile({
  required List<int> bytes,
  required String fileName,
}) {
  return exporter.saveExcelFile(
    bytes: Uint8List.fromList(bytes),
    fileName: fileName,
  );
}