import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import 'login_page.dart'; // Importamos Login para "Cerrar Sesión"
import 'package:shared_preferences/shared_preferences.dart';
import '../auth_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // Variables para controlar el estado de los switches
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.accent, // Fondo grisáceo
      appBar: AppBar(
        // Usamos el color de fondo del tema
        backgroundColor: AppColors.background,
        elevation: 1,
        // Flecha de 'atrás' con el color oscuro
        leading: const BackButton(color: AppColors.textDark),
        title: const Text(
          'Configuración',
          style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        children: [
          // --- Sección de Cuenta ---
          const _SectionHeader(title: 'Cuenta'),
          SwitchListTile(
            title: const Text('Notificaciones', style: TextStyle(color: AppColors.textDark)),
            subtitle: const Text('Recibir alertas de la app'),
            value: _notificationsEnabled,
            onChanged: (bool value) {
              setState(() {
                _notificationsEnabled = value;
              });
            },
            // La línea 'activeColor' fue eliminada. Tomará el color del Theme.
          ),
          
          // --- Sección de Apariencia ---
          const _SectionHeader(title: 'Apariencia'),
          SwitchListTile(
            title: const Text('Modo Oscuro', style: TextStyle(color: AppColors.textDark)),
            subtitle: const Text('Activar el tema oscuro'),
            value: _darkModeEnabled,
            onChanged: (bool value) {
              setState(() {
                _darkModeEnabled = value;
              });
            },
            // La línea 'activeColor' fue eliminada. Tomará el color del Theme.
          ),
          ListTile(
            title: const Text('Idioma', style: TextStyle(color: AppColors.textDark)),
            subtitle: const Text('Español (Latinoamérica)'),
            leading: const Icon(Icons.language_outlined, color: AppColors.textDark),
            trailing: const Icon(Icons.chevron_right),
            onTap: () { /* Lógica para cambiar idioma */ },
          ),
          
          // --- Sección de Soporte y Cierre de Sesión ---
          const _SectionHeader(title: 'Soporte'),
          ListTile(
            title: const Text('Ayuda y Soporte', style: TextStyle(color: AppColors.textDark)),
            leading: const Icon(Icons.help_outline, color: AppColors.textDark),
            trailing: const Icon(Icons.chevron_right),
            onTap: () { /* Lógica de Ayuda */ },
          ),
          ListTile(
            title: const Text('Términos y Condiciones', style: TextStyle(color: AppColors.textDark)),
            leading: const Icon(Icons.description_outlined, color: AppColors.textDark),
            trailing: const Icon(Icons.chevron_right),
            onTap: () { /* Lógica de Términos */ },
          ),
          const Divider(height: 30, indent: 16, endIndent: 16),
          ListTile(
            title: const Text('Cerrar Sesión', style: TextStyle(color: Colors.red)),
            leading: const Icon(Icons.logout, color: Colors.red),
            onTap: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool('remember_me', false); // 🔴 No recordar más

              await AuthService.instance.signOut(); // 🔥 Cierra sesión en Firebase

              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                  (_) => false,
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

// Widget privado para los cabezales de sección (ej. "Cuenta")
class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 8.0),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}

