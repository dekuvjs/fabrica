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

@DriftDatabase(tables: [Productos, TiposMueble, Presupuestos])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: 'fabrica_muebles'));

  @override
  int get schemaVersion => 2;

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
  Future<int> insertPresupuesto(PresupuestosCompanion entry) =>
      into(presupuestos).insert(entry);
  Future<bool> updatePresupuesto(Presupuesto entry) =>
      update(presupuestos).replace(entry);
  Future<int> deletePresupuesto(Presupuesto entry) =>
      delete(presupuestos).delete(entry);
}
