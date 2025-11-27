import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  static final _firestore = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;

  // Crear o recuperar un chat entre 2 usuarios
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
        return doc.id; // chat ya existe
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

  // Enviar mensaje
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

    // Actualizar último mensaje en el chat
    await _firestore.collection('chats').doc(chatId).update({
      'lastMessage': text,
      'lastTimestamp': FieldValue.serverTimestamp(),
    });
  }

  // Stream en vivo de mensajes
  static Stream<QuerySnapshot> streamMessages(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  // Marcar mensajes como VISTOS
  static Future<void> markMessagesAsSeen(String chatId) async {
    final currentUserId = _auth.currentUser?.uid;
    if (currentUserId == null) return;

    final unread = await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .where('senderId', isNotEqualTo: currentUserId)
        .where('seen', isEqualTo: false)
        .get();

    for (var doc in unread.docs) {
      await doc.reference.update({'seen': true});
    }

    // Reiniciar contador de no leídos
    await _firestore.collection('chats').doc(chatId).update({
      'unreadCount': 0,
    });
  }
}
