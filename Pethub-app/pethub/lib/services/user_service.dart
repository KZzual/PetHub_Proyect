import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  static final _firestore = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;

  /// Crear documento del usuario en Firestore (al registrarse)
  static Future<void> createUserProfile({
    required String name,
    required String email,
    required String phone,
  }) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    final doc = _firestore.collection('users').doc(uid);

    await doc.set({
      'name': name,
      'email': email,
      'phone': phone,
      'createdAt': FieldValue.serverTimestamp(),
      'photoUrl': '',
      'role': 'adoptante',
    }, SetOptions(merge: true));
  }

  /// Escuchar perfil en tiempo real
  static Stream<Map<String, dynamic>?> streamUserProfile() {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return const Stream.empty();

    return _firestore
        .collection('users')
        .doc(uid)
        .snapshots()
        .map((doc) => doc.data());
  }

  /// Traer datos del usuario actual desde Firestore
  static Future<Map<String, dynamic>?> getCurrentUserProfile() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return null;

    final doc = await _firestore.collection('users').doc(uid).get();
    return doc.data();
  }

  ///Actualizar perfil del usuario
  static Future<void> updateUserProfile({
    required String name,
    required String phone,
    required String? comuna,
    required String description,
  }) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    final doc = _firestore.collection('users').doc(uid);

    await doc.update({
      'name': name,
      'phone': phone,
      'comuna': comuna,
      'description': description,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}
