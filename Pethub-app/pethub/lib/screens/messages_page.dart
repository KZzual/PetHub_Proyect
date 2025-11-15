import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/app_colors.dart';
import '../services/chat_service.dart';

class MessagesPage extends StatelessWidget {
  const MessagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return const Center(child: Text("Inicia sesión para ver tus mensajes"));
    }

    final chatStream = FirebaseFirestore.instance
        .collection('chats')
        .where('users', arrayContains: currentUser.uid)
        .orderBy('lastTimestamp', descending: true)
        .snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: chatStream,
      builder: (context, snapshot) {
        // Cargando
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // Error índice o Firestore
        if (snapshot.hasError) {
          String errorMsg = "Error al cargar los mensajes";
          if (snapshot.error.toString().contains("FAILED_PRECONDITION")) {
            errorMsg =
                "Falta un índice en Firestore para esta consulta.\n\nCrea uno para:\nusers (array-contains) + lastTimestamp (desc).";
          }
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(errorMsg,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey)),
            ),
          );
        }

        // Sin chats
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text(
              'Aún no tienes conversaciones 🐾',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          );
        }

        final chats = snapshot.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.all(8.0),
          itemCount: chats.length,
          itemBuilder: (context, index) {
            final chatData = chats[index].data() as Map<String, dynamic>;

            final participants =
                Map<String, dynamic>.from(chatData['participants'] ?? {});

            final otherUserId = participants.keys.firstWhere(
              (id) => id != currentUser.uid,
              orElse: () => '',
            );

            if (otherUserId.isEmpty) return const SizedBox.shrink();

            final other = participants[otherUserId] ?? {};
            final userName = other['name'] ?? 'Usuario';
            final avatarUrl = (other['photoUrl'] ?? '').toString();
            final lastMessage = chatData['lastMessage'] ?? '';
            final lastTimestamp = chatData['lastTimestamp'];

            final formattedTime = (lastTimestamp is Timestamp)
                ? _formatTime(lastTimestamp.toDate())
                : '';

            final unreadCount = chatData['unreadCount'] ?? 0;

            return _MessageListItem(
              userName: userName,
              lastMessage:
                  lastMessage.isNotEmpty ? lastMessage : "Sin mensajes aún",
              time: formattedTime,
              unreadCount: unreadCount,
              avatarUrl: avatarUrl,
              onTap: () async {
                final chatId = chats[index].id;

                // Resetear mensajes no leídos inmediatamente
                ChatService.markMessagesAsSeen(chatId);

                // Navegar al chat
                Navigator.pushNamed(
                  context,
                  '/chat',
                  arguments: {
                    'chatId': chatId,
                    'otherUserId': otherUserId,
                    'otherUserName': userName,
                    'otherUserPhoto': avatarUrl,
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  //Formato de hora
  static String _formatTime(DateTime time) {
    final h = time.hour.toString().padLeft(2, '0');
    final m = time.minute.toString().padLeft(2, '0');
    return "$h:$m";
  }
}

// --- Item de la lista ---
class _MessageListItem extends StatelessWidget {
  final String userName;
  final String lastMessage;
  final String time;
  final int unreadCount;
  final String avatarUrl;
  final VoidCallback onTap;

  const _MessageListItem({
    required this.userName,
    required this.lastMessage,
    required this.time,
    required this.unreadCount,
    required this.avatarUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      color: AppColors.background,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          radius: 25,
          backgroundColor: AppColors.accent,
          backgroundImage:
              avatarUrl.isNotEmpty ? NetworkImage(avatarUrl) : null,
          child: avatarUrl.isEmpty
              ? const Icon(Icons.person, color: Colors.white)
              : null,
        ),
        title: Text(
          userName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        subtitle: Text(
          lastMessage,
          style: const TextStyle(color: Colors.grey),
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (time.isNotEmpty)
              Text(
                time,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            const SizedBox(height: 4),
            if (unreadCount > 0)
              _UnreadBadge(count: unreadCount)
            else
              const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _UnreadBadge extends StatelessWidget {
  final int count;
  const _UnreadBadge({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          count.toString(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
