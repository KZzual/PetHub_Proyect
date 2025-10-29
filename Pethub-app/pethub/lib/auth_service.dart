import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Escucha cambios de sesión (logueado / deslogueado)
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Usuario actual
  User? get currentUser => _auth.currentUser;

  // LOGIN
  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    return await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );
  }

  // REGISTRO
  Future<UserCredential> signUp({
    required String email,
    required String password,
    String? displayName,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );

    if (displayName != null && displayName.isNotEmpty) {
      await cred.user?.updateDisplayName(displayName);
    }

    await sendEmailVerification();
    return cred;
  }

  // Verificación de correo
  Future<void> sendEmailVerification() async {
    final user = _auth.currentUser;
    if (user != null && !(user.emailVerified)) {
      await user.sendEmailVerification();
    }
  }

  // Refrescar datos
  Future<void> reloadUser() async {
    await _auth.currentUser?.reload();
  }

  // Saber si verificó el email
  Future<bool> isEmailVerified() async {
    await reloadUser();
    return _auth.currentUser?.emailVerified ?? false;
  }

  // Olvidé contraseña
  Future<void> sendPasswordReset({required String email}) async {
  await _auth.sendPasswordResetEmail(email: email.trim());
  }

  // Cerrar sesión
  Future<void> signOut() async {
    await _auth.signOut();
  }

}
