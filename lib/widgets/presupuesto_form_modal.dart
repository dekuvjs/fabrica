import 'package:flutter/material.dart';

/// Resultado del formulario de presupuesto: nombre, descripcion, cantidad, precio unitario.
/// precioTotal se calcula como cantidad * precioUnitario.
class PresupuestoFormResult {
  PresupuestoFormResult({
    required this.nombre,
    this.descripcion,
    required this.cantidad,
    required this.precioUnitario,
  });

  final String nombre;
  final String? descripcion;
  final int cantidad;
  final double precioUnitario;

  double get precioTotal => cantidad * precioUnitario;
}

/// Modal para agregar o editar una línea de presupuesto.
class PresupuestoFormModal extends StatefulWidget {
  const PresupuestoFormModal({
    super.key,
    this.nombreInicial,
    this.descripcionInicial,
    this.cantidadInicial = 1,
    this.precioUnitarioInicial = 0,
    this.titulo,
  });

  final String? nombreInicial;
  final String? descripcionInicial;
  final int cantidadInicial;
  final double precioUnitarioInicial;
  final String? titulo;

  @override
  State<PresupuestoFormModal> createState() => _PresupuestoFormModalState();
}

class _PresupuestoFormModalState extends State<PresupuestoFormModal> {
  late final TextEditingController _nombreController;
  late final TextEditingController _descripcionController;
  late final TextEditingController _cantidadController;
  late final TextEditingController _precioController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.nombreInicial ?? '');
    _descripcionController = TextEditingController(text: widget.descripcionInicial ?? '');
    _cantidadController = TextEditingController(text: '${widget.cantidadInicial}');
    _precioController = TextEditingController(
      text: widget.precioUnitarioInicial == 0 ? '' : widget.precioUnitarioInicial.toString(),
    );
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _descripcionController.dispose();
    _cantidadController.dispose();
    _precioController.dispose();
    super.dispose();
  }

  void _guardar() {
    if (_formKey.currentState!.validate()) {
      final cantidad = int.tryParse(_cantidadController.text.trim()) ?? 0;
      final precio = double.tryParse(_precioController.text.trim().replaceFirst(',', '.')) ?? 0;
      Navigator.of(context).pop(PresupuestoFormResult(
        nombre: _nombreController.text.trim(),
        descripcion: _descripcionController.text.trim().isEmpty
            ? null
            : _descripcionController.text.trim(),
        cantidad: cantidad,
        precioUnitario: precio,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final titulo = widget.titulo ??
        (widget.nombreInicial == null ? 'Agregar presupuesto' : 'Editar presupuesto');

    return AlertDialog(
      title: Text(titulo),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  border: OutlineInputBorder(),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Ingresa el nombre';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descripcionController,
                decoration: const InputDecoration(
                  labelText: 'Descripción (opcional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _cantidadController,
                decoration: const InputDecoration(
                  labelText: 'Cantidad',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (v) {
                  final n = int.tryParse(v ?? '');
                  if (n == null || n < 1) return 'Cantidad debe ser al menos 1';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _precioController,
                decoration: const InputDecoration(
                  labelText: 'Precio unitario',
                  border: OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (v) {
                  final n = double.tryParse((v ?? '').replaceFirst(',', '.'));
                  if (n == null || n < 0) return 'Ingresa un precio válido';
                  return null;
                },
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
