// 1. IMPORTS CORREGIDOS
import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../widgets/pet_card.dart';
import 'edit_profile_page.dart';
import 'settings_page.dart';

class ProfilePage extends StatefulWidget {
  // Parámetro opcional de userId
  final String? userId; 

  const ProfilePage({super.key, this.userId});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isMyProfile = false;
  String _userName = "Cargando...";

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    
    // Comprobamos qué perfil mostrar
    _isMyProfile = (widget.userId == null);

    // Cargamos los datos (Simulación)
    if (_isMyProfile) {
      _userName = "María González"; // Mis datos
    } else {
      _userName = "Perfil de Otro Usuario"; // Datos de otro
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.accent,
      appBar: AppBar(
        leading: const BackButton(color: AppColors.textDark),
        backgroundColor: AppColors.background,
        elevation: 1,
        title: Row(
          children: [
            const CircleAvatar(
              radius: 20,
              backgroundColor: AppColors.primary,
              child: Icon(Icons.person, color: AppColors.textLight),
            ),
            const SizedBox(width: 12),
            Text(
              _userName,
              style: const TextStyle(
                color: AppColors.textDark, 
                fontWeight: FontWeight.bold
              ),
            ),
          ],
        ),
        // Lógica de botones del AppBar
        actions: [
          if (_isMyProfile)
            // Si es MI perfil, muestro el menú de 3 puntos
            IconButton(
              icon: const Icon(Icons.more_horiz, color: AppColors.textDark),
              onPressed: () {
                // Llamamos al menú inferior
                _showSettingsMenu(context);
              },
            )
          else
            // Si es el perfil de OTRO, muestro el botón de Reportar
            IconButton(
              icon: const Icon(Icons.flag_outlined, color: AppColors.textDark),
              onPressed: () {
                // Lógica para reportar usuario
              },
            ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppColors.primary,
          isScrollable: true,
          tabs: const [
            Tab(text: 'TODO'),
            Tab(text: 'INFORMACIÓN'),
            Tab(text: 'PUBLICACIONES'),
            Tab(text: 'ACTIVIDAD'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTodoTab(),
          _buildInfoTab(),
          _buildPublicationsTab(),
          _buildActivityTab(),
        ],
      ),
    );
  }

  // Función para mostrar el menú (Bottom Sheet)
  void _showSettingsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.edit_outlined, color: AppColors.textDark),
              title: const Text('Editar Perfil', style: TextStyle(color: AppColors.textDark)),
              onTap: () {
                Navigator.pop(context); // Cierra el menú
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EditProfilePage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings_outlined, color: AppColors.textDark),
              title: const Text('Configuración', style: TextStyle(color: AppColors.textDark)),
              onTap: () {
                Navigator.pop(context); // Cierra el menú
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsPage()),
                );
              },
            ),
            const SizedBox(height: 20), // Espacio inferior
          ],
        );
      },
    );
  }

  
  // --- Widgets de Pestañas ---
  Widget _buildTodoTab() {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildInfoCard(),
        const SizedBox(height: 16),
        _buildPublicationsCard(),
      ],
    );
  }

  Widget _buildInfoTab() {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildInfoCard(),
      ],
    );
  }

  Widget _buildPublicationsTab() {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildPublicationsCard(),
      ],
    );
  }

  Widget _buildActivityTab() {
    if (!_isMyProfile) {
      return const Center(
        child: Text('La actividad de este usuario es privada.'),
      );
    }
    
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildActivityCard(),
      ],
    );
  }

  // --- Widgets de Tarjetas ---

  Widget _buildInfoCard() {
    return Card(
      elevation: 0,
      color: AppColors.background,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          _buildCardHeader('Información Personal', Icons.person, AppColors.secondary),
          _buildInfoRow(Icons.person_outline, 'Nombre Completo', 'María Alejandra González Rodríguez'),
          _buildInfoRow(Icons.calendar_today, 'Fecha de Nacimiento', '15 de Marzo, 1995'),
          _buildInfoRow(Icons.location_on_outlined, 'Ubicación', 'Santiago, Chile'),
          _buildInfoRow(Icons.description_outlined, 'Descripción', 'Amante de los animales...'),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildPublicationsCard() {
    return Card(
      elevation: 0,
      color: AppColors.background,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          _buildCardHeader('Publicaciones (2)', Icons.collections, AppColors.primary),
          const Padding(
            padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
            child: PetCard(),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
            child: PetCard(),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityCard() {
    return Card(
      elevation: 0,
      color: AppColors.background,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          _buildCardHeader('Actividad Reciente (3)', Icons.bar_chart, Colors.blueGrey),
          _buildActivityRow(Icons.favorite, Colors.red, 'Te gustó la publicación de "Cholito"', 'en: Cholito'),
          _buildActivityRow(Icons.chat_bubble, AppColors.primary, 'Comentaste en la publicación de "Bella"', 'en: Bella'),
          _buildActivityRow(Icons.add_circle, Colors.green, 'Publicaste a "Luna" en adopción', '2 días atrás'),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  // --- Widgets de Filas y Headers ---

  Widget _buildCardHeader(String title, IconData icon, Color color) {
    return Container(
      color: color,
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Icon(icon, color: AppColors.textLight),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textLight,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textDark)),
      subtitle: Text(subtitle, style: const TextStyle(color: AppColors.textDark)),
    );
  }

  Widget _buildActivityRow(IconData icon, Color iconColor, String title, String subtitle) {
    return ListTile(
      leading: CircleAvatar(
        // CORRECCIÓN de 'withOpacity' a 'withAlpha'
        backgroundColor: iconColor.withAlpha(26),
        child: Icon(icon, color: iconColor),
      ),
      title: Text(title, style: const TextStyle(color: AppColors.textDark)),
      subtitle: Text(subtitle, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w500)),
    );
  }
}

