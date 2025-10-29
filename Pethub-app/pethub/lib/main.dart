import 'package:flutter/material.dart';
import 'screens/login_page.dart';
import 'utils/app_colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'main_shell.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PetHub',
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: AppColors.primary,
        // ¡AQUÍ ESTÁ LA CORRECCIÓN DEL COLOR!
        // Esta línea cambia el fondo de AMARILLO a BLANCO/GRIS.
        scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
        // Tema global para todos los AppBars
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textLight,
          elevation: 0,
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: AppColors.primary),
        ),
      ),
      home: const _DeciderPage(), //se decide Login o MainShell
    );
  }
}

class _DeciderPage extends StatelessWidget {
  const _DeciderPage();

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null && user.emailVerified) {
      return const MainShell();
    }
    return const LoginPage();
  }
}
