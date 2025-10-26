import 'package:flutter/material.dart';
// 1. CORRECCIÓN: La ruta correcta para salir de 'screens' y entrar a 'utils'
import '../utils/app_colors.dart'; 
// (Se eliminaron los otros imports innecesarios)

class PostHistoryPage extends StatelessWidget {
  const PostHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 2. Usamos el AppBar que definimos en main_shell.dart
      // (Esta página es un 'hijo', no necesita su propio AppBar aquí)
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          // Usamos el widget de tarjeta de historial
          HistoryPostCard(
            title: 'Luciana de los montes',
            statusText: 'Aún en búsqueda',
            dateText: '28/05/25 13:30',
            statusIcon: Icons.hourglass_top,
            iconColor: AppColors.secondary, // Naranja
          ),
          HistoryPostCard(
            title: 'Cholito',
            statusText: 'En su nuevo hogar',
            dateText: '27/05/25 10:30',
            statusIcon: Icons.check_circle,
            iconColor: AppColors.primary, // Teal
          ),
          // Puedes añadir más tarjetas aquí
        ],
      ),
    );
  }
}

// Widget personalizado para la tarjeta de historial
class HistoryPostCard extends StatelessWidget {
  final String title;
  final String statusText;
  final String dateText;
  final IconData statusIcon;
  final Color iconColor;

  const HistoryPostCard({
    super.key,
    required this.title,
    required this.statusText,
    required this.dateText,
    required this.statusIcon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      color: AppColors.background, // Color de fondo de la tarjeta
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título (ej. "Luciana de los montes")
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 16),
            // Fila para el estado (ej. "Aún en búsqueda")
            Row(
              children: [
                Icon(statusIcon, color: iconColor, size: 28),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      statusText,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dateText,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

