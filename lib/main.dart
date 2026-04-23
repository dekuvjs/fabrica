import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'firebase_options.dart';
import 'screens/main_shell_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } else {
    await Firebase.initializeApp();
  }

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
