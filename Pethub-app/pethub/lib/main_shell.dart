import 'package:flutter/material.dart';
import 'screens/home_page.dart';
import 'screens/create_post_page.dart';
import 'screens/post_history_page.dart';
import 'screens/profile_page.dart'; // Importamos la página de perfil
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
    'Notificaciones',
    'Mensajes'
  ];

  // Páginas que se mostrarán en el cuerpo
  static const List<Widget> _stackPages = <Widget>[
    HomePage(), 
    PostHistoryPage(),
    SizedBox.shrink(), // Placeholder para el índice 2 (Publicar)
    PlaceholderPage(title: 'Notificaciones'), 
    PlaceholderPage(title: 'Mensajes'), 
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
    // 1. ESTE SCAFFOLD CONTROLA TODO
    return Scaffold(
      // 2. ¡AQUÍ ESTÁ LA BARRA SUPERIOR (APPBAR) QUE FALTABA!
      appBar: AppBar(
        leading: const Icon(Icons.pets, color: AppColors.textLight),
        title: Text(
          _pageTitles[_selectedIndex], // El título cambia con la pestaña
          style: const TextStyle(color: AppColors.textLight)
        ),
        elevation: 0,
        actions: [
          // Botón de Perfil que funciona en todas las pestañas
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
      // El cuerpo cambia según la pestaña seleccionada
      body: IndexedStack(
        index: _selectedIndex,
        children: _stackPages,
      ),
      // La barra de navegación inferior
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

// --- Widget Provisional (Simplificado) ---
// Este SÍ es correcto, SIN Scaffold y SIN AppBar,
// porque el MainShell ya los provee.
class PlaceholderPage extends StatelessWidget {
  final String title;
  const PlaceholderPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Página de $title',
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }
}

