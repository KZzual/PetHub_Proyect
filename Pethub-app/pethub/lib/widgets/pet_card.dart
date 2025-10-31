import 'package:flutter/material.dart';
import 'info_chip.dart';
import '../utils/app_colors.dart';

class PetCard extends StatelessWidget {
  final String name;
  final String species;
  final String breed;
  final String gender;
  final String age;
  final String location;
  final String photoUrl;
  final String userId;
  final String userName;
  final String userPhoto;
  final String timeAgo;


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
    required this.userName,
    required this.userPhoto,
    required this.timeAgo,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0.0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      color: AppColors.background,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header con datos del usuario
          ListTile(
            leading: CircleAvatar(
              backgroundImage: userPhoto.isNotEmpty
                  ? NetworkImage(userPhoto)
                  : const AssetImage('assets/default_user.png') as ImageProvider,
            ),
            title: Text(
              userName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            subtitle: Text(timeAgo, style: TextStyle(color: Colors.grey[600])),
            ),
          // Imagen principal del post
          photoUrl.isNotEmpty
              ? Image.network(
                  photoUrl,
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                )
              : Container(
                  height: 250,
                  color: AppColors.accent,
                  alignment: Alignment.center,
                  child: const Text(
                    'Sin imagen',
                    style: TextStyle(color: AppColors.textDark),
                  ),
                ),

          // Info del post
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 16),

                // Fila de info (especie, raza, edad, etc.)
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
                            icon: gender == 'Macho'
                                ? Icons.male
                                : Icons.female,
                            text: gender,
                          ),
                        ],
                      ),
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
}
