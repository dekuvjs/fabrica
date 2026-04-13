import 'package:flutter/material.dart';

/// Tipos de empleado permitidos.
const List<String> kTiposEmpleado = ['cajonero', 'tapicero', 'costurero'];

/// Modal para agregar o editar un empleado (nombre y tipo de empleado).
class EmpleadoFormModal extends StatefulWidget {
  const EmpleadoFormModal({
    super.key,
    this.nombreInicial,
    this.tipoInicial,
    this.titulo,
  });

  final String? nombreInicial;
  final String? tipoInicial;
  final String? titulo;

  @override
  State<EmpleadoFormModal> createState() => _EmpleadoFormModalState();
}

class _EmpleadoFormModalState extends State<EmpleadoFormModal> {
  late final TextEditingController _nombreController;
  late String _tipoSeleccionado;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.nombreInicial ?? '');
    _tipoSeleccionado = widget.tipoInicial ?? kTiposEmpleado.first;
  }

  @override
  void dispose() {
    _nombreController.dispose();
    super.dispose();
  }

  void _guardar() {
    if (_formKey.currentState!.validate()) {
      Navigator.of(context).pop(
        EmpleadoFormResult(
          nombre: _nombreController.text.trim(),
          tipoEmpleado: _tipoSeleccionado,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final titulo =
        widget.titulo ??
        (widget.nombreInicial == null ? 'Agregar empleado' : 'Editar empleado');

    return AlertDialog(
      title: Text(titulo),
      content: Form(
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
              textCapitalization: TextCapitalization.words,
              autofocus: true,
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Ingresa el nombre';
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _tipoSeleccionado,
              decoration: const InputDecoration(
                labelText: 'Tipo de empleado',
                border: OutlineInputBorder(),
              ),
              items: kTiposEmpleado.map((t) {
                return DropdownMenuItem(
                  value: t,
                  child: Text(t[0].toUpperCase() + t.substring(1)),
                );
              }).toList(),
              onChanged: (v) => setState(() => _tipoSeleccionado = v!),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton(onPressed: _guardar, child: const Text('Guardar')),
      ],
    );
  }
}

/// Resultado del formulario de empleado.
class EmpleadoFormResult {
  EmpleadoFormResult({required this.nombre, required this.tipoEmpleado});

  final String nombre;
  final String tipoEmpleado;
}
