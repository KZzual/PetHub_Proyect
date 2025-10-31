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
    String? name,
    String? phone,
    String? comuna,
    String? description,
    String? photoUrl,
  }) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    final Map<String, dynamic> data = {};

    if (name != null) data['name'] = name;
    if (phone != null) data['phone'] = phone;
    if (comuna != null) data['comuna'] = comuna;
    if (description != null) data['description'] = description;
    if (photoUrl != null) data['photoUrl'] = photoUrl;

    if (data.isNotEmpty) {
      await _firestore.collection('users').doc(uid).update(data);
    }
  }

}
