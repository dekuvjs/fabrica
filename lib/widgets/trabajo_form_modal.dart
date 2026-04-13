import 'package:flutter/material.dart';

import '../database/app_database.dart';
import '../utils/currency_format.dart';

/// Modal para agregar un trabajo a un empleado.
/// Tipo de mueble, cantidad, fecha (por defecto hoy).
/// El precio se toma del presupuesto del mueble según el tipo de empleado.
class TrabajoFormModal extends StatefulWidget {
  const TrabajoFormModal({
    super.key,
    required this.db,
    required this.empleado,
    required this.tiposMueble,
  });

  final AppDatabase db;
  final Empleado empleado;
  final List<TiposMuebleData> tiposMueble;

  @override
  State<TrabajoFormModal> createState() => _TrabajoFormModalState();
}

class _TrabajoFormModalState extends State<TrabajoFormModal> {
  TiposMuebleData? _tipoMuebleSeleccionado;
  Presupuesto? _presupuestoEncontrado;
  bool _cargandoPresupuesto = false;
  String? _errorPresupuesto;

  late final TextEditingController _cantidadController;
  late DateTime _fecha;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _cantidadController = TextEditingController(text: '1');
    _cantidadController.addListener(() => setState(() {}));
    _fecha = DateTime.now();
    if (widget.tiposMueble.isNotEmpty) {
      _tipoMuebleSeleccionado = widget.tiposMueble.first;
      _buscarPresupuesto();
    }
  }

  @override
  void dispose() {
    _cantidadController.dispose();
    super.dispose();
  }

  Future<void> _buscarPresupuesto() async {
    if (_tipoMuebleSeleccionado == null) return;
    setState(() {
      _cargandoPresupuesto = true;
      _errorPresupuesto = null;
      _presupuestoEncontrado = null;
    });
    final p = await widget.db.getPresupuestoPorTipoYNombreLinea(
      _tipoMuebleSeleccionado!.id,
      widget.empleado.tipoEmpleado,
    );
    if (mounted) {
      setState(() {
        _cargandoPresupuesto = false;
        _presupuestoEncontrado = p;
        if (p == null) {
          _errorPresupuesto =
              'No hay línea de presupuesto "${widget.empleado.tipoEmpleado}" para ${_tipoMuebleSeleccionado!.nombre}. '
              'Agrega una línea con ese nombre en el presupuesto del mueble.';
        }
      });
    }
  }

  void _guardar() {
    if (_formKey.currentState!.validate() && _presupuestoEncontrado != null) {
      final cantidad = int.tryParse(_cantidadController.text.trim()) ?? 0;
      final fecha = DateTime(_fecha.year, _fecha.month, _fecha.day);
      final precioUnitario = _presupuestoEncontrado!.precioUnitario;
      final precioTotal = precioUnitario * cantidad;
      Navigator.of(context).pop(
        TrabajoFormResult(
          empleadoId: widget.empleado.id,
          presupuestoId: _presupuestoEncontrado!.id,
          cantidad: cantidad,
          fecha: fecha,
          precioUnitario: precioUnitario,
          precioTotal: precioTotal,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Agregar trabajo - ${widget.empleado.nombre}'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField<TiposMuebleData>(
                value: _tipoMuebleSeleccionado,
                decoration: const InputDecoration(
                  labelText: 'Tipo de mueble',
                  border: OutlineInputBorder(),
                ),
                items: widget.tiposMueble.map((t) {
                  return DropdownMenuItem(value: t, child: Text(t.nombre));
                }).toList(),
                onChanged: (v) {
                  setState(() => _tipoMuebleSeleccionado = v);
                  _buscarPresupuesto();
                },
              ),
              if (_cargandoPresupuesto) ...[
                const SizedBox(height: 12),
                const Center(child: CircularProgressIndicator()),
              ],
              if (_errorPresupuesto != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _errorPresupuesto!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onErrorContainer,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
              if (_presupuestoEncontrado != null) ...[
                const SizedBox(height: 12),
                Text(
                  'Precio unitario: ${formatCurrency(_presupuestoEncontrado!.precioUnitario)}',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                ),
              ],
              const SizedBox(height: 16),
              TextFormField(
                controller: _cantidadController,
                decoration: const InputDecoration(
                  labelText: 'Cantidad de muebles trabajados',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (v) {
                  final n = int.tryParse(v ?? '');
                  if (n == null || n < 1) return 'Cantidad debe ser al menos 1';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Fecha'),
                subtitle: Text(
                  '${_fecha.day}/${_fecha.month}/${_fecha.year}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                trailing: FilledButton.tonalIcon(
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _fecha,
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (picked != null && mounted) {
                      setState(() => _fecha = picked);
                    }
                  },
                  icon: const Icon(Icons.calendar_today),
                  label: const Text('Cambiar'),
                ),
              ),
              if (_presupuestoEncontrado != null &&
                  _cantidadController.text.isNotEmpty) ...[
                const SizedBox(height: 8),
                Builder(
                  builder: (context) {
                    final cant = int.tryParse(_cantidadController.text) ?? 0;
                    final total = _presupuestoEncontrado!.precioUnitario * cant;
                    return Text(
                      'Total: ${formatCurrency(total)}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: _presupuestoEncontrado != null ? _guardar : null,
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}

/// Resultado del formulario de trabajo (para insertar en DB).
class TrabajoFormResult {
  TrabajoFormResult({
    required this.empleadoId,
    required this.presupuestoId,
    required this.cantidad,
    required this.fecha,
    required this.precioUnitario,
    required this.precioTotal,
  });

  final int empleadoId;
  final int presupuestoId;
  final int cantidad;
  final DateTime fecha;
  final double precioUnitario;
  final double precioTotal;
}
