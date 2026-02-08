import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

/// Tabla de ejemplo: productos (fábrica de muebles).
class Productos extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nombre => text()();
  TextColumn get descripcion => text().nullable()();
  RealColumn get precio => real().withDefault(const Constant(0))();
  IntColumn get stock => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// Tipos de mueble (ej: Mesa, Silla, Estantería). Solo nombre.
class TiposMueble extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nombre => text()();
}

/// Líneas del presupuesto de un tipo de mueble: nombre, descripción, cantidad, precio unitario, total.
class Presupuestos extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get tipoMuebleId => integer().references(TiposMueble, #id, onDelete: KeyAction.cascade)();
  TextColumn get nombre => text()();
  TextColumn get descripcion => text().nullable()();
  IntColumn get cantidad => integer().withDefault(const Constant(1))();
  RealColumn get precioUnitario => real().withDefault(const Constant(0))();
  RealColumn get precioTotal => real().withDefault(const Constant(0))();
}

/// Tipos de empleado: fijo, tapizador, cortador, ensamblador.
/// El nombre del presupuesto (ej. "Tapizador") debe coincidir con el tipo para asignar precio.
class Empleados extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nombre => text()();
  TextColumn get tipoEmpleado => text()(); // 'fijo', 'tapizador', 'cortador', 'ensamblador'
}

/// Trabajo realizado por un empleado en una fecha: tipo de mueble (vía presupuesto), cantidad, precio.
class Trabajos extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get empleadoId => integer().references(Empleados, #id, onDelete: KeyAction.cascade)();
  IntColumn get presupuestoId => integer().references(Presupuestos, #id)();
  IntColumn get cantidad => integer()();
  DateTimeColumn get fecha => dateTime()();
  RealColumn get precioUnitario => real()();
  RealColumn get precioTotal => real()();
}

@DriftDatabase(tables: [Productos, TiposMueble, Presupuestos, Empleados, Trabajos])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: 'fabrica_muebles'));

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          if (from < 2) {
            await m.createTable(tiposMueble);
            await m.createTable(presupuestos);
          }
          if (from < 3) {
            await m.createTable(empleados);
            await m.createTable(trabajos);
          }
        },
      );

  // --- Productos (ejemplo) ---
  Future<List<Producto>> get allProductos => select(productos).get();
  Stream<List<Producto>> watchProductos() => select(productos).watch();
  Future<int> insertProducto(ProductosCompanion entry) =>
      into(productos).insert(entry);
  Future<bool> updateProducto(Producto entry) =>
      update(productos).replace(entry);
  Future<int> deleteProducto(Producto entry) =>
      delete(productos).delete(entry);

  // --- Tipos de mueble ---
  Future<List<TiposMuebleData>> get allTiposMueble => select(tiposMueble).get();
  Stream<List<TiposMuebleData>> watchTiposMueble() => select(tiposMueble).watch();
  Future<int> insertTipoMueble(TiposMuebleCompanion entry) =>
      into(tiposMueble).insert(entry);
  Future<bool> updateTipoMueble(TiposMuebleData entry) =>
      update(tiposMueble).replace(entry);
  Future<int> deleteTipoMueble(TiposMuebleData entry) =>
      delete(tiposMueble).delete(entry);

  // --- Presupuestos (por tipo de mueble) ---
  Stream<List<Presupuesto>> watchPresupuestosPorTipo(int tipoMuebleId) =>
      (select(presupuestos)..where((t) => t.tipoMuebleId.equals(tipoMuebleId))).watch();
  Future<List<Presupuesto>> getPresupuestosPorTipo(int tipoMuebleId) =>
      (select(presupuestos)..where((t) => t.tipoMuebleId.equals(tipoMuebleId))).get();

  Future<Presupuesto?> getPresupuestoById(int id) =>
      (select(presupuestos)..where((t) => t.id.equals(id))).getSingleOrNull();
  Future<int> insertPresupuesto(PresupuestosCompanion entry) =>
      into(presupuestos).insert(entry);
  Future<bool> updatePresupuesto(Presupuesto entry) =>
      update(presupuestos).replace(entry);
  Future<int> deletePresupuesto(Presupuesto entry) =>
      delete(presupuestos).delete(entry);

  // --- Empleados ---
  Future<List<Empleado>> get allEmpleados => select(empleados).get();
  Stream<List<Empleado>> watchEmpleados() => select(empleados).watch();
  Future<int> insertEmpleado(EmpleadosCompanion entry) =>
      into(empleados).insert(entry);
  Future<bool> updateEmpleado(Empleado entry) =>
      update(empleados).replace(entry);
  Future<int> deleteEmpleado(Empleado entry) =>
      delete(empleados).delete(entry);

  // --- Trabajos (por empleado y fecha) ---
  Stream<List<Trabajo>> watchTrabajosPorEmpleadoYFecha(int empleadoId, DateTime fecha) {
    final inicio = DateTime(fecha.year, fecha.month, fecha.day);
    final fin = inicio.add(const Duration(days: 1));
    return (select(trabajos)
          ..where((t) =>
              t.empleadoId.equals(empleadoId) &
              t.fecha.isBiggerOrEqualValue(inicio) &
              t.fecha.isSmallerThanValue(fin)))
        .watch();
  }

  Future<List<Trabajo>> getTrabajosPorEmpleadoYFecha(int empleadoId, DateTime fecha) async {
    final inicio = DateTime(fecha.year, fecha.month, fecha.day);
    final fin = inicio.add(const Duration(days: 1));
    return (select(trabajos)
          ..where((t) =>
              t.empleadoId.equals(empleadoId) &
              t.fecha.isBiggerOrEqualValue(inicio) &
              t.fecha.isSmallerThanValue(fin)))
        .get();
  }

  Future<int> insertTrabajo(TrabajosCompanion entry) =>
      into(trabajos).insert(entry);
  Future<bool> updateTrabajo(Trabajo entry) =>
      update(trabajos).replace(entry);
  Future<int> deleteTrabajo(Trabajo entry) =>
      delete(trabajos).delete(entry);

  /// Presupuesto por tipo de mueble y nombre de línea (ej. "tapizador").
  /// Coincide por nombre ignorando mayúsculas.
  Future<Presupuesto?> getPresupuestoPorTipoYNombreLinea(
      int tipoMuebleId, String nombreLinea) async {
    final presupuestos = await getPresupuestosPorTipo(tipoMuebleId);
    final lower = nombreLinea.toLowerCase();
    try {
      return presupuestos.firstWhere(
        (p) => p.nombre.toLowerCase() == lower,
      );
    } catch (_) {
      return null;
    }
  }
}
