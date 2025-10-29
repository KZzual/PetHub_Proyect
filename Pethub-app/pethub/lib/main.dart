import 'package:flutter/material.dart';
import 'screens/login_page.dart'; // Importa la página de login
import 'utils/app_colors.dart'; // Importa la paleta de colores
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // <-- esta línea es clave
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
          foregroundColor: AppColors.textLight, // Color de íconos y texto
          elevation: 0,
        ),
        
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
          ),
        ),
      ),
      
      home: const LoginPage(),
    );
  }
}

