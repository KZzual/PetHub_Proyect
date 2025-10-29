import 'package:flutter/material.dart';
import 'screens/login_page.dart';
import 'utils/app_colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'main_shell.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/verify_email_page.dart';


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

    return FutureBuilder<bool>(
      future: _checkRememberMe(user),
      builder: (context, snapshot) {
        // Mientras carga preferencia
        if (snapshot.connectionState != ConnectionState.done) {
          return const SizedBox.shrink();
        }

        // 1️⃣ Si no hay usuario → login
        if (user == null) {
          return const LoginPage();
        }

        // 2️⃣ Si hay usuario pero NO está verificado → mostrar página de verificación
        if (!user.emailVerified) {
          return const VerifyEmailPage();
        }

        // 3️⃣ Si está logueado y verificado → revisar remember_me
        if (snapshot.data == true) {
          return const MainShell();
        }

        // 4️⃣ Si no debe recordar → login
        return const LoginPage();
      },
    );
  }

  Future<bool> _checkRememberMe(User? user) async {
    // Si no hay usuario → login
    if (user == null) return false;

    final prefs = await SharedPreferences.getInstance();
    final rememberMe = prefs.getBool('remember_me') ?? true;

    // Si NO marcó recordar → cerrar sesión automáticamente
    if (!rememberMe) {
      await FirebaseAuth.instance.signOut();
      return false;
    }

    return true;
  }
}

