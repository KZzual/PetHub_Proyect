import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/app_colors.dart';
import '../services/user_service.dart';
import 'package:flutter/services.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? _selectedComuna;
  String? _photoUrl;
  bool _loadingData = true;
  bool _saving = false;
  bool _savedSuccess = false;
  final ImagePicker _picker = ImagePicker();

  final List<String> _comunas = [
    'San Joaquín',
    'La Florida',
    'Macul',
    'Ñuñoa',
    'Santiago Centro',
    'Providencia',
    'La Cisterna',
    'Maipú',
    'Puente Alto',
    'San Miguel'
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final data = await UserService.getCurrentUserProfile();
    if (data != null) {
      _nameController.text = data['name'] ?? '';
      _phoneController.text = data['phone']?.replaceFirst('+569', '') ?? '';
      _descriptionController.text = data['description'] ?? '';
      _selectedComuna = data['comuna'];
      _photoUrl = data['photoUrl'];
    }
    if (mounted) setState(() => _loadingData = false);
  }

  Future<void> _pickAndUploadPhoto() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image == null) return;

    setState(() => _saving = true);

    try {
      final storageRef =
          FirebaseStorage.instance.ref().child('profile_photos/${user.uid}.jpg');
      await storageRef.putFile(File(image.path));
      final url = await storageRef.getDownloadURL();

      await UserService.updateUserProfile(photoUrl: url);

      setState(() {
        _photoUrl = url;
        _savedSuccess = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), 
          shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0), 
            ),
          content: Text('Foto de perfil actualizada ✅')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), 
            shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0), 
            ),
        content: Text('Error al subir la foto: $e')));
    } finally {
      setState(() => _saving = false);
    }
  }

  Future<void> _saveChanges() async {
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final description = _descriptionController.text.trim();

    if (name.isEmpty || phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), 
          shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0), 
            ),
        content: Text('Nombre y teléfono son obligatorios')),
      );
      return;
    }

    if (phone.length != 9 || int.tryParse(phone) == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), 
          shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0), 
            ),
          content: Text('Número inválido.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() => _saving = true);

    await UserService.updateUserProfile(
      name: name,
      phone: '+569$phone',
      comuna: _selectedComuna,
      description: description,
    );

    setState(() {
      _saving = false;
      _savedSuccess = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), 
          shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0), 
            ),
      content: Text('Perfil Actualizado ✅')),
    );

    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) Navigator.pop(context, true);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loadingData) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

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
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              transitionBuilder: (child, anim) => ScaleTransition(
                scale: anim,
                child: FadeTransition(opacity: anim, child: child),
              ),
              child: _saving
                  ? const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  : _savedSuccess
                      ? const Icon(Icons.check_circle, color: AppColors.primary)
                      : TextButton(
                          onPressed: _saveChanges,
                          child: const Text(
                            'Guardar',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 55,
                    backgroundColor: AppColors.primary.withOpacity(0.2),
                    backgroundImage:
                        _photoUrl != null ? NetworkImage(_photoUrl!) : null,
                    child: _photoUrl == null
                        ? const Icon(Icons.person, color: AppColors.textDark, size: 60)
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: AppColors.primary,
                      child: IconButton(
                        icon: const Icon(Icons.edit_outlined,
                            color: AppColors.textLight, size: 18),
                        onPressed: _pickAndUploadPhoto,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Nombre
            _buildLabeledField(
              label: 'Nombre Completo',
              hint: 'Tu nombre completo',
              icon: Icons.person_outline,
              controller: _nameController,
            ),
            const SizedBox(height: 16),

            // Teléfono
            _buildPhoneField(),
            const SizedBox(height: 16),

            // Comuna
            _buildDropdownLabeled(
              label: 'Comuna',
              icon: Icons.location_on_outlined,
            ),
            const SizedBox(height: 16),

            // Descripción
            _buildLabeledField(
              label: 'Descripción (opcional)',
              hint: 'Escribe algo sobre ti...',
              icon: Icons.description_outlined,
              controller: _descriptionController,
            ),
          ],
        ),
      ),
    );
  }

  // ---------- Campo con Label superior ----------
  Widget _buildLabeledField({
    required String label,
    required String hint,
    required IconData icon,
    TextEditingController? controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 6),
          child: Text(
            label,
            style: const TextStyle(
                fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.07),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            style: const TextStyle(color: AppColors.textDark),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Color(0xFF777777)),
              prefixIcon: Icon(icon, color: AppColors.textDark),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: const BorderSide(color: Color(0xFFDDDDDD)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: const BorderSide(color: Color(0xFFDDDDDD)),
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
                borderSide: BorderSide(color: AppColors.primary, width: 1.5),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ---------- Campo teléfono con prefijo ----------
  Widget _buildPhoneField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 6),
          child: Text(
            'Teléfono',
            style: TextStyle(
                fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.07),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: TextField(
            controller: _phoneController,
            keyboardType: TextInputType.number,
            inputFormatters: [
            FilteringTextInputFormatter.digitsOnly, // solo números
            LengthLimitingTextInputFormatter(9),    // máximo 8 dígitos
            ],
            style: const TextStyle(color: AppColors.textDark),
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.phone_outlined, color: AppColors.textDark),
              prefixText: '+569 ',
              hintText: 'Teléfono',
              hintStyle: TextStyle(color: Color(0xFF777777)),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
                borderSide: BorderSide(color: Color(0xFFDDDDDD)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
                borderSide: BorderSide(color: Color(0xFFDDDDDD)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
                borderSide: BorderSide(color: AppColors.primary, width: 1.5),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ---------- Dropdown con Label superior ----------
  Widget _buildDropdownLabeled({
    required String label,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 6),
          child: Text(
            label,
            style: const TextStyle(
                fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.07),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: DropdownButtonFormField<String>(
            initialValue: _selectedComuna,
            dropdownColor: Colors.white,
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: AppColors.textDark),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: const BorderSide(color: Color(0xFFDDDDDD)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: const BorderSide(color: Color(0xFFDDDDDD)),
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
                borderSide: BorderSide(color: AppColors.primary, width: 1.5),
              ),
            ),
            items: _comunas
                .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                .toList(),
            onChanged: (value) => setState(() => _selectedComuna = value),
          ),
        ),
      ],
    );
  }
}
