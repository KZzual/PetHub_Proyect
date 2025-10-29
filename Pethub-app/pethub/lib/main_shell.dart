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

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 0;

  static const List<String> _pageTitles = [
    'PetHub', // Cambiado de "PetHub - Inicio" para que quede mejor con la fuente
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
        // 2. ¡AQUÍ ESTÁ LA CORRECCIÓN!
        title: Text(
          _pageTitles[_selectedIndex],
          // Usamos el método 'getFont' y pasamos 'Pacifico' como string
          style: GoogleFonts.getFont(
            'Pacifico',
            textStyle: const TextStyle(
              color: AppColors.textLight,
              fontSize: 22, // Ajustamos el tamaño para que se vea bien
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
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Historial'),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle, size: 35.0),
            label: 'Publicar',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Notificaciones'),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Mensajes'),
        ],
      ),
    );
  }
}

