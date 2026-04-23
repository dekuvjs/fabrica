import 'dart:io';
import 'dart:typed_data';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

Future<String> saveExcelFile({
  required Uint8List bytes,
  required String fileName,
}) async {
  Directory? baseDir;

  try {
    baseDir = await getDownloadsDirectory();
  } catch (_) {
    baseDir = null;
  }

  baseDir ??= await getApplicationDocumentsDirectory();

  final exportsDir = Directory(p.join(baseDir.path, 'exports'));
  if (!await exportsDir.exists()) {
    await exportsDir.create(recursive: true);
  }

  final path = p.join(exportsDir.path, fileName);
  await File(path).writeAsBytes(bytes, flush: true);
  return path;
}