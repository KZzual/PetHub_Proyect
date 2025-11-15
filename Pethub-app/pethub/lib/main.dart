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

// 1. GOOGLE FONTS
import 'package:google_fonts/google_fonts.dart';

// Firebase Messaging + Local Notifications
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

/// Necesario para mensajes en background
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint("🔔 Mensaje en BACKGROUND: ${message.data}");
}

final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Registrar handler global background
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Inicializar canal de notificaciones locales
  const AndroidInitializationSettings initSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initSettings =
      InitializationSettings(android: initSettingsAndroid);

  await _flutterLocalNotificationsPlugin.initialize(
    initSettings,
    onDidReceiveNotificationResponse: (response) {
      final payload = response.payload;
      if (payload != null) {
        final data = Uri.splitQueryString(payload);
        _MyAppState._handleNotificationNavigation(data);
      }
    },
  );

  // Crear canal de notificación
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel',
    'Notificaciones Importantes',
    importance: Importance.high,
  );

  await _flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  // Permiso para notificaciones (Android 13+)
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  await messaging.requestPermission();

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

    //Guardar token FCM al iniciar la app
    _saveTokenToFirestore();

    //Listener de mensajes en FOREGROUND
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notification = message.notification;
      if (notification != null) {
        _flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'high_importance_channel',
              'Notificaciones Importantes',
              importance: Importance.high,
            ),
          ),
          payload: "chatId=${message.data['chatId']}&senderId=${message.data['senderId']}",
        );
      }
    });

    //App abierta por tocar notificación
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleNotificationNavigation(message.data);
    });
  }

  /// Guardar token FCM en Firestore
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

  /// ABRIR CHAT CUANDO SE TOCA LA NOTIFICACIÓN
  static Future<void> _handleNotificationNavigation(
      Map<String, dynamic> data) async {

    final chatId = data['chatId'];
    final senderId = data['senderId']; 

    if (chatId == null || senderId == null) return;

    // 1. Obtener info del chat
    final chatSnap = await FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .get();

    if (!chatSnap.exists) return;

    final chatData = chatSnap.data()!;
    final participants = chatData['participants'] as Map<String, dynamic>;

    final otherUser = participants[senderId];

    if (otherUser == null) return;

    final otherUserName = otherUser['name'] ?? "Usuario";
    final otherUserPhoto = otherUser['photoUrl'] ?? "";

    // 2. Ir al chat correcto desde cualquier parte de la app
    navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (_) => ChatPage(
          chatId: chatId,
          otherUserId: senderId,
          otherUserName: otherUserName,
          otherUserPhoto: otherUserPhoto,
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      title: 'PetHub',

      theme: ThemeData(
        useMaterial3: true,
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
        textTheme: GoogleFonts.latoTextTheme(textTheme).apply(
          bodyColor: AppColors.textDark,
          displayColor: AppColors.textDark,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textLight,
          elevation: 0,
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: AppColors.primary),
        ),
      ),

      home: const _DeciderPage(),

      onGenerateRoute: (settings) {
        if (settings.name == '/chat') {
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
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const SizedBox.shrink();
        }
        if (user == null) return const LoginPage();
        if (!user.emailVerified) return const VerifyEmailPage();
        if (snapshot.data == true) return const MainShell();

        return const LoginPage();
      },
    );
  }

  Future<bool> _checkRememberMe(User? user) async {
    if (user == null) return false;

    final prefs = await SharedPreferences.getInstance();
    final rememberMe = prefs.getBool('remember_me') ?? true;

    if (!rememberMe) {
      await FirebaseAuth.instance.signOut();
      return false;
    }
    return true;
  }
}
