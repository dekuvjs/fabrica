import 'package:flutter/material.dart';

import 'home_screen.dart';
import 'tipos_muebles_screen.dart';

/// Pantalla contenedora con menú de pestañas para navegar entre Inicio y Tipos de muebles.
class MainShellScreen extends StatelessWidget {
  const MainShellScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Fábrica de Muebles'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          bottom: TabBar(
            tabs: const [
              Tab(icon: Icon(Icons.home_outlined), text: 'Inicio'),
              Tab(icon: Icon(Icons.weekend_outlined), text: 'Tipos de muebles'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            HomeScreen(showAppBar: false),
            TiposMueblesScreen(showAppBar: false),
          ],
        ),
      ),
    );
  }
}
