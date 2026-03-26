import 'package:flutter/material.dart';

import '../database/app_database.dart';

class VentaMuebleFormResult {
  const VentaMuebleFormResult({
    required this.tipoMuebleId,
    required this.cantidad,
    required this.fecha,
    required this.precioVenta,
  });

  final int tipoMuebleId;
  final int cantidad;
  final DateTime fecha;
  final double precioVenta;
}

class VentaMuebleFormModal extends StatefulWidget {
  const VentaMuebleFormModal({
    super.key,
    required this.tiposMueble,
    required this.fechaInicial,
    this.titulo,
  });

  final List<TiposMuebleData> tiposMueble;
  final DateTime fechaInicial;
  final String? titulo;

  @override
  State<VentaMuebleFormModal> createState() => _VentaMuebleFormModalState();
}

class _VentaMuebleFormModalState extends State<VentaMuebleFormModal> {
  final _formKey = GlobalKey<FormState>();
  late int _tipoMuebleId;
  late DateTime _fecha;
  final _cantidadController = TextEditingController(text: '1');
  final _precioVentaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tipoMuebleId = widget.tiposMueble.first.id;
    _fecha = widget.fechaInicial;
  }

  @override
  void dispose() {
    _cantidadController.dispose();
    _precioVentaController.dispose();
    super.dispose();
  }

  void _guardar() {
    if (!_formKey.currentState!.validate()) return;
    final cantidad = int.parse(_cantidadController.text.trim());
    final precioVenta = double.parse(
      _precioVentaController.text.trim().replaceFirst(',', '.'),
    );
    Navigator.of(context).pop(VentaMuebleFormResult(
      tipoMuebleId: _tipoMuebleId,
      cantidad: cantidad,
      fecha: _fecha,
      precioVenta: precioVenta,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final titulo = widget.titulo ?? 'Agregar venta de mueble';
    return AlertDialog(
      title: Text(titulo),
      content: SizedBox(
        width: 420,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<int>(
                value: _tipoMuebleId,
                items: widget.tiposMueble
                    .map((t) => DropdownMenuItem<int>(
                          value: t.id,
                          child: Text(t.nombre),
                        ))
                    .toList(),
                onChanged: (v) {
                  if (v == null) return;
                  setState(() => _tipoMuebleId = v);
                },
                decoration: const InputDecoration(
                  labelText: 'Tipo de mueble',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _cantidadController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Cantidad vendida',
                  border: OutlineInputBorder(),
                ),
                validator: (v) {
                  final raw = (v ?? '').trim();
                  if (raw.isEmpty) return 'Ingresa la cantidad';
                  final n = int.tryParse(raw);
                  if (n == null) return 'Cantidad inválida';
                  if (n <= 0) return 'Debe ser mayor que 0';
                  return null;
                },
                onFieldSubmitted: (_) => _guardar(),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _precioVentaController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Precio de venta (total)',
                  border: OutlineInputBorder(),
                ),
                validator: (v) {
                  final raw = (v ?? '').trim();
                  if (raw.isEmpty) return 'Ingresa el precio de venta';
                  final n = double.tryParse(raw.replaceFirst(',', '.'));
                  if (n == null) return 'Precio inválido';
                  if (n < 0) return 'Debe ser mayor o igual a 0';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Fecha: ${_fecha.day}/${_fecha.month}/${_fecha.year}',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  FilledButton.tonalIcon(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _fecha,
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (picked != null) setState(() => _fecha = picked);
                    },
                    icon: const Icon(Icons.calendar_today),
                    label: const Text('Cambiar'),
                  ),
                ],
              ),
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
          onPressed: _guardar,
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}

