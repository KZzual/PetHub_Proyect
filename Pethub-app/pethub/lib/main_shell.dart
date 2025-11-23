import 'package:flutter/material.dart';
// 1. IMPORTAMOS GOOGLE FONTS
import 'package:google_fonts/google_fonts.dart';
import 'screens/home_page.dart';
import 'screens/create_post_page.dart';
import 'screens/post_history_page.dart';
import 'screens/profile_page.dart';
import 'screens/messages_page.dart';
import 'screens/notifications_page.dart';
import 'utils/app_colors.dart';
import 'services/notification_service.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 0;

  static const List<String> _pageTitles = [
    'PetHub',
    'Historial de Posts',
    'Publicar',
    'Notificaciones',
    'Mensajes'
  ];

  static final List<Widget> _stackPages = <Widget>[
    const HomePage(),
    const PostHistoryPage(),
    const SizedBox.shrink(),
    const NotificationsPage(),
    const MessagesPage(),
  ];

  void _onItemTapped(int index) {
    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CreatePostPage()),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.pets, color: AppColors.textLight),
        title: Text(
          _pageTitles[_selectedIndex],
          style: GoogleFonts.getFont(
            'Pacifico',
            textStyle: const TextStyle(
              color: AppColors.textLight,
              fontSize: 22,
            ),
          ),
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline, color: AppColors.textLight),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            },
          ),
        ],
      ),

      // IndexedStack mantiene estado al cambiar tabs
      body: IndexedStack(
        index: _selectedIndex,
        children: _stackPages,
      ),

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.background,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),

          const BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Historial',
          ),

          const BottomNavigationBarItem(
            icon: Icon(Icons.add_circle, size: 35.0),
            label: 'Publicar',
          ),

          BottomNavigationBarItem(
            icon: StreamBuilder<int>(
              stream: NotificationService.pendingStatusChangeNotifications,
              builder: (context, snapshot) {
                final count = snapshot.data ?? 0;

                if (count == 0) {
                  return const Icon(Icons.notifications);
                }

                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Icon(Icons.notifications),

                    Positioned(
                      right: -6,
                      top: -6,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '$count',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            label: 'Notificaciones',
          ),

          const BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Mensajes',
          ),
        ],
      ),
    );
  }
}
