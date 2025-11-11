// 1. IMPORTS
import 'package:flutter/material.dart';
import 'package:pethub/screens/settings_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';
import '../auth_service.dart';
import '../utils/app_colors.dart';
import 'edit_profile_page.dart';
import 'my_post_page.dart';
import '../services/user_service.dart';

class ProfilePage extends StatefulWidget {
  final String? userId;

  const ProfilePage({super.key, this.userId});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isMyProfile = false;

  @override
  void initState() {
    super.initState();
    _isMyProfile = (widget.userId == null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.accent,
      appBar: AppBar(
        leading: const BackButton(color: AppColors.textDark),
        backgroundColor: AppColors.background,
        elevation: 1,
        title: StreamBuilder<Map<String, dynamic>?>(
          stream: UserService.streamUserProfile(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Text("Cargando...",
                  style: TextStyle(color: AppColors.textDark));
            }

            final user = snapshot.data!;
            final name = user['name'] ?? 'Sin nombre';
            final comuna = user['comuna'] ?? 'No especificada';
            final photoUrl = user['photoUrl'];

            return Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: AppColors.primary.withOpacity(0.2),
                  backgroundImage: photoUrl != null && photoUrl.isNotEmpty
                      ? NetworkImage(photoUrl)
                      : null,
                  child: photoUrl == null || photoUrl.isEmpty
                      ? const Icon(Icons.person, color: AppColors.textDark)
                      : null,
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
      ),

      // Contenido principal
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

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              _buildInfoCard(name, phone, comuna, description),
              const SizedBox(height: 24),

              // Lista de opciones
              _buildOptionTile(
                icon: Icons.edit,
                label: "Editar perfil",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const EditProfilePage()),
                  );
                },
              ),
              const SizedBox(height: 10),
              _buildOptionTile(
                icon: Icons.photo_library_outlined,
                label: "Mis publicaciones",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const MyPostsPage()),
                  );
                },
              ),
              const SizedBox(height: 10),
              _buildOptionTile(
                icon: Icons.settings,
                label: "Configuración",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SettingsPage()),
                  );
                },
              ),
              const SizedBox(height: 10),
              _buildOptionTile(
                icon: Icons.logout,
                label: "Cerrar sesión",
                iconColor: Colors.redAccent,
                textColor: Colors.redAccent,
                onTap: () async {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setBool('remember_me', false);

                  await AuthService.instance.signOut();

                  if (context.mounted) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                      (_) => false,
                    );
                  }
                },
              ),
              const SizedBox(height: 40),
            ],
          );
        },
      ),
    );
  }

  //  Tarjeta de perfil
  Widget _buildInfoCard(
      String name, String phone, String comuna, String desc) {
    return Card(
      elevation: 0,
      color: AppColors.background,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          _buildCardHeader(
              'Información Personal', Icons.person, AppColors.secondary),
          _buildInfoRow(Icons.person_outline, 'Nombre Completo', name),
          _buildInfoRow(Icons.phone_outlined, 'Teléfono', phone),
          _buildInfoRow(Icons.location_on_outlined, 'Comuna', comuna),
          _buildInfoRow(Icons.description_outlined, 'Descripción', desc),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

 
  //  OPCIONES EN LISTA
  Widget _buildOptionTile({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color iconColor = AppColors.primary,
    Color textColor = AppColors.textDark,
  }) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: iconColor),
        title: Text(
          label,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios,
            size: 16, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }

  //  Arreglos
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
      title: Text(
        title,
        style: const TextStyle(
            fontWeight: FontWeight.bold, color: AppColors.textDark),
      ),
      subtitle:
          Text(subtitle, style: const TextStyle(color: AppColors.textDark)),
    );
  }
}
