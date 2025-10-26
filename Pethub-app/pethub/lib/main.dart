import 'package:flutter/material.dart';

// 1. Importa tu NUEVA página de login
import 'screens/login_page.dart';
// 2. Importa tu NUEVA paleta de colores
import 'utils/app_colors.dart'; 

// 3. La función main, el punto de entrada de TODO.
void main() {
  runApp(const MyApp());
}

// 4. MyApp: El Widget Raíz de tu aplicación
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 5. Retorna MaterialApp
    return MaterialApp(
      // Quita la cinta de "DEBUG"
      debugShowCheckedModeBanner: false,
      
      title: 'PetHub',
      
      // 6. Configuración del Tema Global (¡ACTUALIZADO!)
      theme: ThemeData(
        // Define el color primario
        primarySwatch: Colors.green, // Un fallback, el colorScheme es más importante
        
        // Define la paleta de colores principal de la app
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary, // El color base (Verde Teal)
          primary: AppColors.primary,
          secondary: AppColors.secondary, // El Naranja
          background: AppColors.background, // El Blanco Crema
        ),
        
        // Define el color de fondo de todas las pantallas
        scaffoldBackgroundColor: AppColors.background,

        // Define el tema de todas las AppBars
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primary, // Fondo Verde Teal
          foregroundColor: AppColors.textLight, // Texto e íconos blancos
          elevation: 0,
        ),
        
        // Define el tema de los TextButton (ej. "Olvidaste tu contraseña?")
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary, // Texto Verde Teal
          ),
        ),
        
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      
      // 7. La propiedad "home"
      // La app sigue iniciando en la LoginPage
      home: const LoginPage(),
    );
  }
}

