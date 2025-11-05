// 1. IMPORTS
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/pet_card.dart';
import '../utils/app_colors.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('pets')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        // --- Estado de carga ---
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // --- Error ---
        if (snapshot.hasError) {
          return const Center(child: Text('Error al cargar publicaciones'));
        }

        // --- Sin datos ---
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return ListView(
            children: [
              _buildSubHeader(),
              _buildSearchBar(),
              const Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 40),
                  child: Text(
                    'Aún no hay publicaciones 🐾',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          );
        }

        // --- Si hay datos ---
        final pets = snapshot.data!.docs;

        return ListView(
          children: [
            _buildSubHeader(),
            _buildSearchBar(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                '${pets.length} mascotas encontradas',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                  fontSize: 16,
                ),
              ),
            ),

            // --- Lista dinámica de mascotas ---
            ...pets.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              final timestamp = data['createdAt'];
              String timeAgo = '';

              if (timestamp != null) {
                final postDate = (timestamp as Timestamp).toDate();
                final diff = DateTime.now().difference(postDate);

                if (diff.inSeconds < 60) {
                  timeAgo = 'Hace unos segundos';
                } else if (diff.inMinutes < 60) {
                  timeAgo = 'Hace ${diff.inMinutes} min';
                } else if (diff.inHours < 24) {
                  timeAgo = 'Hace ${diff.inHours} h';
                } else if (diff.inDays < 7) {
                  timeAgo = 'Hace ${diff.inDays} días';
                } else {
                  final weeks = (diff.inDays / 7).floor();
                  timeAgo = 'Hace $weeks semana${weeks > 1 ? 's' : ''}';
                }
              }

              return PetCard(
                  name: data['name'] ?? 'Sin nombre',
                  species: data['species'] ?? 'Desconocido',
                  breed: data['breed'] ?? 'Sin raza',
                  gender: data['gender'] ?? 'No especificado',
                  age: data['age'] ?? '',
                  location: data['location'] ?? '',
                  photoUrl: data['photoUrl'] ?? '',
                  userId: data['userId'] ?? '',
                  userName: data['userName'] ?? 'Usuario desconocido',
                  userPhoto: data['userPhoto'] ?? '',
                  timeAgo: timeAgo,
                  autoDescription: data['autoDescription'] ?? '',
                  exifValid: data['exifValid'],
                );
                }).toList(),
          ],
        );
      },
    );
  }


  // --- Subheader ---
  Widget _buildSubHeader() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: AppColors.primary,
      width: double.infinity,
      child: const Text(
        'Encuentra a tu compañero perfecto',
        style: TextStyle(
          color: AppColors.textLight,
          fontSize: 16.0,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  // --- Barra de búsqueda ---
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar por nombre, raza o ubicación...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: AppColors.accent,
              ),
            ),
          ),
          const SizedBox(width: 10),
          IconButton(
            icon: const Icon(Icons.filter_list),
            style: IconButton.styleFrom(
              backgroundColor: AppColors.primary.withAlpha(50),
              foregroundColor: AppColors.primary,
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
