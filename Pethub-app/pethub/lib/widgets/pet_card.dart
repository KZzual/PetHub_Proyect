import 'package:flutter/material.dart';
import 'info_chip.dart';
import '../utils/app_colors.dart'; // Importamos los colores

class PetCard extends StatelessWidget {
  const PetCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero, // Quitamos el margen para que se ajuste al padre
      elevation: 0.0, // Quitamos la elevación (sombra)
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      color: AppColors.background, // Usamos el color de fondo
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header de la tarjeta (Usuario)
          ListTile(
            leading: const CircleAvatar(
              backgroundImage: NetworkImage('https://placehold.co/150x150/EAA0A2/white?text=User'),
            ),
            title: const Text('Juan Pérez', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textDark)),
            subtitle: const Text('Hace 1 semanas'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.location_on, size: 16.0, color: AppColors.secondary),
                const SizedBox(width: 4),
                Text('5 km', style: TextStyle(color: AppColors.secondary)),
              ],
            ),
          ),
          
          // Imagen principal de la mascota
          Image.asset(
            'assets/dog_image.jpg',
            height: 250,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 250,
                width: double.infinity,
                color: AppColors.accent,
                alignment: Alignment.center,
                child: const Text('Error al cargar imagen', style: TextStyle(color: AppColors.textDark)),
              );
            },
          ),
          
          // Cuerpo de la tarjeta (info y tags)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Max',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textDark),
                ),
                const SizedBox(height: 16),
                
                // Grilla de información (Perro, Labrador, etc.)
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: const [
                          InfoChip(icon: Icons.pets, text: 'Perro'),
                          SizedBox(height: 8),
                          InfoChip(icon: Icons.calendar_today, text: '6 meses'),
                          SizedBox(height: 8),
                          InfoChip(icon: Icons.location_on_outlined, text: 'Madrid, España'),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        children: const [
                          InfoChip(icon: Icons.label_outline, text: 'Labrador'),
                          SizedBox(height: 8),
                          InfoChip(icon: Icons.male, text: 'Macho'),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Tags (Vacunado, Adiestrado)
                Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: [
                    _buildTag('Vacunado', Colors.green),
                    _buildTag('Adiestrado', Colors.blue),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget de ayuda para los tags ("pills")
  Widget _buildTag(String text, Color color) {
    return Chip(
      label: Text(text, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
      // ¡AQUÍ ESTÁ LA CORRECCIÓN!
      // Usamos .withAlpha(38) que equivale a ~15% de opacidad
      backgroundColor: color.withAlpha(38),
      side: BorderSide.none,
      avatar: Icon(Icons.check_circle, color: color, size: 18),
    );
  }
}

