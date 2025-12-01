import 'package:flutter/material.dart';
import 'package:provider/provider.dart';                 // CORRECTO
import 'providers/theme_provider.dart';                 // TU ARCHIVO

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

// Firebase Messaging + Local Notifications
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

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

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

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

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel',
    'Notificaciones Importantes',
    importance: Importance.high,
  );

  await _flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.requestPermission();

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
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

    FirebaseMessaging.onMessageOpenedApp.listen((msg) {
      _handleNotificationNavigation(msg.data);
    });
  }

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
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      title: "PetHub",

      theme: themeProvider.lightTheme,
      darkTheme: themeProvider.darkTheme,
      themeMode: themeProvider.themeMode,

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
