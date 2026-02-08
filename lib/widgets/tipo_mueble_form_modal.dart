import 'package:flutter/material.dart';

/// Modal para agregar o editar un tipo de mueble (solo nombre).
class TipoMuebleFormModal extends StatefulWidget {
  const TipoMuebleFormModal({
    super.key,
    this.nombreInicial,
    this.titulo,
  });

  final String? nombreInicial;
  final String? titulo;

  @override
  State<TipoMuebleFormModal> createState() => _TipoMuebleFormModalState();
}

class _TipoMuebleFormModalState extends State<TipoMuebleFormModal> {
  late final TextEditingController _nombreController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.nombreInicial ?? '');
  }

  @override
  void dispose() {
    _nombreController.dispose();
    super.dispose();
  }

  void _guardar() {
    if (_formKey.currentState!.validate()) {
      Navigator.of(context).pop(_nombreController.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    final titulo = widget.titulo ??
        (widget.nombreInicial == null ? 'Agregar tipo de mueble' : 'Editar tipo de mueble');

    return AlertDialog(
      title: Text(titulo),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _nombreController,
          decoration: const InputDecoration(
            labelText: 'Nombre',
            hintText: 'Ej: Mesa, Silla, Estantería',
            border: OutlineInputBorder(),
          ),
          textCapitalization: TextCapitalization.words,
          autofocus: true,
          validator: (v) {
            if (v == null || v.trim().isEmpty) return 'Ingresa el nombre';
            return null;
          },
          onFieldSubmitted: (_) => _guardar(),
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
