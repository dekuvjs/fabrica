import 'package:flutter/material.dart';

import '../database/app_database.dart';
import '../reports/ventas_excel_report_service.dart';
import 'venta_detalle_screen.dart';
import '../widgets/venta_mueble_form_modal.dart';

class VentasMueblesScreen extends StatefulWidget {
  const VentasMueblesScreen({super.key, this.showAppBar = true});

  final bool showAppBar;

  @override
  State<VentasMueblesScreen> createState() => _VentasMueblesScreenState();
}

class _VentasMueblesScreenState extends State<VentasMueblesScreen> {
  late final AppDatabase _db;
  late final VentasExcelReportService _reportService;
  DateTime _fechaSeleccionada = DateTime.now();

  @override
  void initState() {
    super.initState();
    _db = AppDatabase();
    _reportService = VentasExcelReportService();
  }

  @override
  void dispose() {
    _db.close();
    super.dispose();
  }

  Future<void> _abrirModalAgregarVenta() async {
    final tipos = await _db.allTiposMueble;
    if (tipos.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'No hay tipos de mueble. Agrega tipos de mueble primero.',
          ),
        ),
      );
      return;
    }

    if (!mounted) return;
    final result = await showDialog<VentaMuebleFormResult>(
      context: context,
      builder: (_) => VentaMuebleFormModal(
        tiposMueble: tipos,
        fechaInicial: _fechaSeleccionada,
      ),
    );
    if (result == null || !mounted) return;

    await _db.crearVentaConCopiaPresupuesto(
      tipoMuebleId: result.tipoMuebleId,
      cantidad: result.cantidad,
      fecha: result.fecha,
      precioVenta: result.precioVenta,
    );

    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Venta registrada')));
  }

  Future<void> _confirmarBorrarVenta(VentasMueble v) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar venta'),
        content: const Text('¿Eliminar este registro de venta?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (ok == true && mounted) {
      await _db.deleteVentaMueble(v);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Venta eliminada')));
    }
  }

  Future<void> _exportarVentasDelDia() async {
    final inicio = DateTime(
      _fechaSeleccionada.year,
      _fechaSeleccionada.month,
      _fechaSeleccionada.day,
    );
    final fin = inicio.add(const Duration(days: 1));
    await _exportarVentasRango(inicio, fin, titulo: 'día');
  }

  Future<void> _exportarVentasPorRangoUI() async {
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: DateTimeRange(
        start: DateTime(
          _fechaSeleccionada.year,
          _fechaSeleccionada.month,
          _fechaSeleccionada.day,
        ),
        end: DateTime(
          _fechaSeleccionada.year,
          _fechaSeleccionada.month,
          _fechaSeleccionada.day,
        ),
      ),
    );
    if (range == null) return;

    final inicio = DateTime(
      range.start.year,
      range.start.month,
      range.start.day,
    );
    final finExcl = DateTime(
      range.end.year,
      range.end.month,
      range.end.day,
    ).add(const Duration(days: 1));
    await _exportarVentasRango(inicio, finExcl, titulo: 'rango');
  }

  Future<void> _exportarVentasRango(
    DateTime inicioIncl,
    DateTime finExcl, {
    required String titulo,
  }) async {
    try {
      final ventas = await _db.getVentasPorRango(inicioIncl, finExcl);
      if (ventas.isEmpty) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No hay ventas para exportar ($titulo).')),
        );
        return;
      }

      final tipos = await _db.allTiposMueble;
      final tiposById = {for (final t in tipos) t.id: t};
      final nombreArchivo =
          'ventas_${inicioIncl.millisecondsSinceEpoch}_${finExcl.millisecondsSinceEpoch}';

      final path = await _reportService.exportarVentas(
        ventas: ventas,
        tiposMuebleById: tiposById,
        nombreArchivo: nombreArchivo,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Exportado: $path')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error exportando: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final appBar = widget.showAppBar
        ? AppBar(
            title: const Text('Ventas de muebles'),
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            actions: [
              IconButton(
                icon: const Icon(Icons.ios_share_outlined),
                tooltip: 'Exportar ventas del día',
                onPressed: _exportarVentasDelDia,
              ),
              IconButton(
                icon: const Icon(Icons.date_range),
                tooltip: 'Exportar ventas por rango',
                onPressed: _exportarVentasPorRangoUI,
              ),
              IconButton(
                icon: const Icon(Icons.add),
                tooltip: 'Agregar venta',
                onPressed: _abrirModalAgregarVenta,
              ),
            ],
          )
        : null;

    return Scaffold(
      appBar: appBar,
      body: Card(
        margin: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Ventas del día',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (!widget.showAppBar)
                    FilledButton.icon(
                      onPressed: _abrirModalAgregarVenta,
                      icon: const Icon(Icons.add),
                      label: const Text('Agregar venta'),
                    ),
                  if (!widget.showAppBar) ...[
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.ios_share_outlined),
                      tooltip: 'Exportar ventas del día',
                      onPressed: _exportarVentasDelDia,
                    ),
                    IconButton(
                      icon: const Icon(Icons.date_range),
                      tooltip: 'Exportar ventas por rango',
                      onPressed: _exportarVentasPorRangoUI,
                    ),
                  ],
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  const Text('Fecha: '),
                  Text(
                    '${_fechaSeleccionada.day}/${_fechaSeleccionada.month}/${_fechaSeleccionada.year}',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(width: 8),
                  FilledButton.tonalIcon(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _fechaSeleccionada,
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (picked != null) {
                        setState(() => _fechaSeleccionada = picked);
                      }
                    },
                    icon: const Icon(Icons.calendar_today),
                    label: const Text('Cambiar día'),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: StreamBuilder<List<VentasMueble>>(
                stream: _db.watchVentasPorFecha(_fechaSeleccionada),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final ventas = snapshot.data!;
                  if (ventas.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.shopping_cart_outlined,
                            size: 48,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                          const SizedBox(height: 12),
                          const Text('No hay ventas registradas en este día.'),
                          const SizedBox(height: 8),
                          FilledButton.tonal(
                            onPressed: _abrirModalAgregarVenta,
                            child: const Text('Registrar primera venta'),
                          ),
                        ],
                      ),
                    );
                  }

                  return FutureBuilder<List<TiposMuebleData>>(
                    future: _db.allTiposMueble,
                    builder: (context, tiposSnapshot) {
                      final tipos =
                          tiposSnapshot.data ?? const <TiposMuebleData>[];
                      final tiposById = {for (final t in tipos) t.id: t};
                      final totalUnidades = ventas.fold<int>(
                        0,
                        (s, v) => s + v.cantidad,
                      );
                      final totalVentas = ventas.fold<double>(
                        0,
                        (s, v) => s + v.precioVenta,
                      );
                      final totalCostos = ventas.fold<double>(
                        0,
                        (s, v) => s + v.costoTotal,
                      );

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: ListView.builder(
                              padding: const EdgeInsets.all(8),
                              itemCount: ventas.length,
                              itemBuilder: (context, i) {
                                final v = ventas[i];
                                final nombre =
                                    tiposById[v.tipoMuebleId]?.nombre ?? '—';
                                final utilidad = v.precioVenta - v.costoTotal;
                                return Card(
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 4,
                                  ),
                                  child: ListTile(
                                    title: Text(nombre),
                                    subtitle: Text(
                                      'Cant: ${v.cantidad} · '
                                      'Venta: \$${v.precioVenta.toStringAsFixed(2)} · '
                                      'Costo: \$${v.costoTotal.toStringAsFixed(2)} · '
                                      'Utilidad: \$${utilidad.toStringAsFixed(2)}',
                                    ),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.delete_outline),
                                      onPressed: () => _confirmarBorrarVenta(v),
                                    ),
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => VentaDetalleScreen(
                                            venta: v,
                                            tipoNombre: nombre,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                          const Divider(height: 1),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Total unidades vendidas: $totalUnidades',
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Total ventas: \$${totalVentas.toStringAsFixed(2)} · '
                                  'Total costos: \$${totalCostos.toStringAsFixed(2)} · '
                                  'Utilidad: \$${(totalVentas - totalCostos).toStringAsFixed(2)}',
                                ),
                              ],
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
      ),
    );
  }
}
