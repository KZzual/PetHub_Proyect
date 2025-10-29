import 'package:flutter/material.dart';
// 1. IMPORTAMOS GOOGLE FONTS
import 'package:google_fonts/google_fonts.dart';
import 'screens/login_page.dart'; 
import 'utils/app_colors.dart'; 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 2. Obtenemos el tema de texto base para poder modificarlo
    final textTheme = Theme.of(context).textTheme;

    return MaterialApp(
      debugShowCheckedModeBanner: false, 
      title: 'PetHub',
      
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255), 

        // 3. APLICAMOS LA FUENTE "LATO" A TOD EL TEXTO
        // Usamos GoogleFonts.latoTextTheme() para aplicar Lato
        // a todos los estilos de texto (body, headline, etc.)
        textTheme: GoogleFonts.latoTextTheme(textTheme).apply(
          bodyColor: AppColors.textDark, // Color por defecto para texto normal
          displayColor: AppColors.textDark, // Color por defecto para títulos
        ),

        // Definimos el estilo global de los AppBars
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textLight,
          elevation: 0,
          // NOTA: El título del AppBar en MainShell usará 'Pacifico',
          // sobreescribiendo este estilo global solo para el título.
        ),
        
        // Estilo global para TextButton
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
          ),
        ),
        // Puedes añadir más personalización del tema aquí
        // ej. ElevatedButtonTheme, CardTheme, etc.
      ),
      
      home: const LoginPage(),
    );
  }
}

