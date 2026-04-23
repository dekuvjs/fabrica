import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drift/drift.dart' show Value;

class Producto {
  const Producto({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.precio,
    required this.stock,
    required this.createdAt,
  });

  final int id;
  final String nombre;
  final String? descripcion;
  final double precio;
  final int stock;
  final DateTime createdAt;

  Producto copyWith({
    int? id,
    String? nombre,
    Value<String?> descripcion = const Value.absent(),
    double? precio,
    int? stock,
    DateTime? createdAt,
  }) {
    return Producto(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion.present ? descripcion.value : this.descripcion,
      precio: precio ?? this.precio,
      stock: stock ?? this.stock,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class TiposMuebleData {
  const TiposMuebleData({required this.id, required this.nombre});

  final int id;
  final String nombre;

  TiposMuebleData copyWith({int? id, String? nombre}) {
    return TiposMuebleData(id: id ?? this.id, nombre: nombre ?? this.nombre);
  }
}

class Presupuesto {
  const Presupuesto({
    required this.id,
    required this.tipoMuebleId,
    required this.nombre,
    required this.descripcion,
    required this.cantidad,
    required this.precioUnitario,
    required this.precioTotal,
  });

  final int id;
  final int tipoMuebleId;
  final String nombre;
  final String? descripcion;
  final int cantidad;
  final double precioUnitario;
  final double precioTotal;

  Presupuesto copyWith({
    int? id,
    int? tipoMuebleId,
    String? nombre,
    Value<String?> descripcion = const Value.absent(),
    int? cantidad,
    double? precioUnitario,
    double? precioTotal,
  }) {
    return Presupuesto(
      id: id ?? this.id,
      tipoMuebleId: tipoMuebleId ?? this.tipoMuebleId,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion.present ? descripcion.value : this.descripcion,
      cantidad: cantidad ?? this.cantidad,
      precioUnitario: precioUnitario ?? this.precioUnitario,
      precioTotal: precioTotal ?? this.precioTotal,
    );
  }
}

class Empleado {
  const Empleado({
    required this.id,
    required this.nombre,
    required this.tipoEmpleado,
  });

  final int id;
  final String nombre;
  final String tipoEmpleado;

  Empleado copyWith({int? id, String? nombre, String? tipoEmpleado}) {
    return Empleado(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      tipoEmpleado: tipoEmpleado ?? this.tipoEmpleado,
    );
  }
}

class Trabajo {
  const Trabajo({
    required this.id,
    required this.empleadoId,
    required this.presupuestoId,
    required this.cantidad,
    required this.fecha,
    required this.precioUnitario,
    required this.precioTotal,
  });

  final int id;
  final int empleadoId;
  final int presupuestoId;
  final int cantidad;
  final DateTime fecha;
  final double precioUnitario;
  final double precioTotal;

  Trabajo copyWith({
    int? id,
    int? empleadoId,
    int? presupuestoId,
    int? cantidad,
    DateTime? fecha,
    double? precioUnitario,
    double? precioTotal,
  }) {
    return Trabajo(
      id: id ?? this.id,
      empleadoId: empleadoId ?? this.empleadoId,
      presupuestoId: presupuestoId ?? this.presupuestoId,
      cantidad: cantidad ?? this.cantidad,
      fecha: fecha ?? this.fecha,
      precioUnitario: precioUnitario ?? this.precioUnitario,
      precioTotal: precioTotal ?? this.precioTotal,
    );
  }
}

class VentasMueble {
  const VentasMueble({
    required this.id,
    required this.tipoMuebleId,
    required this.cantidad,
    required this.precioVenta,
    required this.costoTotal,
    required this.fecha,
  });

  final int id;
  final int tipoMuebleId;
  final int cantidad;
  final double precioVenta;
  final double costoTotal;
  final DateTime fecha;

  VentasMueble copyWith({
    int? id,
    int? tipoMuebleId,
    int? cantidad,
    double? precioVenta,
    double? costoTotal,
    DateTime? fecha,
  }) {
    return VentasMueble(
      id: id ?? this.id,
      tipoMuebleId: tipoMuebleId ?? this.tipoMuebleId,
      cantidad: cantidad ?? this.cantidad,
      precioVenta: precioVenta ?? this.precioVenta,
      costoTotal: costoTotal ?? this.costoTotal,
      fecha: fecha ?? this.fecha,
    );
  }
}

class VentaPresupuestoLinea {
  const VentaPresupuestoLinea({
    required this.id,
    required this.ventaId,
    required this.nombre,
    required this.descripcion,
    required this.cantidad,
    required this.precioUnitario,
    required this.precioTotal,
  });

  final int id;
  final int ventaId;
  final String nombre;
  final String? descripcion;
  final int cantidad;
  final double precioUnitario;
  final double precioTotal;

  VentaPresupuestoLinea copyWith({
    int? id,
    int? ventaId,
    String? nombre,
    Value<String?> descripcion = const Value.absent(),
    int? cantidad,
    double? precioUnitario,
    double? precioTotal,
  }) {
    return VentaPresupuestoLinea(
      id: id ?? this.id,
      ventaId: ventaId ?? this.ventaId,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion.present ? descripcion.value : this.descripcion,
      cantidad: cantidad ?? this.cantidad,
      precioUnitario: precioUnitario ?? this.precioUnitario,
      precioTotal: precioTotal ?? this.precioTotal,
    );
  }
}

class ProductosCompanion {
  const ProductosCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.descripcion = const Value.absent(),
    this.precio = const Value.absent(),
    this.stock = const Value.absent(),
    this.createdAt = const Value.absent(),
  });

  ProductosCompanion.insert({
    required String nombre,
    this.descripcion = const Value.absent(),
    this.precio = const Value.absent(),
    this.stock = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : id = const Value.absent(),
       nombre = Value(nombre);

  final Value<int> id;
  final Value<String> nombre;
  final Value<String?> descripcion;
  final Value<double> precio;
  final Value<int> stock;
  final Value<DateTime> createdAt;
}

class TiposMuebleCompanion {
  const TiposMuebleCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
  });

  TiposMuebleCompanion.insert({required String nombre})
    : id = const Value.absent(),
      nombre = Value(nombre);

  final Value<int> id;
  final Value<String> nombre;
}

class PresupuestosCompanion {
  const PresupuestosCompanion({
    this.id = const Value.absent(),
    this.tipoMuebleId = const Value.absent(),
    this.nombre = const Value.absent(),
    this.descripcion = const Value.absent(),
    this.cantidad = const Value.absent(),
    this.precioUnitario = const Value.absent(),
    this.precioTotal = const Value.absent(),
  });

  PresupuestosCompanion.insert({
    required int tipoMuebleId,
    required String nombre,
    this.descripcion = const Value.absent(),
    this.cantidad = const Value.absent(),
    this.precioUnitario = const Value.absent(),
    this.precioTotal = const Value.absent(),
  }) : id = const Value.absent(),
       tipoMuebleId = Value(tipoMuebleId),
       nombre = Value(nombre);

  final Value<int> id;
  final Value<int> tipoMuebleId;
  final Value<String> nombre;
  final Value<String?> descripcion;
  final Value<int> cantidad;
  final Value<double> precioUnitario;
  final Value<double> precioTotal;
}

class EmpleadosCompanion {
  const EmpleadosCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.tipoEmpleado = const Value.absent(),
  });

  EmpleadosCompanion.insert({required String nombre, required String tipoEmpleado})
    : id = const Value.absent(),
      nombre = Value(nombre),
      tipoEmpleado = Value(tipoEmpleado);

  final Value<int> id;
  final Value<String> nombre;
  final Value<String> tipoEmpleado;
}

class TrabajosCompanion {
  const TrabajosCompanion({
    this.id = const Value.absent(),
    this.empleadoId = const Value.absent(),
    this.presupuestoId = const Value.absent(),
    this.cantidad = const Value.absent(),
    this.fecha = const Value.absent(),
    this.precioUnitario = const Value.absent(),
    this.precioTotal = const Value.absent(),
  });

  TrabajosCompanion.insert({
    required int empleadoId,
    required int presupuestoId,
    required int cantidad,
    required DateTime fecha,
    required double precioUnitario,
    required double precioTotal,
  }) : id = const Value.absent(),
       empleadoId = Value(empleadoId),
       presupuestoId = Value(presupuestoId),
       cantidad = Value(cantidad),
       fecha = Value(fecha),
       precioUnitario = Value(precioUnitario),
       precioTotal = Value(precioTotal);

  final Value<int> id;
  final Value<int> empleadoId;
  final Value<int> presupuestoId;
  final Value<int> cantidad;
  final Value<DateTime> fecha;
  final Value<double> precioUnitario;
  final Value<double> precioTotal;
}

class VentasMueblesCompanion {
  const VentasMueblesCompanion({
    this.id = const Value.absent(),
    this.tipoMuebleId = const Value.absent(),
    this.cantidad = const Value.absent(),
    this.precioVenta = const Value.absent(),
    this.costoTotal = const Value.absent(),
    this.fecha = const Value.absent(),
  });

  VentasMueblesCompanion.insert({
    required int tipoMuebleId,
    required int cantidad,
    required DateTime fecha,
    this.precioVenta = const Value.absent(),
    this.costoTotal = const Value.absent(),
  }) : id = const Value.absent(),
       tipoMuebleId = Value(tipoMuebleId),
       cantidad = Value(cantidad),
       fecha = Value(fecha);

  final Value<int> id;
  final Value<int> tipoMuebleId;
  final Value<int> cantidad;
  final Value<double> precioVenta;
  final Value<double> costoTotal;
  final Value<DateTime> fecha;
}

class VentaPresupuestoLineasCompanion {
  const VentaPresupuestoLineasCompanion({
    this.id = const Value.absent(),
    this.ventaId = const Value.absent(),
    this.nombre = const Value.absent(),
    this.descripcion = const Value.absent(),
    this.cantidad = const Value.absent(),
    this.precioUnitario = const Value.absent(),
    this.precioTotal = const Value.absent(),
  });

  VentaPresupuestoLineasCompanion.insert({
    required int ventaId,
    required String nombre,
    this.descripcion = const Value.absent(),
    this.cantidad = const Value.absent(),
    this.precioUnitario = const Value.absent(),
    this.precioTotal = const Value.absent(),
  }) : id = const Value.absent(),
       ventaId = Value(ventaId),
       nombre = Value(nombre);

  final Value<int> id;
  final Value<int> ventaId;
  final Value<String> nombre;
  final Value<String?> descripcion;
  final Value<int> cantidad;
  final Value<double> precioUnitario;
  final Value<double> precioTotal;
}

class AppDatabase {
  AppDatabase({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance {
    _seedFuture ??= ejecutarSeedersBase();
  }

  final FirebaseFirestore _firestore;

  static Future<void>? _seedFuture;

  static const List<({String nombre, String tipo})> _empleadosSeed = [
    (nombre: 'STERLING', tipo: 'tapizero'),
    (nombre: 'FREDDY', tipo: 'tapizero'),
    (nombre: 'ADAN', tipo: 'tapizero'),
    (nombre: 'JORGE', tipo: 'tapizero'),
    (nombre: 'JORDANY', tipo: 'tapizero'),
    (nombre: 'LEONEL', tipo: 'tapizero'),
    (nombre: 'VICTOR JOSE', tipo: 'tapizero'),
    (nombre: 'ANABEL', tipo: 'costurero'),
    (nombre: 'YENDRY', tipo: 'costurero'),
    (nombre: 'PAPITO', tipo: 'cajonero'),
  ];

  static const String _tipoMuebleJosias = 'Juego L 3 Piezas Josias';

  static const List<
    ({String nombre, double precioUnitario, int cantidad, String descripcion})
  >
  _presupuestosJuegoLJosiasSeed = [
    (
      nombre: 'Madera Pino',
      precioUnitario: 45,
      cantidad: 30,
      descripcion: '5 Pies',
    ),
    (
      nombre: 'Playwood',
      precioUnitario: 150,
      cantidad: 1,
      descripcion: '5 Pesados de 31x31',
    ),
    (
      nombre: 'Grapas de 2',
      precioUnitario: 100,
      cantidad: 1,
      descripcion: 'Caja 1600 16 juegos',
    ),
    (
      nombre: 'Plancha de G',
      precioUnitario: 2700,
      cantidad: 1,
      descripcion: 'Goma de 6',
    ),
    (
      nombre: 'Goma 1/2',
      precioUnitario: 100,
      cantidad: 4,
      descripcion: 'Goma de 1/2',
    ),
    (nombre: 'Goma 2', precioUnitario: 200, cantidad: 2, descripcion: 'Goma de 2'),
    (nombre: 'Goma 1', precioUnitario: 200, cantidad: 2, descripcion: 'Goma de 1'),
    (nombre: 'DACRON', precioUnitario: 120, cantidad: 4, descripcion: 'Dacron'),
    (
      nombre: 'Pelo de ANG',
      precioUnitario: 180,
      cantidad: 5,
      descripcion: 'Libras',
    ),
    (nombre: 'Tela', precioUnitario: 108, cantidad: 22, descripcion: 'Yardas'),
    (
      nombre: 'Tornillo',
      precioUnitario: 1,
      cantidad: 15,
      descripcion: '2 Para armar Brazo y Cuerpo',
    ),
    (
      nombre: 'Pelon',
      precioUnitario: 25,
      cantidad: 3,
      descripcion: '21/2 Yarda de ellon',
    ),
    (
      nombre: 'Cemento',
      precioUnitario: 60,
      cantidad: 1,
      descripcion: 'Para pegar Colcha',
    ),
    (
      nombre: 'Carton Caja',
      precioUnitario: 15,
      cantidad: 5,
      descripcion: '2 cajas de Carton',
    ),
    (
      nombre: 'Bareta',
      precioUnitario: 17,
      cantidad: 4,
      descripcion: '4 para contra mueble y Butaca',
    ),
    (
      nombre: 'Patas',
      precioUnitario: 125,
      cantidad: 8,
      descripcion: '12 Para But, mesa y sofa',
    ),
    (
      nombre: 'Plastico',
      precioUnitario: 97,
      cantidad: 1,
      descripcion: 'Emboltura Muebles',
    ),
    (
      nombre: 'Grapas 7.10',
      precioUnitario: 0.5,
      cantidad: 100,
      descripcion: 'Media Caja Tapizado de Mueble',
    ),
    (
      nombre: 'Cajonero',
      precioUnitario: 1000,
      cantidad: 1,
      descripcion: 'Fabricacion Cajon',
    ),
    (
      nombre: 'Costurero',
      precioUnitario: 600,
      cantidad: 1,
      descripcion: 'Corte, Costura de Cojines',
    ),
    (
      nombre: 'Tapizero',
      precioUnitario: 1,
      cantidad: 1,
      descripcion: 'Tapizeria de Muebles',
    ),
    (nombre: 'Maestria', precioUnitario: 400, cantidad: 1, descripcion: 'Maestria'),
  ];

  CollectionReference<Map<String, dynamic>> _col(String name) {
    return _firestore.collection(name);
  }

  static String _norm(String value) => value.trim().toLowerCase();

  static DateTime _startOfDay(DateTime d) => DateTime(d.year, d.month, d.day);

  static bool _isInRange(DateTime value, DateTime start, DateTime endExclusive) {
    return !value.isBefore(start) && value.isBefore(endExclusive);
  }

  DateTime _asDate(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is String) return DateTime.parse(value);
    if (value is DateTime) return value;
    return DateTime.now();
  }

  double _asDouble(dynamic value, {double fallback = 0}) {
    if (value is num) return value.toDouble();
    return fallback;
  }

  int _asInt(dynamic value, {int fallback = 0}) {
    if (value is num) return value.toInt();
    return fallback;
  }

  Future<int> _nextId(String key) async {
    final ref = _col('_counters').doc(key);
    return _firestore.runTransaction((tx) async {
      final snap = await tx.get(ref);
      final current = _asInt(snap.data()?['value']);
      final next = current + 1;
      tx.set(ref, {'value': next}, SetOptions(merge: true));
      return next;
    });
  }

  Future<void> close() async {}

  Producto _productoFromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? const <String, dynamic>{};
    return Producto(
      id: _asInt(data['id']),
      nombre: (data['nombre'] as String?) ?? '',
      descripcion: data['descripcion'] as String?,
      precio: _asDouble(data['precio']),
      stock: _asInt(data['stock']),
      createdAt: _asDate(data['createdAt']),
    );
  }

  TiposMuebleData _tipoFromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? const <String, dynamic>{};
    return TiposMuebleData(
      id: _asInt(data['id']),
      nombre: (data['nombre'] as String?) ?? '',
    );
  }

  Presupuesto _presupuestoFromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? const <String, dynamic>{};
    return Presupuesto(
      id: _asInt(data['id']),
      tipoMuebleId: _asInt(data['tipoMuebleId']),
      nombre: (data['nombre'] as String?) ?? '',
      descripcion: data['descripcion'] as String?,
      cantidad: _asInt(data['cantidad'], fallback: 1),
      precioUnitario: _asDouble(data['precioUnitario']),
      precioTotal: _asDouble(data['precioTotal']),
    );
  }

  Empleado _empleadoFromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? const <String, dynamic>{};
    return Empleado(
      id: _asInt(data['id']),
      nombre: (data['nombre'] as String?) ?? '',
      tipoEmpleado: (data['tipoEmpleado'] as String?) ?? 'cajonero',
    );
  }

  Trabajo _trabajoFromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? const <String, dynamic>{};
    return Trabajo(
      id: _asInt(data['id']),
      empleadoId: _asInt(data['empleadoId']),
      presupuestoId: _asInt(data['presupuestoId']),
      cantidad: _asInt(data['cantidad']),
      fecha: _asDate(data['fecha']),
      precioUnitario: _asDouble(data['precioUnitario']),
      precioTotal: _asDouble(data['precioTotal']),
    );
  }

  VentasMueble _ventaFromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? const <String, dynamic>{};
    return VentasMueble(
      id: _asInt(data['id']),
      tipoMuebleId: _asInt(data['tipoMuebleId']),
      cantidad: _asInt(data['cantidad']),
      precioVenta: _asDouble(data['precioVenta']),
      costoTotal: _asDouble(data['costoTotal']),
      fecha: _asDate(data['fecha']),
    );
  }

  VentaPresupuestoLinea _lineaFromDoc(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? const <String, dynamic>{};
    return VentaPresupuestoLinea(
      id: _asInt(data['id']),
      ventaId: _asInt(data['ventaId']),
      nombre: (data['nombre'] as String?) ?? '',
      descripcion: data['descripcion'] as String?,
      cantidad: _asInt(data['cantidad'], fallback: 1),
      precioUnitario: _asDouble(data['precioUnitario']),
      precioTotal: _asDouble(data['precioTotal']),
    );
  }

  Future<List<Producto>> get allProductos async {
    final snap = await _col('productos').get();
    final items = snap.docs.map(_productoFromDoc).toList();
    items.sort((a, b) => a.id.compareTo(b.id));
    return items;
  }

  Stream<List<Producto>> watchProductos() {
    return _col('productos').snapshots().map((snap) {
      final items = snap.docs.map(_productoFromDoc).toList();
      items.sort((a, b) => a.id.compareTo(b.id));
      return items;
    });
  }

  Future<int> insertProducto(ProductosCompanion entry) async {
    final id = entry.id.present ? entry.id.value : await _nextId('productos');
    final now = entry.createdAt.present ? entry.createdAt.value : DateTime.now();
    await _col('productos').doc('$id').set({
      'id': id,
      'nombre': entry.nombre.value,
      'descripcion': entry.descripcion.present ? entry.descripcion.value : null,
      'precio': entry.precio.present ? entry.precio.value : 0,
      'stock': entry.stock.present ? entry.stock.value : 0,
      'createdAt': Timestamp.fromDate(now),
    });
    return id;
  }

  Future<bool> updateProducto(Producto entry) async {
    await _col('productos').doc('${entry.id}').set({
      'id': entry.id,
      'nombre': entry.nombre,
      'descripcion': entry.descripcion,
      'precio': entry.precio,
      'stock': entry.stock,
      'createdAt': Timestamp.fromDate(entry.createdAt),
    }, SetOptions(merge: true));
    return true;
  }

  Future<int> deleteProducto(Producto entry) async {
    await _col('productos').doc('${entry.id}').delete();
    return 1;
  }

  Future<List<TiposMuebleData>> get allTiposMueble async {
    final snap = await _col('tiposMueble').get();
    final items = snap.docs.map(_tipoFromDoc).toList();
    items.sort((a, b) => a.id.compareTo(b.id));
    return items;
  }

  Stream<List<TiposMuebleData>> watchTiposMueble() {
    return _col('tiposMueble').snapshots().map((snap) {
      final items = snap.docs.map(_tipoFromDoc).toList();
      items.sort((a, b) => a.id.compareTo(b.id));
      return items;
    });
  }

  Future<int> insertTipoMueble(TiposMuebleCompanion entry) async {
    final id = entry.id.present ? entry.id.value : await _nextId('tiposMueble');
    await _col('tiposMueble').doc('$id').set({'id': id, 'nombre': entry.nombre.value});
    return id;
  }

  Future<bool> updateTipoMueble(TiposMuebleData entry) async {
    await _col('tiposMueble').doc('${entry.id}').set({
      'id': entry.id,
      'nombre': entry.nombre,
    }, SetOptions(merge: true));
    return true;
  }

  Future<int> deleteTipoMueble(TiposMuebleData entry) async {
    final ventas = await _col('ventasMuebles')
        .where('tipoMuebleId', isEqualTo: entry.id)
        .limit(1)
        .get();
    if (ventas.docs.isNotEmpty) {
      throw StateError('No se puede eliminar: hay ventas asociadas a este tipo.');
    }

    final presupuestoSnap = await _col('presupuestos')
        .where('tipoMuebleId', isEqualTo: entry.id)
        .get();
    final batch = _firestore.batch();
    for (final d in presupuestoSnap.docs) {
      batch.delete(d.reference);
    }
    batch.delete(_col('tiposMueble').doc('${entry.id}'));
    await batch.commit();
    return 1;
  }

  Stream<List<Presupuesto>> watchPresupuestosPorTipo(int tipoMuebleId) {
    return _col('presupuestos').snapshots().map((snap) {
      final items = snap.docs
          .map(_presupuestoFromDoc)
          .where((p) => p.tipoMuebleId == tipoMuebleId)
          .toList();
      items.sort((a, b) => a.id.compareTo(b.id));
      return items;
    });
  }

  Future<List<Presupuesto>> getPresupuestosPorTipo(int tipoMuebleId) async {
    final snap = await _col('presupuestos')
        .where('tipoMuebleId', isEqualTo: tipoMuebleId)
        .get();
    final items = snap.docs.map(_presupuestoFromDoc).toList();
    items.sort((a, b) => a.id.compareTo(b.id));
    return items;
  }

  Future<Presupuesto?> getPresupuestoById(int id) async {
    final doc = await _col('presupuestos').doc('$id').get();
    if (!doc.exists) return null;
    return _presupuestoFromDoc(doc);
  }

  Future<int> insertPresupuesto(PresupuestosCompanion entry) async {
    final id = entry.id.present ? entry.id.value : await _nextId('presupuestos');
    final cantidad = entry.cantidad.present ? entry.cantidad.value : 1;
    final unit = entry.precioUnitario.present ? entry.precioUnitario.value : 0;
    final total = entry.precioTotal.present ? entry.precioTotal.value : unit * cantidad;

    await _col('presupuestos').doc('$id').set({
      'id': id,
      'tipoMuebleId': entry.tipoMuebleId.value,
      'nombre': entry.nombre.value,
      'nombreLower': _norm(entry.nombre.value),
      'descripcion': entry.descripcion.present ? entry.descripcion.value : null,
      'cantidad': cantidad,
      'precioUnitario': unit,
      'precioTotal': total,
    });
    return id;
  }

  Future<bool> updatePresupuesto(Presupuesto entry) async {
    await _col('presupuestos').doc('${entry.id}').set({
      'id': entry.id,
      'tipoMuebleId': entry.tipoMuebleId,
      'nombre': entry.nombre,
      'nombreLower': _norm(entry.nombre),
      'descripcion': entry.descripcion,
      'cantidad': entry.cantidad,
      'precioUnitario': entry.precioUnitario,
      'precioTotal': entry.precioTotal,
    }, SetOptions(merge: true));
    return true;
  }

  Future<int> deletePresupuesto(Presupuesto entry) async {
    final trabajos = await _col('trabajos')
        .where('presupuestoId', isEqualTo: entry.id)
        .limit(1)
        .get();
    if (trabajos.docs.isNotEmpty) {
      throw StateError('No se puede eliminar: hay trabajos asociados a esta linea.');
    }
    await _col('presupuestos').doc('${entry.id}').delete();
    return 1;
  }

  Future<List<Empleado>> get allEmpleados async {
    final snap = await _col('empleados').get();
    final items = snap.docs.map(_empleadoFromDoc).toList();
    items.sort((a, b) => a.id.compareTo(b.id));
    return items;
  }

  Stream<List<Empleado>> watchEmpleados() {
    return _col('empleados').snapshots().map((snap) {
      final items = snap.docs.map(_empleadoFromDoc).toList();
      items.sort((a, b) => a.id.compareTo(b.id));
      return items;
    });
  }

  Future<int> insertEmpleado(EmpleadosCompanion entry) async {
    final id = entry.id.present ? entry.id.value : await _nextId('empleados');
    await _col('empleados').doc('$id').set({
      'id': id,
      'nombre': entry.nombre.value,
      'nombreUpper': entry.nombre.value.trim().toUpperCase(),
      'tipoEmpleado': _norm(entry.tipoEmpleado.value),
    });
    return id;
  }

  Future<bool> updateEmpleado(Empleado entry) async {
    await _col('empleados').doc('${entry.id}').set({
      'id': entry.id,
      'nombre': entry.nombre,
      'nombreUpper': entry.nombre.trim().toUpperCase(),
      'tipoEmpleado': _norm(entry.tipoEmpleado),
    }, SetOptions(merge: true));
    return true;
  }

  Future<int> deleteEmpleado(Empleado entry) async {
    final trabajosSnap = await _col('trabajos')
        .where('empleadoId', isEqualTo: entry.id)
        .get();
    final batch = _firestore.batch();
    for (final d in trabajosSnap.docs) {
      batch.delete(d.reference);
    }
    batch.delete(_col('empleados').doc('${entry.id}'));
    await batch.commit();
    return 1;
  }

  Stream<List<Trabajo>> watchTrabajosPorEmpleadoYFecha(int empleadoId, DateTime fecha) {
    final inicio = _startOfDay(fecha);
    final fin = inicio.add(const Duration(days: 1));

    return _col('trabajos')
        .where('empleadoId', isEqualTo: empleadoId)
        .snapshots()
        .map((snap) {
      final items = snap.docs
          .map(_trabajoFromDoc)
          .where((t) => _isInRange(t.fecha, inicio, fin))
          .toList();
      items.sort((a, b) => a.id.compareTo(b.id));
      return items;
    });
  }

  Future<List<Trabajo>> getTrabajosPorEmpleadoYFecha(int empleadoId, DateTime fecha) async {
    final inicio = _startOfDay(fecha);
    final fin = inicio.add(const Duration(days: 1));
    final snap = await _col('trabajos').where('empleadoId', isEqualTo: empleadoId).get();
    final items = snap.docs
        .map(_trabajoFromDoc)
        .where((t) => _isInRange(t.fecha, inicio, fin))
        .toList();
    items.sort((a, b) => a.id.compareTo(b.id));
    return items;
  }

  Future<int> insertTrabajo(TrabajosCompanion entry) async {
    final id = entry.id.present ? entry.id.value : await _nextId('trabajos');
    final fechaDia = _startOfDay(entry.fecha.value);
    await _col('trabajos').doc('$id').set({
      'id': id,
      'empleadoId': entry.empleadoId.value,
      'presupuestoId': entry.presupuestoId.value,
      'cantidad': entry.cantidad.value,
      'fecha': Timestamp.fromDate(fechaDia),
      'precioUnitario': entry.precioUnitario.value,
      'precioTotal': entry.precioTotal.value,
    });
    return id;
  }

  Future<bool> updateTrabajo(Trabajo entry) async {
    await _col('trabajos').doc('${entry.id}').set({
      'id': entry.id,
      'empleadoId': entry.empleadoId,
      'presupuestoId': entry.presupuestoId,
      'cantidad': entry.cantidad,
      'fecha': Timestamp.fromDate(_startOfDay(entry.fecha)),
      'precioUnitario': entry.precioUnitario,
      'precioTotal': entry.precioTotal,
    }, SetOptions(merge: true));
    return true;
  }

  Future<int> deleteTrabajo(Trabajo entry) async {
    await _col('trabajos').doc('${entry.id}').delete();
    return 1;
  }

  Future<List<Trabajo>> getTrabajosPorRango(DateTime inicioIncl, DateTime finExcl) async {
    final snap = await _col('trabajos').get();
    final items = snap.docs
        .map(_trabajoFromDoc)
        .where((t) => _isInRange(t.fecha, inicioIncl, finExcl))
        .toList();
    items.sort((a, b) => a.id.compareTo(b.id));
    return items;
  }

  Future<List<Trabajo>> getTrabajosPorEmpleadoYRango(
    int empleadoId,
    DateTime inicioIncl,
    DateTime finExcl,
  ) async {
    final snap = await _col('trabajos').where('empleadoId', isEqualTo: empleadoId).get();
    final items = snap.docs
        .map(_trabajoFromDoc)
        .where((t) => _isInRange(t.fecha, inicioIncl, finExcl))
        .toList();
    items.sort((a, b) => a.id.compareTo(b.id));
    return items;
  }

  Future<Presupuesto?> getPresupuestoPorTipoYNombreLinea(
    int tipoMuebleId,
    String nombreLinea,
  ) async {
    final target = _norm(nombreLinea);
    final list = await getPresupuestosPorTipo(tipoMuebleId);
    for (final p in list) {
      if (_norm(p.nombre) == target) return p;
    }
    return null;
  }

  Stream<List<VentasMueble>> watchVentasPorFecha(DateTime fecha) {
    final inicio = _startOfDay(fecha);
    final fin = inicio.add(const Duration(days: 1));

    return _col('ventasMuebles').snapshots().map((snap) {
      final items = snap.docs
          .map(_ventaFromDoc)
          .where((v) => _isInRange(v.fecha, inicio, fin))
          .toList();
      items.sort((a, b) => a.id.compareTo(b.id));
      return items;
    });
  }

  Future<List<VentasMueble>> getVentasPorFecha(DateTime fecha) async {
    final inicio = _startOfDay(fecha);
    final fin = inicio.add(const Duration(days: 1));
    final snap = await _col('ventasMuebles').get();
    final items = snap.docs
        .map(_ventaFromDoc)
        .where((v) => _isInRange(v.fecha, inicio, fin))
        .toList();
    items.sort((a, b) => a.id.compareTo(b.id));
    return items;
  }

  Future<List<VentasMueble>> getVentasPorRango(
    DateTime inicioIncl,
    DateTime finExcl,
  ) async {
    final snap = await _col('ventasMuebles').get();
    final items = snap.docs
        .map(_ventaFromDoc)
        .where((v) => _isInRange(v.fecha, inicioIncl, finExcl))
        .toList();
    items.sort((a, b) => a.id.compareTo(b.id));
    return items;
  }

  Future<int> insertVentaMueble(VentasMueblesCompanion entry) async {
    final id = entry.id.present ? entry.id.value : await _nextId('ventasMuebles');
    await _col('ventasMuebles').doc('$id').set({
      'id': id,
      'tipoMuebleId': entry.tipoMuebleId.value,
      'cantidad': entry.cantidad.value,
      'precioVenta': entry.precioVenta.present ? entry.precioVenta.value : 0,
      'costoTotal': entry.costoTotal.present ? entry.costoTotal.value : 0,
      'fecha': Timestamp.fromDate(_startOfDay(entry.fecha.value)),
    });
    return id;
  }

  Future<bool> updateVentaMueble(VentasMueble entry) async {
    await _col('ventasMuebles').doc('${entry.id}').set({
      'id': entry.id,
      'tipoMuebleId': entry.tipoMuebleId,
      'cantidad': entry.cantidad,
      'precioVenta': entry.precioVenta,
      'costoTotal': entry.costoTotal,
      'fecha': Timestamp.fromDate(_startOfDay(entry.fecha)),
    }, SetOptions(merge: true));
    return true;
  }

  Future<int> deleteVentaMueble(VentasMueble entry) async {
    final lineas = await _col('ventaPresupuestoLineas')
        .where('ventaId', isEqualTo: entry.id)
        .get();
    final batch = _firestore.batch();
    for (final d in lineas.docs) {
      batch.delete(d.reference);
    }
    batch.delete(_col('ventasMuebles').doc('${entry.id}'));
    await batch.commit();
    return 1;
  }

  Stream<List<VentaPresupuestoLinea>> watchLineasPresupuestoVenta(int ventaId) {
    return _col('ventaPresupuestoLineas')
        .where('ventaId', isEqualTo: ventaId)
        .snapshots()
        .map((snap) {
      final items = snap.docs.map(_lineaFromDoc).toList();
      items.sort((a, b) => a.id.compareTo(b.id));
      return items;
    });
  }

  Future<List<VentaPresupuestoLinea>> getLineasPresupuestoVenta(int ventaId) async {
    final snap = await _col('ventaPresupuestoLineas')
        .where('ventaId', isEqualTo: ventaId)
        .get();
    final items = snap.docs.map(_lineaFromDoc).toList();
    items.sort((a, b) => a.id.compareTo(b.id));
    return items;
  }

  Future<int> insertLineaPresupuestoVenta(
    VentaPresupuestoLineasCompanion entry,
  ) async {
    final id = entry.id.present
        ? entry.id.value
        : await _nextId('ventaPresupuestoLineas');
    final cantidad = entry.cantidad.present ? entry.cantidad.value : 1;
    final unit = entry.precioUnitario.present ? entry.precioUnitario.value : 0;
    final total = entry.precioTotal.present ? entry.precioTotal.value : unit * cantidad;

    await _col('ventaPresupuestoLineas').doc('$id').set({
      'id': id,
      'ventaId': entry.ventaId.value,
      'nombre': entry.nombre.value,
      'descripcion': entry.descripcion.present ? entry.descripcion.value : null,
      'cantidad': cantidad,
      'precioUnitario': unit,
      'precioTotal': total,
    });
    return id;
  }

  Future<bool> updateLineaPresupuestoVenta(VentaPresupuestoLinea entry) async {
    await _col('ventaPresupuestoLineas').doc('${entry.id}').set({
      'id': entry.id,
      'ventaId': entry.ventaId,
      'nombre': entry.nombre,
      'descripcion': entry.descripcion,
      'cantidad': entry.cantidad,
      'precioUnitario': entry.precioUnitario,
      'precioTotal': entry.precioTotal,
    }, SetOptions(merge: true));
    return true;
  }

  Future<int> deleteLineaPresupuestoVenta(VentaPresupuestoLinea entry) async {
    await _col('ventaPresupuestoLineas').doc('${entry.id}').delete();
    return 1;
  }

  Future<double> recalcularCostoTotalVenta(int ventaId) async {
    final lineas = await getLineasPresupuestoVenta(ventaId);
    final total = lineas.fold<double>(0, (s, l) => s + l.precioTotal);
    final ventaDoc = await _col('ventasMuebles').doc('$ventaId').get();
    if (ventaDoc.exists) {
      await _col('ventasMuebles').doc('$ventaId').set({
        'costoTotal': total,
      }, SetOptions(merge: true));
    }
    return total;
  }

  Future<int> crearVentaConCopiaPresupuesto({
    required int tipoMuebleId,
    required int cantidad,
    required DateTime fecha,
    required double precioVenta,
  }) async {
    final ventaId = await insertVentaMueble(
      VentasMueblesCompanion.insert(
        tipoMuebleId: tipoMuebleId,
        cantidad: cantidad,
        fecha: _startOfDay(fecha),
        precioVenta: Value(precioVenta),
        costoTotal: const Value(0),
      ),
    );

    final presupuestoBase = await getPresupuestosPorTipo(tipoMuebleId);
    for (final p in presupuestoBase) {
      await insertLineaPresupuestoVenta(
        VentaPresupuestoLineasCompanion.insert(
          ventaId: ventaId,
          nombre: p.nombre,
          descripcion: Value(p.descripcion),
          cantidad: Value(p.cantidad),
          precioUnitario: Value(p.precioUnitario),
          precioTotal: Value(p.precioTotal),
        ),
      );
    }

    await recalcularCostoTotalVenta(ventaId);
    return ventaId;
  }

  Future<void> seedEmpleadosBase() async {
    final existentes = await allEmpleados;
    final existentesNorm = existentes.map((e) => e.nombre.trim().toUpperCase()).toSet();

    final faltantes = _empleadosSeed
        .where((e) => !existentesNorm.contains(e.nombre.trim().toUpperCase()))
        .toList();

    for (final empleado in faltantes) {
      await insertEmpleado(
        EmpleadosCompanion.insert(nombre: empleado.nombre, tipoEmpleado: empleado.tipo),
      );
    }
  }

  Future<void> seedTiposMuebleBase() async {
    final tiposExistentes = await allTiposMueble;
    TiposMuebleData? tipoExistente;
    for (final tipo in tiposExistentes) {
      if (_norm(tipo.nombre) == _norm(_tipoMuebleJosias)) {
        tipoExistente = tipo;
        break;
      }
    }

    final tipoMuebleId =
        tipoExistente?.id ??
        await insertTipoMueble(TiposMuebleCompanion.insert(nombre: _tipoMuebleJosias));

    final presupuestosExistentes = await getPresupuestosPorTipo(tipoMuebleId);
    final nombresExistentes = presupuestosExistentes.map((p) => _norm(p.nombre)).toSet();

    for (final linea in _presupuestosJuegoLJosiasSeed) {
      if (nombresExistentes.contains(_norm(linea.nombre))) continue;
      await insertPresupuesto(
        PresupuestosCompanion.insert(
          tipoMuebleId: tipoMuebleId,
          nombre: linea.nombre,
          descripcion: Value(linea.descripcion),
          cantidad: Value(linea.cantidad),
          precioUnitario: Value(linea.precioUnitario),
          precioTotal: Value(linea.precioUnitario * linea.cantidad),
        ),
      );
    }
  }

  Future<void> ejecutarSeedersBase() async {
    await seedEmpleadosBase();
    await seedTiposMuebleBase();
  }

  Future<void> resetDatabase() async {
    final collections = <String>[
      'productos',
      'tiposMueble',
      'presupuestos',
      'empleados',
      'trabajos',
      'ventasMuebles',
      'ventaPresupuestoLineas',
      '_counters',
    ];

    for (final name in collections) {
      final snap = await _col(name).get();
      if (snap.docs.isEmpty) continue;
      final batch = _firestore.batch();
      for (final doc in snap.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
    }

    await ejecutarSeedersBase();
  }
}
