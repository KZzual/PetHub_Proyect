import 'package:flutter/material.dart';
// 1. ASEGÚRATE de que esta importación sea correcta.
//    Asume que 'info_chip.dart' está en la MISMA carpeta 'widgets'.
import 'info_chip.dart';

class PetCard extends StatelessWidget {
  const PetCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 2.0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header de la Card
          ListTile(
            leading: const CircleAvatar(
              backgroundImage: NetworkImage('https://placehold.co/150x150/EAA0A2/white?text=User'),
            ),
            title: const Text('Juan Pérez', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Hace 1 semanas'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.location_on, size: 16.0, color: Colors.blue),
                SizedBox(width: 4),
                Text('5 km', style: TextStyle(color: Colors.blue)),
              ],
            ),
          ),
          
          // Imagen (seguirá fallando hasta que añadas los assets)
          Image.asset(
            'assets/dog_image.jpg',
            height: 250,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 250,
                width: double.infinity,
                color: Colors.grey[300],
                child: const Center(
                  child: Text('Error al cargar imagen'),
                ),
              );
            },
          ),
          
          // Cuerpo de la Card
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Max',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                
                // 2. ESTA ES LA SECCIÓN PROBLEMÁTICA
                //    Asegúrate de que esté usando 'InfoChip'
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
                
                // Tags
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

  Widget _buildTag(String text, Color color) {
    return Chip(
      label: Text(text, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
      backgroundColor: color.withOpacity(0.15),
      side: BorderSide.none,
      avatar: Icon(Icons.check_circle, color: color, size: 18),
    );
  }
}