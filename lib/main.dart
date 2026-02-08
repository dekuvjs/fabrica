import 'package:flutter/material.dart';

import 'screens/main_shell_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const FabricaMueblesApp());
}

class FabricaMueblesApp extends StatelessWidget {
  const FabricaMueblesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fábrica de Muebles',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown),
        useMaterial3: true,
      ),
      home: const MainShellScreen(),
    );
  }
}
