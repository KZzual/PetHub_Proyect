import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../widgets/pet_card.dart'; 

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        leading: const BackButton(color: AppColors.textDark),
        backgroundColor: AppColors.background,
        elevation: 1,
        title: const Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: AppColors.primary,
              child: Icon(Icons.person, color: AppColors.textLight),
              // TODO: Añadir la imagen del usuario
              // backgroundImage: NetworkImage('url_de_la_foto'),
            ),
            SizedBox(width: 12),
            Text(
              'María González',
              style: TextStyle(
                color: AppColors.textDark, 
                fontWeight: FontWeight.bold
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz, color: AppColors.textDark),
            onPressed: () { /* Lógica para el menú '...' */ },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: const Color.fromARGB(255, 202, 201, 201),
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
        // 1. ¡AQUÍ ESTÁ LA CORRECCIÓN!
        backgroundColor: iconColor.withAlpha(26), // 26 es ~10% de opacidad
        child: Icon(icon, color: iconColor),
      ),
      title: Text(title, style: const TextStyle(color: AppColors.textDark)),
      subtitle: Text(subtitle, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w500)),
    );
  }
}

