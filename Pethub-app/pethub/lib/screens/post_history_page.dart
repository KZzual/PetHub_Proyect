import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/app_colors.dart';
import 'pet_detail_page.dart';

class PostHistoryPage extends StatefulWidget {
  const PostHistoryPage({super.key});

  @override
  State<PostHistoryPage> createState() => _PostHistoryPageState();
}

class _PostHistoryPageState extends State<PostHistoryPage> {
  String? _selectedFilter;

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      return const Center(child: Text("Inicia sesión para ver tu historial"));
    }

    final postsStream = FirebaseFirestore.instance
        .collection('pets')
        .where('userId', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .snapshots();

    final recentStream = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('recent_views')
        .orderBy('viewedAt', descending: true)
        .limit(5)
        .snapshots();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text(
          "Historial",
          style: TextStyle(color: AppColors.textLight),
        ),
        iconTheme: const IconThemeData(color: AppColors.textLight),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list, color: AppColors.textLight),
            onSelected: (val) => setState(() => _selectedFilter = val),
            itemBuilder: (_) => const [
              PopupMenuItem(value: null, child: Text("Todos")),
              PopupMenuItem(
                value: "En búsqueda de hogar",
                child: Text("En búsqueda de hogar"),
              ),
              PopupMenuItem(value: "Adoptado", child: Text("Adoptado")),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Sección de vistas recientes
            StreamBuilder<QuerySnapshot>(
              stream: recentStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const SizedBox.shrink();
                }

                final recent = snapshot.data!.docs;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                      child: Text(
                        "Vistos recientemente",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 120,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: recent.length,
                        itemBuilder: (context, i) {
                          final data =
                              recent[i].data() as Map<String, dynamic>;
                          final petId = recent[i].id;
                          final photoUrl = data['photoUrl'] ?? '';
                          final name = data['name'] ?? 'Sin nombre';

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      PetDetailPage(docId: petId, petData: data),
                                ),
                              );
                            },
                            child: Container(
                              width: 100,
                              margin: const EdgeInsets.only(right: 10),
                              child: Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: photoUrl.isNotEmpty
                                        ? Image.network(photoUrl,
                                            width: 100,
                                            height: 80,
                                            fit: BoxFit.cover)
                                        : Container(
                                            width: 100,
                                            height: 80,
                                            color: AppColors.accent,
                                            child: const Icon(Icons.pets,
                                                color: AppColors.textDark),
                                          ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    name,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class HistoryPostCard extends StatelessWidget {
  final String title;
  final String statusText;
  final String dateText;
  final IconData statusIcon;
  final Color iconColor;
  final String photoUrl;
  final VoidCallback onTap;

  const HistoryPostCard({
    super.key,
    required this.title,
    required this.statusText,
    required this.dateText,
    required this.statusIcon,
    required this.iconColor,
    required this.photoUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.5,
      margin: const EdgeInsets.only(bottom: 14.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      color: AppColors.background,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: photoUrl.isNotEmpty
                    ? Image.network(
                        photoUrl,
                        width: 75,
                        height: 75,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        width: 75,
                        height: 75,
                        color: AppColors.accent,
                        child: const Icon(Icons.pets, color: AppColors.textDark),
                      ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(statusIcon, color: iconColor, size: 22),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            statusText,
                            style: const TextStyle(
                              fontSize: 15,
                              color: AppColors.textDark,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dateText,
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
