import 'package:flutter/material.dart';
import 'auth_gate.dart';
import 'CommonComponents/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const IHEEApp());
}

class IHEEApp extends StatelessWidget {
  const IHEEApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IHA Expenses App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.getAppTheme(),
      // Hopefully this being static doesnt bite us later
      home: const AuthGate(),
    );
  }
}
