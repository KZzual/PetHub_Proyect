import 'package:flutter/material.dart';
import 'screens/home_page.dart';
import 'screens/create_post_page.dart';
import 'utils/app_colors.dart'; // Para los colores

// Este widget es el "caparazón" (shell) que controla la navegación
// principal de la app (la barra inferior).

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 0; // Controla la pestaña activa

  // 1. Lista de TODAS las páginas principales
  static final List<Widget> _widgetOptions = <Widget>[
    const HomePage(),
    const PlaceholderPage(title: 'Historial'), // Página provisional
    const CreatePostPage(), // La que acabas de crear
    const PlaceholderPage(title: 'Notificaciones'), // Página provisional
    const PlaceholderPage(title: 'Mensajes'), // Página provisional
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 2. Usamos un IndexedStack
      // Esto mantiene el estado de todas las páginas (como el scroll en Home)
      // cuando cambias de pestaña.
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),

      // 3. LA barra de navegación inferior UNIFICADA
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Historial',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle, size: 35.0),
            label: 'Publicar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notificaciones',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Mensajes',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed, // Para que todos los items sean visibles
        backgroundColor: AppColors.background,
      ),
    );
  }
}

// --- Widget Provisional para Páginas Faltantes ---
// Lo ponemos aquí mismo para no crear más archivos por ahora.
// Así la app puede compilar mientras creamos el resto de las páginas.
class PlaceholderPage extends StatelessWidget {
  final String title;
  const PlaceholderPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    // Cada página (incluyendo esta) tiene su propio Scaffold y AppBar
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.pets, color: AppColors.textLight),
        title: Text(title, style: const TextStyle(color: AppColors.textLight)),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline, color: AppColors.textLight),
            onPressed: () { /* Acción de Perfil */ },
          ),
        ],
        // El color del AppBar lo toma del Theme en main.dart (AppColors.primary)
      ),
      body: Center(
        child: Text(
          'Página de $title',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}
