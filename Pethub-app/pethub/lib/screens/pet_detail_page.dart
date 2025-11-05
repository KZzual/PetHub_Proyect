import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class PetDetailPage extends StatelessWidget {
  final String docId;
  final Map<String, dynamic> petData;

  const PetDetailPage({
    super.key,
    required this.docId,
    required this.petData,
  });

  @override
  Widget build(BuildContext context) {
    final photoUrl   = (petData['photoUrl'] ?? '') as String;
    final name       = (petData['name'] ?? 'Sin nombre') as String;
    final species    = (petData['species'] ?? 'Desconocido') as String;
    final breed      = (petData['breed'] ?? 'Sin raza') as String;
    final gender     = (petData['gender'] ?? 'No especificado') as String;
    final age        = (petData['age'] ?? '') as String;
    final location   = (petData['location'] ?? '') as String;
    final userName   = (petData['userName'] ?? 'Usuario desconocido') as String;
    final userPhoto  = (petData['userPhoto'] ?? '') as String;
    final description = (petData['description'] ?? petData['autoDescription'] ?? '') as String;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Detalle de publicación', style: TextStyle(color: AppColors.textLight)),
        iconTheme: const IconThemeData(color: AppColors.textLight),
        backgroundColor: AppColors.primary,
      ),
      body: ListView(
        children: [
          // Imagen principal
          if (photoUrl.isNotEmpty)
            AspectRatio(
              aspectRatio: 16/9,
              child: Image.network(
                photoUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _imageFallback(),
              ),
            )
          else
            _imageFallback(),

          // Contenido
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nombre
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 8),

                // Etiquetas rápidas
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _pill(icon: Icons.pets, label: species),
                    if (breed.isNotEmpty) _pill(icon: Icons.label_outline, label: breed),
                    if (gender.isNotEmpty) _pill(icon: gender == 'Macho' ? Icons.male : Icons.female, label: gender),
                    if (age.isNotEmpty) _pill(icon: Icons.calendar_today, label: age),
                    if (location.isNotEmpty) _pill(icon: Icons.location_on_outlined, label: location),
                  ],
                ),

                const SizedBox(height: 16),

                // Descripción
                const Text(
                  'Descripción',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description.isNotEmpty
                      ? description
                      : 'Sin descripción.',
                  style: TextStyle(
                    color: Colors.grey[800],
                    height: 1.3,
                  ),
                ),

                const SizedBox(height: 24),
                const Divider(),

                // Publicado por
                const SizedBox(height: 8),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundImage: userPhoto.isNotEmpty
                          ? NetworkImage(userPhoto)
                          : const AssetImage('assets/default_user.png') as ImageProvider,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Publicado por', style: TextStyle(color: Colors.grey)),
                          Text(
                            userName,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: AppColors.textDark,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Botón de contacto (placeholder)
                    TextButton.icon(
                      onPressed: () {
                        // FUTURO: WhatsApp / chat interno
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Función de contacto próximamente')),
                        );
                      },
                      icon: const Icon(Icons.chat_bubble_outline),
                      label: const Text('Contactar'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _pill({required IconData icon, required String label}) {
    return Chip(
      avatar: Icon(icon, size: 18, color: AppColors.textDark),
      label: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: AppColors.textDark, // texto oscuro para contraste con amarillo
        ),
      ),
      backgroundColor: AppColors.accent,
      side: BorderSide.none,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  Widget _imageFallback() {
    return Container(
      height: 200,
      color: AppColors.accent,
      alignment: Alignment.center,
      child: const Text('Sin imagen', style: TextStyle(color: AppColors.textDark)),
    );
  }
}
