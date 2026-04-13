import 'package:flutter/material.dart';

import '../database/app_database.dart';
import '../reports/trabajos_excel_report_service.dart';
import '../utils/currency_format.dart';

class EmpleadosMonthlyScreen extends StatefulWidget {
  const EmpleadosMonthlyScreen({super.key, this.showAppBar = true});

  final bool showAppBar;

  @override
  State<EmpleadosMonthlyScreen> createState() => _EmpleadosMonthlyScreenState();
}

class _EmpleadosMonthlyScreenState extends State<EmpleadosMonthlyScreen> {
  late final AppDatabase _db;
  late final TrabajosExcelReportService _reportService;

  Empleado? _empleadoSeleccionado;
  DateTime _mesSeleccionado = DateTime(DateTime.now().year, DateTime.now().month, 1);

  @override
  void initState() {
    super.initState();
    _db = AppDatabase();
    _reportService = TrabajosExcelReportService();
  }

  @override
  void dispose() {
    _db.close();
    super.dispose();
  }

  Future<void> _exportarMes() async {
    final empleado = _empleadoSeleccionado;
    if (empleado == null) return;

    final inicio = DateTime(_mesSeleccionado.year, _mesSeleccionado.month, 1);
    final fin = DateTime(_mesSeleccionado.year, _mesSeleccionado.month + 1, 1);

    final trabajos = await _db.getTrabajosPorEmpleadoYRango(empleado.id, inicio, fin);
    if (trabajos.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No hay trabajos para exportar en este mes.')),
      );
      return;
    }

    final presupuestosIds = trabajos.map((t) => t.presupuestoId).toSet();
    final presupuestosById = <int, Presupuesto>{};
    for (final id in presupuestosIds) {
      final p = await _db.getPresupuestoById(id);
      if (p != null) presupuestosById[id] = p;
    }

    final tipos = await _db.allTiposMueble;
    final tiposById = {for (final t in tipos) t.id: t};
    final empleadosById = {empleado.id: empleado};

    final path = await _reportService.exportarTrabajos(
      trabajos: trabajos,
      empleadosById: empleadosById,
      presupuestosById: presupuestosById,
      tiposMuebleById: tiposById,
      nombreArchivo: 'trabajos_${empleado.nombre}_${inicio.millisecondsSinceEpoch}',
    );

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Exportado: $path')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.showAppBar
          ? AppBar(
              title: const Text('Empleados'),
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              actions: [
                IconButton(
                  icon: const Icon(Icons.calendar_month_outlined),
                  onPressed: _empleadoSeleccionado == null ? null : _exportarMes,
                  tooltip: 'Exportar mes',
                ),
              ],
            )
          : null,
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: Card(
              margin: const EdgeInsets.all(8),
              child: StreamBuilder<List<Empleado>>(
                stream: _db.watchEmpleados(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final empleados = snapshot.data!;
                  if (empleados.isEmpty) {
                    return const Center(child: Text('No hay empleados.'));
                  }

                  return ListView.builder(
                    itemCount: empleados.length,
                    itemBuilder: (context, i) {
                      final e = empleados[i];
                      return ListTile(
                        title: Text(e.nombre),
                        subtitle: Text(e.tipoEmpleado),
                        selected: _empleadoSeleccionado?.id == e.id,
                        onTap: () => setState(() => _empleadoSeleccionado = e),
                      );
                    },
                  );
                },
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: _empleadoSeleccionado == null
                ? const Center(child: Text('Selecciona un empleado'))
                : _MatrizMensual(
                    db: _db,
                    empleado: _empleadoSeleccionado!,
                    mes: _mesSeleccionado,
                    onMesChanged: (m) => setState(() => _mesSeleccionado = m),
                  ),
          ),
        ],
      ),
    );
  }
}

class _MatrizMensual extends StatelessWidget {
  const _MatrizMensual({
    required this.db,
    required this.empleado,
    required this.mes,
    required this.onMesChanged,
  });

  final AppDatabase db;
  final Empleado empleado;
  final DateTime mes;
  final ValueChanged<DateTime> onMesChanged;

  @override
  Widget build(BuildContext context) {
    final inicio = DateTime(mes.year, mes.month, 1);
    final fin = DateTime(mes.year, mes.month + 1, 1);
    final diasMes = DateUtils.getDaysInMonth(mes.year, mes.month);

    return Card(
      margin: const EdgeInsets.all(8),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Text(
                  'Trabajos ${_nombreMes(mes)} - ${empleado.nombre}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                OutlinedButton(
                  onPressed: () => onMesChanged(DateTime(mes.year, mes.month - 1, 1)),
                  child: const Text('Mes anterior'),
                ),
                OutlinedButton(
                  onPressed: () => onMesChanged(DateTime(mes.year, mes.month + 1, 1)),
                  child: const Text('Mes siguiente'),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: FutureBuilder<List<_ColumnaMatriz>>(
              future: _cargarColumnas(),
              builder: (context, colsSnap) {
                if (!colsSnap.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final columnas = colsSnap.data!;
                if (columnas.isEmpty) {
                  return const Center(child: Text('No hay tipos de mueble.'));
                }

                return StreamBuilder<List<Trabajo>>(
                  stream: db.watchTrabajosPorEmpleadoYRango(empleado.id, inicio, fin),
                  builder: (context, trabajosSnap) {
                    if (!trabajosSnap.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final trabajos = trabajosSnap.data!;
                    final mapa = <String, int>{};
                    final totalPorPresupuesto = <int, int>{};
                    for (final t in trabajos) {
                      final key = '${t.fecha.day}|${t.presupuestoId}';
                      mapa[key] = (mapa[key] ?? 0) + t.cantidad;
                      totalPorPresupuesto[t.presupuestoId] =
                          (totalPorPresupuesto[t.presupuestoId] ?? 0) + t.cantidad;
                    }

                    final totalMes = columnas.fold<double>(0, (acc, c) {
                      if (c.presupuesto == null) return acc;
                      final cant = totalPorPresupuesto[c.presupuesto!.id] ?? 0;
                      return acc + c.presupuesto!.precioUnitario * cant;
                    });

                    final precioPorPresupuesto = {
                      for (final c in columnas)
                        if (c.presupuesto != null)
                          c.presupuesto!.id: c.presupuesto!.precioUnitario,
                    };

                    return Column(
                      children: [
                        Expanded(
                          child: LayoutBuilder(
                            builder: (context, constraints) => SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: ConstrainedBox(
                                constraints: BoxConstraints(minWidth: constraints.maxWidth),
                                child: SingleChildScrollView(
                                  child: DataTable(
                                    columns: [
                                      const DataColumn(label: Text('Dia')),
                                      ...columnas.map(
                                        (c) => DataColumn(
                                          label: Text(c.tipo.nombre),
                                        ),
                                      ),
                                      const DataColumn(label: Text('Pago dia')),
                                    ],
                                    rows: List.generate(diasMes, (i) {
                                      final dia = i + 1;
                                      final pagoDia = columnas.fold<double>(0, (sum, c) {
                                        final presId = c.presupuesto?.id;
                                        if (presId == null) return sum;
                                        final key = '$dia|$presId';
                                        final cant = mapa[key] ?? 0;
                                        final precio = precioPorPresupuesto[presId] ?? 0;
                                        return sum + (cant * precio);
                                      });
                                      return DataRow(
                                        cells: [
                                          DataCell(Text('$dia')),
                                          ...columnas.map((c) {
                                            final presId = c.presupuesto?.id;
                                            final key = presId == null ? null : '$dia|$presId';
                                            final cant = key == null ? 0 : (mapa[key] ?? 0);
                                            return DataCell(
                                              Container(
                                                width: 80,
                                                alignment: Alignment.center,
                                                child: Text(presId == null ? '-' : '$cant'),
                                              ),
                                              onTap: presId == null
                                                  ? null
                                                  : () => _editarCelda(
                                                        context,
                                                        dia: dia,
                                                        columna: c,
                                                        cantidadActual: cant,
                                                      ),
                                            );
                                          }),
                                          DataCell(
                                            Container(
                                              alignment: Alignment.centerRight,
                                              width: 120,
                                              child: Text(formatCurrency(pagoDia)),
                                            ),
                                          ),
                                        ],
                                      );
                                    }),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const Divider(height: 1),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            'Total mes: ${formatCurrency(totalMes)}',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<List<_ColumnaMatriz>> _cargarColumnas() async {
    final tipos = await db.allTiposMueble;
    tipos.sort((a, b) => a.nombre.compareTo(b.nombre));

    final out = <_ColumnaMatriz>[];
    for (final tipo in tipos) {
      final presupuesto = await db.getPresupuestoPorTipoYNombreLinea(tipo.id, empleado.tipoEmpleado);
      out.add(_ColumnaMatriz(tipo: tipo, presupuesto: presupuesto));
    }
    return out;
  }

  Future<void> _editarCelda(
    BuildContext context, {
    required int dia,
    required _ColumnaMatriz columna,
    required int cantidadActual,
  }) async {
    final controller = TextEditingController(text: '$cantidadActual');
    final nuevaCantidad = await showDialog<int>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Dia $dia - ${columna.tipo.nombre}'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Cantidad (0 borra)'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancelar')),
          FilledButton(
            onPressed: () {
              final n = int.tryParse(controller.text.trim());
              if (n == null || n < 0) return;
              Navigator.of(ctx).pop(n);
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );

    if (nuevaCantidad == null || columna.presupuesto == null) return;

    await db.setCantidadTrabajoPorCelda(
      empleadoId: empleado.id,
      presupuestoId: columna.presupuesto!.id,
      fecha: DateTime(mes.year, mes.month, dia),
      cantidad: nuevaCantidad,
      precioUnitario: columna.presupuesto!.precioUnitario,
    );
  }
}

class _ColumnaMatriz {
  const _ColumnaMatriz({required this.tipo, required this.presupuesto});

  final TiposMuebleData tipo;
  final Presupuesto? presupuesto;
}

String _nombreMes(DateTime date) {
  const meses = [
    'Enero',
    'Febrero',
    'Marzo',
    'Abril',
    'Mayo',
    'Junio',
    'Julio',
    'Agosto',
    'Septiembre',
    'Octubre',
    'Noviembre',
    'Diciembre',
  ];
  return '${meses[date.month - 1]} ${date.year}';
}
