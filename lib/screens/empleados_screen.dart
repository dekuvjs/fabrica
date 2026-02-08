import 'package:flutter/material.dart';

import '../database/app_database.dart';
import '../widgets/empleado_form_modal.dart';
import '../widgets/trabajo_form_modal.dart';

class EmpleadosScreen extends StatefulWidget {
  const EmpleadosScreen({super.key, this.showAppBar = true});

  final bool showAppBar;

  @override
  State<EmpleadosScreen> createState() => _EmpleadosScreenState();
}

class _EmpleadosScreenState extends State<EmpleadosScreen> {
  late final AppDatabase _db;
  Empleado? _empleadoSeleccionado;
  DateTime _fechaSeleccionada = DateTime.now();

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

  Future<void> _abrirModalAgregarEmpleado() async {
    final result = await showDialog<EmpleadoFormResult>(
      context: context,
      builder: (_) => const EmpleadoFormModal(titulo: 'Agregar empleado'),
    );
    if (result != null && mounted) {
      await _db.insertEmpleado(EmpleadosCompanion.insert(
        nombre: result.nombre,
        tipoEmpleado: result.tipoEmpleado,
      ));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Empleado agregado')),
        );
      }
    }
  }

  Future<void> _abrirModalEditarEmpleado(Empleado emp) async {
    final result = await showDialog<EmpleadoFormResult>(
      context: context,
      builder: (_) => EmpleadoFormModal(
        titulo: 'Editar empleado',
        nombreInicial: emp.nombre,
        tipoInicial: emp.tipoEmpleado,
      ),
    );
    if (result != null && mounted) {
      await _db.updateEmpleado(emp.copyWith(
        nombre: result.nombre,
        tipoEmpleado: result.tipoEmpleado,
      ));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Empleado actualizado')),
        );
      }
    }
  }

  Future<void> _confirmarBorrarEmpleado(Empleado emp) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar empleado'),
        content: Text(
          '¿Eliminar a "${emp.nombre}"? Se eliminarán también todos sus trabajos.',
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
      await _db.deleteEmpleado(emp);
      if (mounted) {
        setState(() => _empleadoSeleccionado = null);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Empleado eliminado')),
        );
      }
    }
  }

  Future<void> _abrirModalAgregarTrabajo() async {
    if (_empleadoSeleccionado == null) return;
    final tipos = await _db.allTiposMueble;
    if (tipos.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  'No hay tipos de mueble. Agrega tipos de mueble y presupuestos primero.')),
        );
      }
      return;
    }
    if (!mounted) return;
    final result = await showDialog<TrabajoFormResult>(
      context: context,
      builder: (_) => TrabajoFormModal(
        db: _db,
        empleado: _empleadoSeleccionado!,
        tiposMueble: tipos,
      ),
    );
    if (result != null && mounted) {
      await _db.insertTrabajo(TrabajosCompanion.insert(
        empleadoId: result.empleadoId,
        presupuestoId: result.presupuestoId,
        cantidad: result.cantidad,
        fecha: result.fecha,
        precioUnitario: result.precioUnitario,
        precioTotal: result.precioTotal,
      ));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Trabajo agregado')),
        );
      }
    }
  }

  Future<void> _confirmarBorrarTrabajo(Trabajo t) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar trabajo'),
        content: const Text('¿Eliminar este registro de trabajo?'),
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
      await _db.deleteTrabajo(t);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Trabajo eliminado')),
        );
      }
    }
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
                  icon: const Icon(Icons.person_add),
                  tooltip: 'Agregar empleado',
                  onPressed: _abrirModalAgregarEmpleado,
                ),
              ],
            )
          : null,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
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
                            'Empleados',
                            style:
                                Theme.of(context).textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                        ),
                        if (!widget.showAppBar)
                          IconButton(
                            icon: const Icon(Icons.person_add),
                            tooltip: 'Agregar empleado',
                            onPressed: _abrirModalAgregarEmpleado,
                          ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  Expanded(
                    child: StreamBuilder<List<Empleado>>(
                      stream: _db.watchEmpleados(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        }
                        if (!snapshot.hasData) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        final empleados = snapshot.data!;
                        if (empleados.isEmpty) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.people_outline,
                                    size: 48,
                                    color:
                                        Theme.of(context).colorScheme.outline,
                                  ),
                                  const SizedBox(height: 12),
                                  const Text(
                                    'No hay empleados.\nAgrega uno para comenzar.',
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                        return ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          itemCount: empleados.length,
                          itemBuilder: (context, i) {
                            final e = empleados[i];
                            final selected =
                                _empleadoSeleccionado?.id == e.id;
                            return ListTile(
                              selected: selected,
                              selectedTileColor: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer
                                  .withValues(alpha: 0.5),
                              title: Text(e.nombre),
                              subtitle: Text(
                                e.tipoEmpleado[0].toUpperCase() +
                                    e.tipoEmpleado.substring(1),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                ),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit_outlined),
                                    tooltip: 'Editar',
                                    onPressed: () =>
                                        _abrirModalEditarEmpleado(e),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline),
                                    tooltip: 'Eliminar',
                                    onPressed: () =>
                                        _confirmarBorrarEmpleado(e),
                                  ),
                                ],
                              ),
                              onTap: () =>
                                  setState(() => _empleadoSeleccionado = e),
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
          Expanded(
            flex: 2,
            child: _empleadoSeleccionado == null
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
                          'Selecciona un empleado\npara ver sus trabajos del día',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.outline,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  )
                : _TrabajosPanel(
                    db: _db,
                    empleado: _empleadoSeleccionado!,
                    fechaSeleccionada: _fechaSeleccionada,
                    onFechaChanged: (f) =>
                        setState(() => _fechaSeleccionada = f),
                    onAgregarTrabajo: _abrirModalAgregarTrabajo,
                    onEliminarTrabajo: _confirmarBorrarTrabajo,
                  ),
          ),
        ],
      ),
    );
  }
}

class _TrabajosPanel extends StatelessWidget {
  const _TrabajosPanel({
    required this.db,
    required this.empleado,
    required this.fechaSeleccionada,
    required this.onFechaChanged,
    required this.onAgregarTrabajo,
    required this.onEliminarTrabajo,
  });

  final AppDatabase db;
  final Empleado empleado;
  final DateTime fechaSeleccionada;
  final ValueChanged<DateTime> onFechaChanged;
  final VoidCallback onAgregarTrabajo;
  final void Function(Trabajo) onEliminarTrabajo;

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
                    'Trabajos - ${empleado.nombre}',
                    style:
                        Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                  ),
                ),
                FilledButton.icon(
                  onPressed: onAgregarTrabajo,
                  icon: const Icon(Icons.add),
                  label: const Text('Agregar trabajo'),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                const Text('Fecha: '),
                Text(
                  '${fechaSeleccionada.day}/${fechaSeleccionada.month}/${fechaSeleccionada.year}',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(width: 8),
                FilledButton.tonalIcon(
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: fechaSeleccionada,
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now()
                          .add(const Duration(days: 365)),
                    );
                    if (picked != null) onFechaChanged(picked);
                  },
                  icon: const Icon(Icons.calendar_today),
                  label: const Text('Cambiar día'),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: StreamBuilder<List<Trabajo>>(
              stream: db.watchTrabajosPorEmpleadoYFecha(
                  empleado.id, fechaSeleccionada),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final trabajos = snapshot.data!;
                if (trabajos.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.work_outline,
                          size: 48,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'No hay trabajos registrados en este día.',
                        ),
                        const SizedBox(height: 8),
                        FilledButton.tonal(
                          onPressed: onAgregarTrabajo,
                          child: const Text('Agregar trabajo'),
                        ),
                      ],
                    ),
                  );
                }
                return FutureBuilder<Map<int, String>>(
                  future: _nombresTipoMueble(db, trabajos),
                  builder: (context, namesSnapshot) {
                    final nombres = namesSnapshot.data ?? {};
                    final total = trabajos.fold<double>(
                        0, (s, t) => s + t.precioTotal);
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.all(8),
                            itemCount: trabajos.length,
                            itemBuilder: (context, i) {
                              final t = trabajos[i];
                              final nombreTipo =
                                  nombres[t.presupuestoId] ?? '—';
                              return Card(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 4),
                                child: ListTile(
                                  title: Text(nombreTipo),
                                  subtitle: Text(
                                    'Cantidad: ${t.cantidad} · '
                                    'P. unit: \$${t.precioUnitario.toStringAsFixed(2)} · '
                                    'Total: \$${t.precioTotal.toStringAsFixed(2)}',
                                  ),
                                  trailing: IconButton(
                                    icon: const Icon(
                                        Icons.delete_outline),
                                    onPressed: () =>
                                        onEliminarTrabajo(t),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const Divider(height: 1),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            'Total del día: \$${total.toStringAsFixed(2)}',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
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

  Future<Map<int, String>> _nombresTipoMueble(
      AppDatabase db, List<Trabajo> trabajos) async {
    final presupuestoIds =
        trabajos.map((t) => t.presupuestoId).toSet().toList();
    final Map<int, String> result = {};
    final tipos = await db.allTiposMueble;
    for (final id in presupuestoIds) {
      final p = await db.getPresupuestoById(id);
      if (p != null) {
        try {
          final tipo = tipos.firstWhere(
              (t) => t.id == p.tipoMuebleId);
          result[id] = tipo.nombre;
        } catch (_) {}
      }
    }
    return result;
  }
}
