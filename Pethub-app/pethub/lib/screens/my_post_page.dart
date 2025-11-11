import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/app_colors.dart';
import 'pet_detail_page.dart';

class MyPostsPage extends StatelessWidget {
  const MyPostsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mis publicaciones',
          style: TextStyle(color: AppColors.textLight),
        ),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: AppColors.textLight),
      ),
      backgroundColor: AppColors.background,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('pets')
            .where('userId', isEqualTo: uid)
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error al cargar tus publicaciones'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No tienes publicaciones aún 🐾',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            );
          }

          final posts = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final data = posts[index].data() as Map<String, dynamic>;
              final docId = posts[index].id;
              final photoUrl = (data['photoUrl'] ?? '') as String;
              final name = (data['name'] ?? 'Sin nombre') as String;
              final species = (data['species'] ?? '—') as String;
              final location = (data['location'] ?? '') as String;
              final status = (data['status'] ?? 'En búsqueda de hogar') as String;

              final statusColor = status == 'Adoptado'
                  ? Colors.green[700]
                  : Colors.teal[600]; // color del estado

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                color: AppColors.background,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: photoUrl.isNotEmpty
                        ? Image.network(
                            photoUrl,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                const Icon(Icons.image_not_supported_outlined,
                                    color: AppColors.textDark),
                          )
                        : const Icon(Icons.pets, color: AppColors.primary),
                  ),
                  title: Text(
                    name,
                    style: const TextStyle(
                      color: AppColors.textDark,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('$species · $location',
                          style: const TextStyle(color: Colors.grey)),
                      const SizedBox(height: 4),
                      Text(
                        'Estado: $status',
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  trailing: PopupMenuButton<String>(
                    tooltip: "Opciones",
                    onSelected: (value) async {
                      if (value == 'Eliminar') {
                        final ok = await showDialog<bool>(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text('Eliminar publicación'),
                            content: Text('¿Eliminar "$name"?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('Cancelar'),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.redAccent,
                                ),
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text('Eliminar'),
                              ),
                            ],
                          ),
                        );

                        if (ok == true) {
                          await FirebaseFirestore.instance
                              .collection('pets')
                              .doc(docId)
                              .delete();

                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              behavior: SnackBarBehavior.floating,
                              margin: const EdgeInsets.all(16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              backgroundColor: Colors.redAccent,
                              content: Text('Publicación "$name" eliminada'),
                            ));
                          }
                        }
                      } else {
                        await FirebaseFirestore.instance
                            .collection('pets')
                            .doc(docId)
                            .update({'status': value});

                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            behavior: SnackBarBehavior.floating,
                            margin: const EdgeInsets.all(16),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            content: Text('Estado actualizado a "$value"'),
                          ));
                        }
                      }
                    },
                    itemBuilder: (_) => const [
                      PopupMenuItem(
                        value: 'En búsqueda de hogar',
                        child: Text('Marcar como En búsqueda de hogar'),
                      ),
                      PopupMenuItem(
                        value: 'Adoptado',
                        child: Text('Marcar como Adoptado'),
                      ),
                      PopupMenuDivider(),
                      PopupMenuItem(
                        value: 'Eliminar',
                        child: Text(
                          'Eliminar publicación',
                          style: TextStyle(color: Colors.redAccent),
                        ),
                      ),
                    ],
                    icon: const Icon(Icons.more_vert, color: Colors.grey),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            PetDetailPage(docId: docId, petData: data),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
