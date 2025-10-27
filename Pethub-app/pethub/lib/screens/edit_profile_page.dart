import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  // TOdo: Cargar los datos actuales del usuario en estos controladores
  final _nameController = TextEditingController(text: 'María Alejandra González');
  final _locationController = TextEditingController(text: 'Santiago, Chile');
  final _descriptionController = TextEditingController(text: 'Amante de los animales...');

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.accent,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 1,
        leading: const BackButton(color: AppColors.textDark),
        title: const Text(
          'Editar Perfil',
          style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold),
        ),
        actions: [
          // Botón de Guardar
          TextButton(
            onPressed: () {
              // TOdo: Lógica para guardar los datos
              Navigator.pop(context); // Volver al perfil
            },
            child: const Text(
              'Guardar',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          // --- Sección de Foto de Perfil ---
          Center(
            child: Stack(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: AppColors.primary,
                  child: Icon(Icons.person, color: AppColors.textLight, size: 50),
                  // backgroundImage: NetworkImage('url_de_la_foto'),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: AppColors.secondary,
                    child: IconButton(
                      icon: const Icon(Icons.edit_outlined, color: AppColors.textLight, size: 18),
                      onPressed: () { /* Lógica para cambiar foto */ },
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // --- Campos del Formulario ---
          _buildTextField(
            controller: _nameController,
            label: 'Nombre Completo',
            icon: Icons.person_outline,
          ),
          const SizedBox(height: 16),
          // TOdo: Usar un DatePicker para este campo
          _buildTextField(
            controller: TextEditingController(text: '15 de Marzo, 1995'),
            label: 'Fecha de Nacimiento',
            icon: Icons.calendar_today_outlined,
            enabled: false, // Deshabilitado, se debe usar un DatePicker
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _locationController,
            label: 'Ubicación',
            icon: Icons.location_on_outlined,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _descriptionController,
            label: 'Descripción',
            icon: Icons.description_outlined,
            maxLines: 4,
          ),
        ],
      ),
    );
  }

  // Widget de ayuda para crear los campos de texto
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    bool enabled = true,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      enabled: enabled,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.textDark),
        filled: true,
        fillColor: AppColors.background, // Fondo blanco
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
        ),
        floatingLabelStyle: const TextStyle(color: AppColors.primary),
      ),
    );
  }
}
