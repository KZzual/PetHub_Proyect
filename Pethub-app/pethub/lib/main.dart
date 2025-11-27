import 'package:flutter/material.dart';
import 'screens/login_page.dart';
import 'utils/app_colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'main_shell.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/verify_email_page.dart';
import 'screens/chat_page.dart';
import 'screens/pet_detail_page.dart';

// Google Fonts
import 'package:google_fonts/google_fonts.dart';

// Firebase Messaging + Local Notifications
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// Necesario para mensajes en background
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint("Mensaje en BACKGROUND: ${message.data}");
}

final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Handler global
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Inicializar notificaciones locales
  const initAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
  const initSettings = InitializationSettings(android: initAndroid);

  await _flutterLocalNotificationsPlugin.initialize(
    initSettings,
    onDidReceiveNotificationResponse: (response) {
      if (response.payload != null) {
        final data = Uri.splitQueryString(response.payload!);
        _MyAppState._handleNotificationNavigation(data);
      }
    },
  );

  // Canal
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel',
    'Notificaciones Importantes',
    importance: Importance.high,
  );

  await _flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  // Permiso en Android 13+
  await FirebaseMessaging.instance.requestPermission();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();

    _saveTokenToFirestore();

    // Mensaje en foreground
    FirebaseMessaging.onMessage.listen((msg) {
      final notif = msg.notification;
      if (notif != null) {
        _flutterLocalNotificationsPlugin.show(
          notif.hashCode,
          notif.title,
          notif.body,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'high_importance_channel',
              'Notificaciones Importantes',
              importance: Importance.high,
            ),
          ),
          payload:
              "chatId=${msg.data['chatId']}&senderId=${msg.data['senderId']}&petId=${msg.data['petId']}",
        );
      }
    });

    // App abierta desde una notificación
    FirebaseMessaging.onMessageOpenedApp.listen((msg) {
      _handleNotificationNavigation(msg.data);
    });
  }

  /// Guardar token de FCM
  Future<void> _saveTokenToFirestore() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'fcmToken': token,
      });
    }
  }

  static Future<void> _handleNotificationNavigation(
      Map<String, dynamic> data) async {

    final chatId = data['chatId'];
    final senderId = data['senderId'];
    final petId = data['petId'];

    // NOTIFICACIÓN DE CHAT
    if (chatId != null && senderId != null) {
      final chatSnap = await FirebaseFirestore.instance
          .collection('chats')
          .doc(chatId)
          .get();

      if (!chatSnap.exists) return;

      final chat = chatSnap.data()!;
      final participants = chat['participants'] as Map<String, dynamic>;

      final otherUser = participants[senderId];
      if (otherUser == null) return;

      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (_) => ChatPage(
            chatId: chatId,
            otherUserId: senderId,
            otherUserName: otherUser['name'] ?? "Usuario",
            otherUserPhoto: otherUser['photoUrl'] ?? "",
          ),
        ),
      );
      return;
    }

    // NOTIFICACIÓN DE MASCOTA (cambio de estado)
    if (petId != null) {
      final petSnap = await FirebaseFirestore.instance
          .collection('pets')
          .doc(petId)
          .get();

      if (!petSnap.exists) return;

      final petData = petSnap.data()!;

      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (_) => PetDetailPage(
            docId: petId,
            petData: petData,
          ),
        ),
      );
      return;
    }

    debugPrint("Notificación no identificada: $data");
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      title: "PetHub",

      theme: ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: Colors.white,
        textTheme: GoogleFonts.latoTextTheme(textTheme).apply(
          bodyColor: AppColors.textDark,
          displayColor: AppColors.textDark,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textLight,
        ),
      ),

      home: const _DeciderPage(),

      onGenerateRoute: (settings) {
        if (settings.name == "/chat") {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (_) => ChatPage(
              chatId: args['chatId'],
              otherUserId: args['otherUserId'],
              otherUserName: args['otherUserName'],
              otherUserPhoto: args['otherUserPhoto'],
            ),
          );
        }
        return null;
      },
    );
  }
}

class _DeciderPage extends StatelessWidget {
  const _DeciderPage();

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return FutureBuilder<bool>(
      future: _checkRememberMe(user),
      builder: (context, s) {
        if (!s.hasData) return const SizedBox.shrink();
        if (user == null) return const LoginPage();
        if (!user.emailVerified) return const VerifyEmailPage();
        if (s.data == true) return const MainShell();
        return const LoginPage();
      },
    );
  }

  Future<bool> _checkRememberMe(User? user) async {
    if (user == null) return false;

    final prefs = await SharedPreferences.getInstance();
    final rememberMe = prefs.getBool("remember_me") ?? true;

    if (!rememberMe) {
      await FirebaseAuth.instance.signOut();
      return false;
    }
    return true;
  }
}
