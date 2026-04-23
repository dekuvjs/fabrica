import 'dart:typed_data';

Future<String> saveExcelFile({
  required Uint8List bytes,
  required String fileName,
}) {
  throw UnsupportedError('La exportacion de archivos no esta soportada en esta plataforma.');
}