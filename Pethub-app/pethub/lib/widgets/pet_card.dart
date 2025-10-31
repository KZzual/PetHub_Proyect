import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import 'info_chip.dart';

class PetCard extends StatelessWidget {
  final String name;
  final String species;
  final String breed;
  final String gender;
  final String age;
  final String location;
  final String photoUrl;
  final String userId;

  const PetCard({
    super.key,
    required this.name,
    required this.species,
    required this.breed,
    required this.gender,
    required this.age,
    required this.location,
    required this.photoUrl,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      elevation: 3,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      color: AppColors.background,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Encabezado (usuario)
          ListTile(
            leading: const CircleAvatar(
              backgroundImage: NetworkImage(
                'https://placehold.co/150x150/EAA0A2/white?text=User',
              ),
            ),
            title: Text(
              userId.isNotEmpty ? 'Usuario: $userId' : 'Usuario desconocido',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            subtitle: const Text('Hace poco'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.location_on, size: 16.0, color: AppColors.secondary),
                SizedBox(width: 4),
                Text('Cerca de ti', style: TextStyle(color: AppColors.secondary)),
              ],
            ),
          ),

          // Imagen principal
          photoUrl.isNotEmpty
              ? Image.network(
                  photoUrl,
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 250,
                    color: AppColors.accent,
                    alignment: Alignment.center,
                    child: const Text(
                      'Error al cargar imagen',
                      style: TextStyle(color: AppColors.textDark),
                    ),
                  ),
                )
              : Container(
                  height: 250,
                  color: AppColors.accent,
                  alignment: Alignment.center,
                  child: const Icon(Icons.pets, size: 60, color: AppColors.textDark),
                ),

          // Cuerpo de la tarjeta
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 12),

                // Grilla de información (especie, edad, raza, ubicación)
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          InfoChip(icon: Icons.pets, text: species),
                          const SizedBox(height: 8),
                          InfoChip(icon: Icons.calendar_today, text: age),
                          const SizedBox(height: 8),
                          InfoChip(icon: Icons.location_on_outlined, text: location),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        children: [
                          InfoChip(icon: Icons.label_outline, text: breed),
                          const SizedBox(height: 8),
                          InfoChip(
                            icon: gender.toLowerCase() == 'macho'
                                ? Icons.male
                                : Icons.female,
                            text: gender,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Ejemplo de etiquetas o tags fijos
                Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: [
                    _buildTag('Vacunado', Colors.green),
                    _buildTag('Sociable', Colors.blue),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget para los tags decorativos
  Widget _buildTag(String text, Color color) {
    return Chip(
      label: Text(
        text,
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
      backgroundColor: color.withAlpha(38),
      side: BorderSide.none,
      avatar: Icon(Icons.check_circle, color: color, size: 18),
    );
  }
}
