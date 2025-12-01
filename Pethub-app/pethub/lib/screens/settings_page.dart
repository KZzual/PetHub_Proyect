import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';     // <<--- IMPORTANTE
import '../utils/app_colors.dart';
import 'privacy_policy_page.dart';
import 'terms_conditios.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {

    // Acceso al ThemeProvider
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.accent,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 1,
        leading: const BackButton(color: AppColors.textDark),
        title: const Text(
          'Configuración',
          style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        children: [

          // --------------------
          //     CUENTA
          // --------------------
          const _SectionHeader(title: 'Cuenta'),

          SwitchListTile(
            title: const Text('Notificaciones', style: TextStyle(color: AppColors.textDark)),
            subtitle: const Text('Recibir alertas de la app'),
            value: _notificationsEnabled,
            onChanged: (value) {
              setState(() {
                _notificationsEnabled = value;
              });
            },
          ),

          // --------------------
          //     APARIENCIA
          // --------------------
          const _SectionHeader(title: 'Apariencia'),

          SwitchListTile(
            title: const Text('Modo Oscuro', style: TextStyle(color: AppColors.textDark)),
            subtitle: const Text('Activar el tema oscuro'),
            value: themeProvider.themeMode == ThemeMode.dark,
            onChanged: (bool value) {
              themeProvider.toggleTheme(value);
            },
          ),

          ListTile(
            title: const Text('Idioma', style: TextStyle(color: AppColors.textDark)),
            subtitle: const Text('Español (Latinoamérica)'),
            leading: const Icon(Icons.language_outlined, color: AppColors.textDark),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),

          // --------------------
          //     SOPORTE
          // --------------------
          const _SectionHeader(title: 'Soporte'),

          ListTile(
            title: const Text('Ayuda y Soporte', style: TextStyle(color: AppColors.textDark)),
            leading: const Icon(Icons.help_outline, color: AppColors.textDark),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),

          ListTile(
            title: const Text('Términos y Condiciones', style: TextStyle(color: AppColors.textDark)),
            leading: const Icon(Icons.description_outlined, color: AppColors.textDark),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const PrivacyPolicyPage()));
            },
          ),

          ListTile(
            title: const Text('Política de Privacidad',
                style: TextStyle(color: AppColors.textDark)),
            leading: const Icon(Icons.description_outlined, color: AppColors.textDark),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const PrivacyPolicyPage()));
            },
          ),
        ],
      ),
    );
  }
}

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
