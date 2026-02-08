import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';

import '../database/app_database.dart';
import '../reports/excel_report_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.showAppBar = true});

  final bool showAppBar;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final AppDatabase _db;
  late final ExcelReportService _excelService;

  @override
  void initState() {
    super.initState();
    _db = AppDatabase();
    _excelService = ExcelReportService();
  }

  @override
  void dispose() {
    _db.close();
    super.dispose();
  }

  Future<void> _agregarProductoEjemplo() async {
    await _db.insertProducto(ProductosCompanion.insert(
      nombre: 'Mesa de madera',
      descripcion: const Value('Mesa de roble 1.20m'),
      precio: const Value(250.0),
      stock: const Value(10),
    ));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Producto de ejemplo agregado')),
      );
    }
  }

  Future<void> _generarReporteExcel() async {
    try {
      final productos = await _db.allProductos;
      final path = await _excelService.generarReporteProductos(
        productos,
        nombreArchivo: 'reporte_productos_${DateTime.now().millisecondsSinceEpoch}',
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Reporte guardado en: $path')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _generarPlantillaExcel() async {
    try {
      final path = await _excelService.generarPlantilla(
        nombreArchivo: 'plantilla_${DateTime.now().millisecondsSinceEpoch}',
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Plantilla guardada en: $path')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.showAppBar
          ? AppBar(
              title: const Text('Fábrica de Muebles'),
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            )
          : null,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                FilledButton.icon(
                  onPressed: _agregarProductoEjemplo,
                  icon: const Icon(Icons.add),
                  label: const Text('Agregar producto ejemplo'),
                ),
                const SizedBox(width: 12),
                FilledButton.tonalIcon(
                  onPressed: _generarReporteExcel,
                  icon: const Icon(Icons.table_chart),
                  label: const Text('Generar reporte Excel'),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed: _generarPlantillaExcel,
                  icon: const Icon(Icons.description),
                  label: const Text('Plantilla Excel'),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: StreamBuilder<List<Producto>>(
              stream: _db.watchProductos(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final productos = snapshot.data!;
                if (productos.isEmpty) {
                  return const Center(
                    child: Text(
                      'No hay productos. Pulsa "Agregar producto ejemplo".',
                      style: TextStyle(fontSize: 16),
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: productos.length,
                  itemBuilder: (context, i) {
                    final p = productos[i];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      child: ListTile(
                        title: Text(p.nombre),
                        subtitle: Text(
                          'Precio: \$${p.precio.toStringAsFixed(2)} · Stock: ${p.stock}',
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () async {
                            await _db.deleteProducto(p);
                          },
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
    );
  }
}
