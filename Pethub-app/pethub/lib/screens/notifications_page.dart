// 1. IMPORTAMOS LOS PAQUETES
import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 2. SIN SCAFFOLD, SIN APPBAR
    // MainShell (el padre) los controla.
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      children: const [
        // Usaremos un widget personalizado para cada item
        _NotificationItem(
          icon: Icons.favorite,
          iconColor: Colors.red,
          title: 'A Juan Pérez le gustó tu publicación',
          subtitle: 'Sobre: "Max"',
          time: 'Hace 5 minutos',
        ),
        _NotificationItem(
          icon: Icons.chat_bubble,
          iconColor: AppColors.primary,
          title: 'Ana Silva comentó en tu publicación',
          subtitle: '"¿Sigue disponible?"',
          time: 'Hace 20 minutos',
        ),
        _NotificationItem(
          icon: Icons.pets,
          iconColor: AppColors.secondary,
          title: 'Nueva mascota cerca de ti',
          subtitle: 'Un nuevo "Labrador" fue publicado a 2km.',
          time: 'Hace 1 hora',
        ),
        _NotificationItem(
          icon: Icons.task_alt,
          iconColor: Colors.green,
          title: '¡"Cholito" ha sido adoptado!',
          subtitle: 'Tu publicación ha sido marcada como "En su nuevo hogar".',
          time: 'Ayer',
        ),
      ],
    );
  }
}

// --- Widget Privado para el Item de Notificación ---

class _NotificationItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String time;

  const _NotificationItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
      decoration: BoxDecoration(
        color: AppColors.background, // Fondo blanco
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(15), // Sombra muy sutil
            blurRadius: 5.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. El Icono
          CircleAvatar(
            backgroundColor: iconColor.withAlpha(26), // Opacidad
            radius: 20,
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 16),
          // 2. El Contenido (Título y Subtítulo)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // 3. La Hora
          Text(
            time,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
