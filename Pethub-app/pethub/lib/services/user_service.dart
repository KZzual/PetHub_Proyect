import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class UserService {
  static final _firestore = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;

  // Crear documento del usuario al registrarse
  static Future<void> createUserProfile({
    required String name,
    required String email,
    required String phone,
  }) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    // Obtener token FCM del dispositivo
    final fcmToken = await FirebaseMessaging.instance.getToken();

    final doc = _firestore.collection('users').doc(uid);

    await doc.set({
      'name': name,
      'email': email,
      'phone': phone,
      'createdAt': FieldValue.serverTimestamp(),
      'photoUrl': '',
      'role': 'adoptante',
      'fcmToken': fcmToken ?? '',
    }, SetOptions(merge: true));
  }


  // Escuchar perfil del usuario en tiempo real
  static Stream<Map<String, dynamic>?> streamUserProfile() {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return const Stream.empty();

    return _firestore
        .collection('users')
        .doc(uid)
        .snapshots()
        .map((doc) => doc.data());
  }


  // Obtener perfil actual del usuario
  static Future<Map<String, dynamic>?> getCurrentUserProfile() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return null;

    final doc = await _firestore.collection('users').doc(uid).get();
    return doc.data();
  }

  // Actualizar perfil del usuario
  // el token se actualiza si es necesario
  static Future<void> updateUserProfile({
    String? name,
    String? phone,
    String? comuna,
    String? description,
    String? photoUrl,
    bool updateFcmToken = false, //true si kieres actualizar el token
  }) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    final Map<String, dynamic> data = {};

    if (name != null) data['name'] = name;
    if (phone != null) data['phone'] = phone;
    if (comuna != null) data['comuna'] = comuna;
    if (description != null) data['description'] = description;
    if (photoUrl != null) data['photoUrl'] = photoUrl;

    // opcional: actualizar token FCM
    if (updateFcmToken) {
      final newToken = await FirebaseMessaging.instance.getToken();
      data['fcmToken'] = newToken;
    }

    if (data.isNotEmpty) {
      await _firestore.collection('users').doc(uid).update(data);
    }
  }

  // Actualizar token manualmente si kieres
  static Future<void> refreshFcmToken() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    final newToken = await FirebaseMessaging.instance.getToken();
    if (newToken != null) {
      await _firestore.collection('users').doc(uid).update({
        'fcmToken': newToken,
      });
    }
  }
}
