import 'package:flutter/material.dart';

// Basado en tu paleta: https://coolors.co/3e8e7e-f4a261-faf9f6-2b2d42-e9c46A
class AppColors {
  // Convertir un código HEX a un Color de Flutter
  static const Color _teal = Color(0xFF3E8E7E);
  static const Color _orange = Color(0xFFF4A261);
  static const Color _white = Color(0xFFFAF9F6);
  static const Color _darkBlue = Color(0xFF2B2D42);
  static const Color _yellow = Color(0xFFE9C46A);

  // Colores principales de la App
  static const Color primary = _teal;
  static const Color secondary = _orange;
  static const Color accent = _yellow;
  
  // Colores de fondo y texto
  static const Color background = _white;
  static const Color textDark = _darkBlue;
  static const Color textLight = _white;
}
