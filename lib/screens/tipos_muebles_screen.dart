import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';

import '../database/app_database.dart';
import '../utils/currency_format.dart';
import '../widgets/presupuesto_form_modal.dart';
import '../widgets/tipo_mueble_form_modal.dart';

class TiposMueblesScreen extends StatefulWidget {
  const TiposMueblesScreen({super.key, this.showAppBar = true});

  final bool showAppBar;

  @override
  State<TiposMueblesScreen> createState() => _TiposMueblesScreenState();
}

class _TiposMueblesScreenState extends State<TiposMueblesScreen> {
  late final AppDatabase _db;
  TiposMuebleData? _tipoSeleccionado;

  @override
  void initState() {
    super.initState();
    _db = AppDatabase();
  }

  @override
  void dispose() {
    _db.close();
    super.dispose();
  }

  Future<void> _abrirModalAgregarTipo() async {
    final nombre = await showDialog<String>(
      context: context,
      builder: (_) =>
          const TipoMuebleFormModal(titulo: 'Agregar tipo de mueble'),
    );
    if (nombre != null && mounted) {
      await _db.insertTipoMueble(TiposMuebleCompanion.insert(nombre: nombre));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tipo de mueble agregado')),
        );
      }
    }
  }

  Future<void> _abrirModalEditarTipo(TiposMuebleData tipo) async {
    final nombre = await showDialog<String>(
      context: context,
      builder: (_) => TipoMuebleFormModal(
        titulo: 'Editar tipo de mueble',
        nombreInicial: tipo.nombre,
      ),
    );
    if (nombre != null && mounted) {
      await _db.updateTipoMueble(tipo.copyWith(nombre: nombre));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tipo de mueble actualizado')),
        );
      }
    }
  }

  Future<void> _confirmarBorrarTipo(TiposMuebleData tipo) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar tipo de mueble'),
        content: Text(
          '¿Eliminar "${tipo.nombre}"? Se eliminarán también todos sus presupuestos.',
        ),
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
      await _db.deleteTipoMueble(tipo);
      if (mounted) {
        setState(() => _tipoSeleccionado = null);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tipo de mueble eliminado')),
        );
      }
    }
  }

  Future<void> _abrirModalAgregarPresupuesto() async {
    if (_tipoSeleccionado == null) return;
    final result = await showDialog<PresupuestoFormResult>(
      context: context,
      builder: (_) => const PresupuestoFormModal(titulo: 'Agregar presupuesto'),
    );
    if (result != null && mounted) {
      await _db.insertPresupuesto(
        PresupuestosCompanion.insert(
          tipoMuebleId: _tipoSeleccionado!.id,
          nombre: result.nombre,
          descripcion: Value(result.descripcion),
          cantidad: Value(result.cantidad),
          precioUnitario: Value(result.precioUnitario),
          precioTotal: Value(result.precioTotal),
        ),
      );
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Presupuesto agregado')));
      }
    }
  }

  Future<void> _abrirModalEditarPresupuesto(Presupuesto p) async {
    final result = await showDialog<PresupuestoFormResult>(
      context: context,
      builder: (_) => PresupuestoFormModal(
        titulo: 'Editar presupuesto',
        nombreInicial: p.nombre,
        descripcionInicial: p.descripcion,
        cantidadInicial: p.cantidad,
        precioUnitarioInicial: p.precioUnitario,
      ),
    );
    if (result != null && mounted) {
      await _db.updatePresupuesto(
        p.copyWith(
          nombre: result.nombre,
          descripcion: Value(result.descripcion),
          cantidad: result.cantidad,
          precioUnitario: result.precioUnitario,
          precioTotal: result.precioTotal,
        ),
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Presupuesto actualizado')),
        );
      }
    }
  }

  Future<void> _confirmarBorrarPresupuesto(Presupuesto p) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar presupuesto'),
        content: Text('¿Eliminar "${p.nombre}"?'),
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
      await _db.deletePresupuesto(p);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Presupuesto eliminado')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.showAppBar
          ? AppBar(
              title: const Text('Tipos de muebles y presupuestos'),
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              actions: [
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  tooltip: 'Agregar tipo de mueble',
                  onPressed: _abrirModalAgregarTipo,
                ),
              ],
            )
          : null,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Lista de tipos de mueble
          Expanded(
            flex: 1,
            child: Card(
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
                            'Tipos de mueble',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        if (!widget.showAppBar)
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            tooltip: 'Agregar tipo de mueble',
                            onPressed: _abrirModalAgregarTipo,
                          ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  Expanded(
                    child: StreamBuilder<List<TiposMuebleData>>(
                      stream: _db.watchTiposMueble(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                            child: Text('Error: ${snapshot.error}'),
                          );
                        }
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        final tipos = snapshot.data!;
                        if (tipos.isEmpty) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.weekend_outlined,
                                    size: 48,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.outline,
                                  ),
                                  const SizedBox(height: 12),
                                  const Text(
                                    'No hay tipos de mueble.\nPulsa + para agregar.',
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                        return ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          itemCount: tipos.length,
                          itemBuilder: (context, i) {
                            final t = tipos[i];
                            final selected = _tipoSeleccionado?.id == t.id;
                            return ListTile(
                              selected: selected,
                              selectedTileColor: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer
                                  .withValues(alpha: 0.5),
                              title: Text(t.nombre),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit_outlined),
                                    tooltip: 'Editar',
                                    onPressed: () => _abrirModalEditarTipo(t),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline),
                                    tooltip: 'Eliminar',
                                    onPressed: () => _confirmarBorrarTipo(t),
                                  ),
                                ],
                              ),
                              onTap: () =>
                                  setState(() => _tipoSeleccionado = t),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Presupuesto del tipo seleccionado
          Expanded(
            flex: 2,
            child: _tipoSeleccionado == null
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.touch_app_outlined,
                          size: 64,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Selecciona un tipo de mueble\npara ver su presupuesto',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.outline,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  )
                : _PresupuestoPanel(
                    db: _db,
                    tipo: _tipoSeleccionado!,
                    onAgregar: _abrirModalAgregarPresupuesto,
                    onEditar: _abrirModalEditarPresupuesto,
                    onEliminar: _confirmarBorrarPresupuesto,
                  ),
          ),
        ],
      ),
    );
  }
}

class _PresupuestoPanel extends StatelessWidget {
  const _PresupuestoPanel({
    required this.db,
    required this.tipo,
    required this.onAgregar,
    required this.onEditar,
    required this.onEliminar,
  });

  final AppDatabase db;
  final TiposMuebleData tipo;
  final VoidCallback onAgregar;
  final void Function(Presupuesto) onEditar;
  final void Function(Presupuesto) onEliminar;

  @override
  Widget build(BuildContext context) {
    return Card(
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
                    'Presupuesto: ${tipo.nombre}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                FilledButton.icon(
                  onPressed: onAgregar,
                  icon: const Icon(Icons.add),
                  label: const Text('Agregar presupuesto'),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: StreamBuilder<List<Presupuesto>>(
              stream: db.watchPresupuestosPorTipo(tipo.id),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final items = snapshot.data!;
                if (items.isEmpty) {
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
                        const Text('No hay líneas de presupuesto.'),
                        const SizedBox(height: 8),
                        FilledButton.tonal(
                          onPressed: onAgregar,
                          child: const Text('Agregar primera línea'),
                        ),
                      ],
                    ),
                  );
                }
                final total = items.fold<double>(
                  0,
                  (s, p) => s + p.precioTotal,
                );
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SingleChildScrollView(
                          child: DataTable(
                            columns: const [
                              DataColumn(label: Text('Nombre')),
                              DataColumn(label: Text('Descripción')),
                              DataColumn(
                                label: Text('Cantidad'),
                                numeric: true,
                              ),
                              DataColumn(
                                label: Text('P. unitario'),
                                numeric: true,
                              ),
                              DataColumn(label: Text('Total'), numeric: true),
                              DataColumn(label: Text('')),
                            ],
                            rows: items.map((p) {
                              return DataRow(
                                cells: [
                                  DataCell(Text(p.nombre)),
                                  DataCell(
                                    ConstrainedBox(
                                      constraints: const BoxConstraints(
                                        maxWidth: 200,
                                      ),
                                      child: Text(
                                        p.descripcion ?? '—',
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                  DataCell(Text('${p.cantidad}')),
                                  DataCell(
                                    Text(formatCurrency(p.precioUnitario)),
                                  ),
                                  DataCell(Text(formatCurrency(p.precioTotal))),
                                  DataCell(
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.edit_outlined),
                                          onPressed: () => onEditar(p),
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.delete_outline,
                                          ),
                                          onPressed: () => onEliminar(p),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                    const Divider(height: 1),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        'Total presupuesto: ${formatCurrency(total)}',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
