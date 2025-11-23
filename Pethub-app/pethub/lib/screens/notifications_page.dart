import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/app_colors.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    return ListView(
      padding: const EdgeInsets.only(top: 8.0),
      children: [
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .collection('recent_views')
              .orderBy('viewedAt', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const SizedBox.shrink();

            final recent = snapshot.data!.docs;

            return Column(
              children: recent.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                final petId = doc.id;

                return FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('pets')
                      .doc(petId)
                      .get(),
                  builder: (context, petSnap) {
                    if (!petSnap.hasData || !petSnap.data!.exists) {
                      return const SizedBox.shrink();
                    }

                    final pet = petSnap.data!.data() as Map<String, dynamic>;

                    final currentStatus =
                        (pet['status'] ?? '').toString().trim();
                    final lastStatus =
                        (data['lastStatus'] ?? '').toString().trim();

                    // Sin cambios entonce no mostrar nada
                    if (currentStatus == lastStatus) return const SizedBox.shrink();

                    final petName = pet['name'] ?? 'Mascota';

                    // Mensaje según tipo de cambio
                    final statusMessage = currentStatus == "Adoptado"
                        ? '¡"$petName" ha sido adoptado!'
                        : '"$petName" vuelve a estar en adopción';

                    final (icon, iconColor) = currentStatus == "Adoptado"
                        ? (Icons.check_circle, Colors.green)
                        : (Icons.pets, AppColors.primary);

                    return _NotificationItem(
                      icon: icon,
                      iconColor: iconColor,
                      title: statusMessage,
                      subtitle: currentStatus == "Adoptado"
                          ? 'Marcado como adoptado.'
                          : 'Marcado como en búsqueda de hogar.',
                      time: 'Ahora',
                    );
                  },
                );
              }).toList(),
            );
          },
        ),

        const SizedBox(height: 18),
      ],
    );
  }
}


class _NotificationItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String time;

  const _NotificationItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(15),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: iconColor.withAlpha(26),
            radius: 20,
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: AppColors.textDark,
                    )),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),
          Text(time,
              style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }
}
