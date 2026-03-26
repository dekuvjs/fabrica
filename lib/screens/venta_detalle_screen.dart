import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';

import '../database/app_database.dart';
import '../widgets/presupuesto_form_modal.dart';

class VentaDetalleScreen extends StatefulWidget {
  const VentaDetalleScreen({
    super.key,
    required this.venta,
    required this.tipoNombre,
  });

  final VentasMueble venta;
  final String tipoNombre;

  @override
  State<VentaDetalleScreen> createState() => _VentaDetalleScreenState();
}

class _VentaDetalleScreenState extends State<VentaDetalleScreen> {
  late final AppDatabase _db;
  late VentasMueble _venta;

  @override
  void initState() {
    super.initState();
    _db = AppDatabase();
    _venta = widget.venta;
  }

  @override
  void dispose() {
    _db.close();
    super.dispose();
  }

  Future<void> _editarPrecioVenta() async {
    final controller = TextEditingController(
      text: _venta.precioVenta == 0 ? '' : _venta.precioVenta.toStringAsFixed(2),
    );
    final formKey = GlobalKey<FormState>();

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Editar precio de venta'),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Precio de venta (total)',
              border: OutlineInputBorder(),
            ),
            validator: (v) {
              final raw = (v ?? '').trim();
              if (raw.isEmpty) return 'Ingresa el precio';
              final n = double.tryParse(raw.replaceFirst(',', '.'));
              if (n == null) return 'Precio inválido';
              if (n < 0) return 'Debe ser >= 0';
              return null;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.of(ctx).pop(true);
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );

    if (ok != true || !mounted) return;
    final nuevo = double.parse(controller.text.trim().replaceFirst(',', '.'));

    final actualizada = _venta.copyWith(precioVenta: nuevo);
    await _db.updateVentaMueble(actualizada);
    setState(() => _venta = actualizada);
  }

  Future<void> _agregarLinea() async {
    final result = await showDialog<PresupuestoFormResult>(
      context: context,
      builder: (_) => const PresupuestoFormModal(titulo: 'Agregar costo'),
    );
    if (result == null || !mounted) return;

    await _db.insertLineaPresupuestoVenta(
      VentaPresupuestoLineasCompanion.insert(
        ventaId: _venta.id,
        nombre: result.nombre,
        descripcion: Value(result.descripcion),
        cantidad: Value(result.cantidad),
        precioUnitario: Value(result.precioUnitario),
        precioTotal: Value(result.precioTotal),
      ),
    );
    final total = await _db.recalcularCostoTotalVenta(_venta.id);
    setState(() => _venta = _venta.copyWith(costoTotal: total));
  }

  Future<void> _editarLinea(VentaPresupuestoLinea linea) async {
    final result = await showDialog<PresupuestoFormResult>(
      context: context,
      builder: (_) => PresupuestoFormModal(
        titulo: 'Editar costo',
        nombreInicial: linea.nombre,
        descripcionInicial: linea.descripcion,
        cantidadInicial: linea.cantidad,
        precioUnitarioInicial: linea.precioUnitario,
      ),
    );
    if (result == null || !mounted) return;

    await _db.updateLineaPresupuestoVenta(
      linea.copyWith(
        nombre: result.nombre,
        descripcion: Value(result.descripcion),
        cantidad: result.cantidad,
        precioUnitario: result.precioUnitario,
        precioTotal: result.precioTotal,
      ),
    );
    final total = await _db.recalcularCostoTotalVenta(_venta.id);
    setState(() => _venta = _venta.copyWith(costoTotal: total));
  }

  Future<void> _borrarLinea(VentaPresupuestoLinea linea) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar costo'),
        content: const Text('¿Eliminar esta línea de costo?'),
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
    if (ok != true || !mounted) return;
    await _db.deleteLineaPresupuestoVenta(linea);
    final total = await _db.recalcularCostoTotalVenta(_venta.id);
    setState(() => _venta = _venta.copyWith(costoTotal: total));
  }

  @override
  Widget build(BuildContext context) {
    final utilidad = _venta.precioVenta - _venta.costoTotal;
    return Scaffold(
      appBar: AppBar(
        title: Text('Venta - ${widget.tipoNombre}'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            tooltip: 'Editar precio de venta',
            icon: const Icon(Icons.edit_outlined),
            onPressed: _editarPrecioVenta,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _agregarLinea,
        icon: const Icon(Icons.add),
        label: const Text('Agregar costo'),
      ),
      body: Card(
        margin: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Wrap(
                runSpacing: 8,
                spacing: 12,
                children: [
                  _ChipInfo(label: 'Cantidad', value: '${_venta.cantidad}'),
                  _ChipInfo(
                    label: 'Precio venta',
                    value: '\$${_venta.precioVenta.toStringAsFixed(2)}',
                  ),
                  _ChipInfo(
                    label: 'Costo',
                    value: '\$${_venta.costoTotal.toStringAsFixed(2)}',
                  ),
                  _ChipInfo(
                    label: 'Utilidad',
                    value: '\$${utilidad.toStringAsFixed(2)}',
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: StreamBuilder<List<VentaPresupuestoLinea>>(
                stream: _db.watchLineasPresupuestoVenta(_venta.id),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final lineas = snapshot.data!;
                  if (lineas.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.receipt_long_outlined,
                            size: 48,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                          const SizedBox(height: 12),
                          const Text('No hay costos. Agrega una línea.'),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: lineas.length,
                    itemBuilder: (context, i) {
                      final l = lineas[i];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          title: Text(l.nombre),
                          subtitle: Text(
                            'Cant: ${l.cantidad} · P. unit: \$${l.precioUnitario.toStringAsFixed(2)} · '
                            'Total: \$${l.precioTotal.toStringAsFixed(2)}',
                          ),
                          onTap: () => _editarLinea(l),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () => _borrarLinea(l),
                          ),
                        ),
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

class _ChipInfo extends StatelessWidget {
  const _ChipInfo({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text('$label: $value'),
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
    );
  }
}

