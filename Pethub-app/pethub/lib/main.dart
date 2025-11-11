import 'package:flutter/material.dart';
import 'screens/login_page.dart';
import 'utils/app_colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'main_shell.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/verify_email_page.dart';
import 'screens/chat_page.dart';

// 1. IMPORTAMOS GOOGLE FONTS
import 'package:google_fonts/google_fonts.dart';

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
    final textTheme = Theme.of(context).textTheme;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PetHub',
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255),

        textTheme: GoogleFonts.latoTextTheme(textTheme).apply(
          bodyColor: AppColors.textDark,
          displayColor: AppColors.textDark,
        ),

        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textLight,
          elevation: 0,
        ),

        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: AppColors.primary),
        ),
      ),

      home: const _DeciderPage(),

      // GENERADOR DE RUTAS PARA EL CHAT
      onGenerateRoute: (settings) {
        if (settings.name == '/chat') {
          final args = settings.arguments as Map<String, dynamic>;

          return MaterialPageRoute(
            builder: (_) => ChatPage(
              chatId: args['chatId'],
              otherUserId: args['otherUserId'],
              otherUserName: args['otherUserName'],
              otherUserPhoto: args['otherUserPhoto'],
            ),
          );
        }
        return null;
      },
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
        // Si no hay usuario → login
        if (user == null) {
          return const LoginPage();
        }
        // Si el email no está verificado → verificar email
        if (!user.emailVerified) {
          return const VerifyEmailPage();
        }
        // Si todo bien → main shell
        if (snapshot.data == true) {
          return const MainShell();
        }
        // Si no → login
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
