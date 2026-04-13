import 'package:flutter/material.dart';

import 'empleados_monthly_screen.dart';
import 'home_screen.dart';
import 'tipos_muebles_screen.dart';
import 'ventas_muebles_screen.dart';

/// Pantalla contenedora con menú de pestañas para navegar entre pantallas.
class MainShellScreen extends StatelessWidget {
  const MainShellScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Fábrica de Muebles'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          bottom: TabBar(
            tabs: const [
              Tab(icon: Icon(Icons.home_outlined), text: 'Inicio'),
              Tab(icon: Icon(Icons.weekend_outlined), text: 'Tipos de muebles'),
              Tab(icon: Icon(Icons.shopping_cart_outlined), text: 'Ventas'),
              Tab(icon: Icon(Icons.people_outlined), text: 'Empleados'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            HomeScreen(showAppBar: false),
            TiposMueblesScreen(showAppBar: false),
            VentasMueblesScreen(showAppBar: false),
            EmpleadosMonthlyScreen(showAppBar: false),
          ],
        ),
      ),
    );
  }
}
