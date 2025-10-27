import 'package:flutter/material.dart';
import 'screens/home_page.dart';
import 'screens/create_post_page.dart';
import 'screens/post_history_page.dart';
import 'screens/profile_page.dart';
import 'screens/messages_page.dart';
// 1. IMPORTAMOS LA ÚLTIMA PÁGINA: NOTIFICACIONES
import 'screens/notifications_page.dart'; 
import 'utils/app_colors.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 0;

  // Títulos para la barra superior
  static const List<String> _pageTitles = [
    'PetHub - Inicio',
    'Historial de Posts',
    'Publicar', // No se usa, ya que 'Publicar' es un modal
    'Notificaciones', // Título actualizado
    'Mensajes'
  ];

  // Páginas que se mostrarán en el cuerpo
  static final List<Widget> _stackPages = <Widget>[
    const HomePage(), 
    const PostHistoryPage(),
    const SizedBox.shrink(), // Placeholder para el índice 2 (Publicar)
    // 2. ¡CONECTAMOS LA PÁGINA DE NOTIFICACIONES!
    const NotificationsPage(), // Reemplazamos el Placeholder
    const MessagesPage(), 
  ];

  void _onItemTapped(int index) {
    if (index == 2) { // Índice 2 es el botón '+'
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
          _pageTitles[_selectedIndex], // El título cambia con la pestaña
          style: const TextStyle(color: AppColors.textLight)
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

