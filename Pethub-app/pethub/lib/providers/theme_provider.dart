import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeProvider extends ChangeNotifier {
  bool isDarkMode = false;

  ThemeMode get themeMode => isDarkMode ? ThemeMode.dark : ThemeMode.light;

  ThemeData get lightTheme => ThemeData(
        brightness: Brightness.light,
        textTheme: GoogleFonts.poppinsTextTheme(), // Fuente global
        appBarTheme: AppBarTheme(
          titleTextStyle: GoogleFonts.pacifico(
            fontSize: 24,
            color: Colors.white,
          ),
        ),
      );

  ThemeData get darkTheme => ThemeData(
        brightness: Brightness.dark,
        textTheme: GoogleFonts.poppinsTextTheme(
          ThemeData.dark().textTheme,
        ),
        appBarTheme: AppBarTheme(
          titleTextStyle: GoogleFonts.pacifico(
            fontSize: 24,
            color: Colors.white,
          ),
        ),
      );

  void toggleTheme(bool value) {
    isDarkMode = value;
    notifyListeners();
  }
}
