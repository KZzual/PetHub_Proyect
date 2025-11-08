import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  static final _firestore = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;

  /// 🔹 Crea o recupera un chat entre el usuario actual y otro usuario
  static Future<String> createOrGetChat({
    required String otherUserId,
    required String otherUserName,
    required String otherUserPhoto,
  }) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) throw Exception("Usuario no autenticado");

    final currentUserId = currentUser.uid;

    // Buscar chat existente
    final chatQuery = await _firestore
        .collection('chats')
        .where('users', arrayContains: currentUserId)
        .get();

    for (var doc in chatQuery.docs) {
      final data = doc.data();
      if (data['users'] != null &&
          (data['users'] as List).contains(otherUserId)) {
        return doc.id;
      }
    }

    // Crear nuevo chat
    final chatRef = _firestore.collection('chats').doc();
    await chatRef.set({
      'users': [currentUserId, otherUserId],
      'participants': {
        currentUserId: {
          'name': currentUser.displayName ?? 'Usuario',
          'photoUrl': currentUser.photoURL ?? '',
        },
        otherUserId: {
          'name': otherUserName,
          'photoUrl': otherUserPhoto,
        }
      },
      'lastMessage': '',
      'lastTimestamp': FieldValue.serverTimestamp(),
      'unreadCount': 0,
    });

    return chatRef.id;
  }

  /// 🔹 Enviar mensaje
  static Future<void> sendMessage({
    required String chatId,
    required String text,
  }) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return;

    final msgRef = _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc();

    await msgRef.set({
      'senderId': currentUser.uid,
      'text': text.trim(),
      'timestamp': FieldValue.serverTimestamp(),
      'seen': false,
    });

    // Actualizar chat principal
    await _firestore.collection('chats').doc(chatId).update({
      'lastMessage': text,
      'lastTimestamp': FieldValue.serverTimestamp(),
    });
  }

  /// 🔹 Stream de mensajes (en vivo)
  static Stream<QuerySnapshot> streamMessages(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}
