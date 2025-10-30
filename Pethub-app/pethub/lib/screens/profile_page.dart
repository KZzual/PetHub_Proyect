// 1. IMPORTS
import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../widgets/pet_card.dart';
import 'edit_profile_page.dart';
import 'settings_page.dart';
import '../services/user_service.dart';

class ProfilePage extends StatefulWidget {
  final String? userId; // Opcional (si es perfil de otro usuario)

  const ProfilePage({super.key, this.userId});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isMyProfile = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _isMyProfile = (widget.userId == null);
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
        
        // ✅ Se reemplaza el título por un StreamBuilder para mostrar comuna debajo
        title: StreamBuilder<Map<String, dynamic>?>(
          stream: UserService.streamUserProfile(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Text("Cargando...", style: TextStyle(color: AppColors.textDark));
            }

            final user = snapshot.data!;
            final name = user['name'] ?? 'Sin nombre';
            final comuna = user['comuna'] ?? 'No especificada';

            return Row(
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.primary,
                  child: Icon(Icons.person, color: AppColors.textLight),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        color: AppColors.textDark,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      comuna,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),

        actions: [
          if (_isMyProfile)
            IconButton(
              icon: const Icon(Icons.more_horiz, color: AppColors.textDark),
              onPressed: () => _showSettingsMenu(context),
            )
          else
            IconButton(
              icon: const Icon(Icons.flag_outlined, color: AppColors.textDark),
              onPressed: () {},
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

      body: StreamBuilder<Map<String, dynamic>?>(
        stream: UserService.streamUserProfile(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final user = snapshot.data!;
          final name = user['name'] ?? 'Sin nombre';
          final phone = user['phone'] ?? 'Sin teléfono';
          final comuna = user['comuna'] ?? 'No especificada';
          final description = user['description'] ?? 'Sin descripción';

          return TabBarView(
            controller: _tabController,
            children: [
              _buildTodoTab(name, phone, comuna, description),
              _buildInfoTab(name, phone, comuna, description),
              _buildPublicationsTab(),
              _buildActivityTab(),
            ],
          );
        },
      ),
    );
  }

  // =============================
  //  MENÚ INFERIOR
  // =============================
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
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const EditProfilePage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings_outlined, color: AppColors.textDark),
              title: const Text('Configuración', style: TextStyle(color: AppColors.textDark)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const SettingsPage()));
              },
            ),
            const SizedBox(height: 20),
          ],
        );
      },
    );
  }

  // =============================
  //  TABS
  // =============================

  Widget _buildTodoTab(String name, String phone, String comuna, String desc) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildInfoCard(name, phone, comuna, desc),
        const SizedBox(height: 16),
        _buildPublicationsCard(),
      ],
    );
  }

  Widget _buildInfoTab(String name, String phone, String comuna, String desc) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildInfoCard(name, phone, comuna, desc),
      ],
    );
  }

  Widget _buildPublicationsTab() {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: const [
        PetCard(),
        SizedBox(height: 16),
        PetCard(),
      ],
    );
  }

  Widget _buildActivityTab() {
    return const Center(
      child: Text('La actividad del usuario aparecerá aquí.'),
    );
  }

  // =============================
  //  INFO CARD
  // =============================
  Widget _buildInfoCard(
      String name, String phone, String comuna, String desc) {
    return Card(
      elevation: 0,
      color: AppColors.background,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          _buildCardHeader('Información Personal', Icons.person, AppColors.secondary),
          _buildInfoRow(Icons.person_outline, 'Nombre Completo', name),
          _buildInfoRow(Icons.phone_outlined, 'Teléfono', phone),
          _buildInfoRow(Icons.location_on_outlined, 'Comuna', comuna),
          _buildInfoRow(Icons.description_outlined, 'Descripción', desc),
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
      child: const Padding(
        padding: EdgeInsets.all(8.0),
        child: PetCard(),
      ),
    );
  }

  // =============================
  //  UTILS
  // =============================
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
                fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title,
          style:
              const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textDark)),
      subtitle: Text(subtitle, style: const TextStyle(color: AppColors.textDark)),
    );
  }
}
