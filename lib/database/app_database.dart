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

/// Ventas registradas por tipo de mueble.
class VentasMuebles extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get tipoMuebleId =>
      integer().references(TiposMueble, #id, onDelete: KeyAction.restrict)();
  IntColumn get cantidad => integer()();
  /// Precio total de venta (por el registro completo, no unitario).
  RealColumn get precioVenta => real().withDefault(const Constant(0))();
  /// Costo total de fabricación basado en el presupuesto copiado de la venta.
  RealColumn get costoTotal => real().withDefault(const Constant(0))();
  DateTimeColumn get fecha => dateTime()();
}

/// Copia del presupuesto ligada a una venta específica (editable sin tocar el presupuesto base).
class VentaPresupuestoLineas extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get ventaId =>
      integer().references(VentasMuebles, #id, onDelete: KeyAction.cascade)();
  TextColumn get nombre => text()();
  TextColumn get descripcion => text().nullable()();
  IntColumn get cantidad => integer().withDefault(const Constant(1))();
  RealColumn get precioUnitario => real().withDefault(const Constant(0))();
  RealColumn get precioTotal => real().withDefault(const Constant(0))();
}

@DriftDatabase(
    tables: [
      Productos,
      TiposMueble,
      Presupuestos,
      Empleados,
      Trabajos,
      VentasMuebles,
      VentaPresupuestoLineas,
    ])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: 'fabrica_muebles'));

  @override
  int get schemaVersion => 5;

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
          if (from < 4) {
            await m.createTable(ventasMuebles);
          }
          if (from < 5) {
            await m.addColumn(ventasMuebles, ventasMuebles.precioVenta);
            await m.addColumn(ventasMuebles, ventasMuebles.costoTotal);
            await m.createTable(ventaPresupuestoLineas);
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

  /// Trabajos en un rango [inicioIncl]..[finExcl) para todos los empleados.
  Future<List<Trabajo>> getTrabajosPorRango(DateTime inicioIncl, DateTime finExcl) {
    return (select(trabajos)
          ..where((t) =>
              t.fecha.isBiggerOrEqualValue(inicioIncl) &
              t.fecha.isSmallerThanValue(finExcl)))
        .get();
  }

  /// Trabajos en un rango [inicioIncl]..[finExcl) para un empleado.
  Future<List<Trabajo>> getTrabajosPorEmpleadoYRango(
    int empleadoId,
    DateTime inicioIncl,
    DateTime finExcl,
  ) {
    return (select(trabajos)
          ..where((t) =>
              t.empleadoId.equals(empleadoId) &
              t.fecha.isBiggerOrEqualValue(inicioIncl) &
              t.fecha.isSmallerThanValue(finExcl)))
        .get();
  }

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

  // --- Ventas de muebles (por tipo y fecha) ---
  Stream<List<VentasMueble>> watchVentasPorFecha(DateTime fecha) {
    final inicio = DateTime(fecha.year, fecha.month, fecha.day);
    final fin = inicio.add(const Duration(days: 1));
    return (select(ventasMuebles)
          ..where((t) =>
              t.fecha.isBiggerOrEqualValue(inicio) &
              t.fecha.isSmallerThanValue(fin)))
        .watch();
  }

  Future<List<VentasMueble>> getVentasPorFecha(DateTime fecha) {
    final inicio = DateTime(fecha.year, fecha.month, fecha.day);
    final fin = inicio.add(const Duration(days: 1));
    return (select(ventasMuebles)
          ..where((t) =>
              t.fecha.isBiggerOrEqualValue(inicio) &
              t.fecha.isSmallerThanValue(fin)))
        .get();
  }

  Future<int> insertVentaMueble(VentasMueblesCompanion entry) =>
      into(ventasMuebles).insert(entry);

  Future<bool> updateVentaMueble(VentasMueble entry) =>
      update(ventasMuebles).replace(entry);

  Future<int> deleteVentaMueble(VentasMueble entry) =>
      delete(ventasMuebles).delete(entry);

  // --- Presupuesto copiado por venta ---
  Stream<List<VentaPresupuestoLinea>> watchLineasPresupuestoVenta(int ventaId) {
    return (select(ventaPresupuestoLineas)
          ..where((t) => t.ventaId.equals(ventaId)))
        .watch();
  }

  Future<List<VentaPresupuestoLinea>> getLineasPresupuestoVenta(int ventaId) {
    return (select(ventaPresupuestoLineas)
          ..where((t) => t.ventaId.equals(ventaId)))
        .get();
  }

  Future<int> insertLineaPresupuestoVenta(VentaPresupuestoLineasCompanion entry) =>
      into(ventaPresupuestoLineas).insert(entry);

  Future<bool> updateLineaPresupuestoVenta(VentaPresupuestoLinea entry) =>
      update(ventaPresupuestoLineas).replace(entry);

  Future<int> deleteLineaPresupuestoVenta(VentaPresupuestoLinea entry) =>
      delete(ventaPresupuestoLineas).delete(entry);

  Future<double> recalcularCostoTotalVenta(int ventaId) async {
    final lineas = await getLineasPresupuestoVenta(ventaId);
    final total = lineas.fold<double>(0, (s, l) => s + l.precioTotal);
    final venta = await (select(ventasMuebles)..where((v) => v.id.equals(ventaId)))
        .getSingleOrNull();
    if (venta != null) {
      await updateVentaMueble(venta.copyWith(costoTotal: total));
    }
    return total;
  }

  /// Crea una venta y copia el presupuesto del tipo de mueble como base editable.
  Future<int> crearVentaConCopiaPresupuesto({
    required int tipoMuebleId,
    required int cantidad,
    required DateTime fecha,
    required double precioVenta,
  }) async {
    final fechaDia = DateTime(fecha.year, fecha.month, fecha.day);
    final ventaId = await into(ventasMuebles).insert(
      VentasMueblesCompanion.insert(
        tipoMuebleId: tipoMuebleId,
        cantidad: cantidad,
        fecha: fechaDia,
        precioVenta: Value(precioVenta),
        costoTotal: const Value(0),
      ),
    );

    final presupuestoBase = await getPresupuestosPorTipo(tipoMuebleId);
    if (presupuestoBase.isNotEmpty) {
      await batch((b) {
        for (final p in presupuestoBase) {
          b.insert(
            ventaPresupuestoLineas,
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
      });
    }

    await recalcularCostoTotalVenta(ventaId);
    return ventaId;
  }
}
