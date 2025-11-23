import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/app_colors.dart';

class PetDetailPage extends StatelessWidget {
  final String docId;
  final Map<String, dynamic> petData;

  const PetDetailPage({
    super.key,
    required this.docId,
    required this.petData,
  });

  // 🔥 Guardar la vista reciente del usuario actual
  Future<void> _registerRecentView() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final recentRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('recent_views')
          .doc(docId);

      await recentRef.set({
        'name': petData['name'] ?? 'Sin nombre',
        'photoUrl': petData['photoUrl'] ?? '',
        'species': petData['species'] ?? '',
        'status': petData['status'] ?? '',
        'lastStatus': petData['status'] ?? '',
        'viewedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint("❌ Error al registrar vista reciente: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Registra la visita en Firestore apenas se construye la pantalla
    _registerRecentView();

    final photoUrl = (petData['photoUrl'] ?? '') as String;
    final name = (petData['name'] ?? 'Sin nombre') as String;
    final species = (petData['species'] ?? 'Desconocido') as String;
    final breed = (petData['breed'] ?? 'Sin raza') as String;
    final gender = (petData['gender'] ?? 'No especificado') as String;
    final age = (petData['age'] ?? '') as String;
    final location = (petData['location'] ?? '') as String;
    final userName = (petData['userName'] ?? 'Usuario desconocido') as String;
    final userPhoto = (petData['userPhoto'] ?? '') as String;
    final userId = (petData['userId'] ?? '') as String;
    final description =
        (petData['description'] ?? petData['autoDescription'] ?? '') as String;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Detalle de publicación',
          style: TextStyle(color: AppColors.textLight),
        ),
        iconTheme: const IconThemeData(color: AppColors.textLight),
        backgroundColor: AppColors.primary,
      ),
      body: ListView(
        children: [
          if (photoUrl.isNotEmpty)
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(
                photoUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _imageFallback(),
              ),
            )
          else
            _imageFallback(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _pill(icon: Icons.pets, label: species),
                    if (breed.isNotEmpty)
                      _pill(icon: Icons.label_outline, label: breed),
                    if (gender.isNotEmpty)
                      _pill(
                        icon: gender == 'Macho' ? Icons.male : Icons.female,
                        label: gender,
                      ),
                    if (age.isNotEmpty)
                      _pill(icon: Icons.calendar_today, label: age),
                    if (location.isNotEmpty)
                      _pill(icon: Icons.location_on_outlined, label: location),
                  ],
                ),
                const SizedBox(height: 16),
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
                  description.isNotEmpty ? description : 'Sin descripción.',
                  style: TextStyle(
                    color: Colors.grey[800],
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 8),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: AppColors.accent,
                      backgroundImage:
                          userPhoto.isNotEmpty ? NetworkImage(userPhoto) : null,
                      child: userPhoto.isEmpty
                          ? const Icon(Icons.person, color: Colors.white)
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Publicado por',
                              style: TextStyle(color: Colors.grey)),
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
                    ElevatedButton.icon(
                      icon: const Icon(Icons.chat_bubble_outline),
                      label: const Text('Contactar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.textLight,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      onPressed: () async {
                        await _startChat(context, userId, userName, userPhoto);
                      },
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

  Future<void> _startChat(
    BuildContext context,
    String otherUserId,
    String otherUserName,
    String otherUserPhoto,
  ) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null || currentUser.uid == otherUserId) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('No puedes chatear contigo mismo'),
      ));
      return;
    }

    final chatQuery = await FirebaseFirestore.instance
        .collection('chats')
        .where('users', arrayContains: currentUser.uid)
        .get();

    String? existingChatId;

    for (var doc in chatQuery.docs) {
      final users = List<String>.from(doc['users']);
      if (users.contains(otherUserId)) {
        existingChatId = doc.id;
        break;
      }
    }

    String chatId;
    if (existingChatId != null) {
      chatId = existingChatId;
    } else {
      final newChat = await FirebaseFirestore.instance.collection('chats').add({
        'users': [currentUser.uid, otherUserId],
        'participants': {
          currentUser.uid: {
            'name': currentUser.displayName ?? 'Tú',
            'photoUrl': currentUser.photoURL ?? '',
          },
          otherUserId: {
            'name': otherUserName,
            'photoUrl': otherUserPhoto,
          },
        },
        'lastMessage': '',
        'lastTimestamp': FieldValue.serverTimestamp(),
      });
      chatId = newChat.id;
    }

    Navigator.pushNamed(
      context,
      '/chat',
      arguments: {
        'chatId': chatId,
        'otherUserId': otherUserId,
        'otherUserName': otherUserName,
        'otherUserPhoto': otherUserPhoto,
      },
    );
  }

  Widget _pill({required IconData icon, required String label}) {
    return Chip(
      avatar: Icon(icon, size: 18, color: AppColors.textDark),
      label: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: AppColors.textDark,
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
      child: const Text(
        'Sin imagen',
        style: TextStyle(color: AppColors.textDark),
      ),
    );
  }
}
