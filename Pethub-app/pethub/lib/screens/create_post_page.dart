import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/app_colors.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final _nameCtrl = TextEditingController();
  final _breedCtrl = TextEditingController();
  final _ageCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  String? _selectedSpecies;
  final List<bool> _genderSelection = [false, false]; // Macho / Hembra
  bool _loading = false;

  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Publicación',
            style: TextStyle(color: AppColors.textLight)),
        iconTheme: const IconThemeData(color: AppColors.textLight),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- FOTO ---
            const Text(
              'Añadir foto',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(color: Colors.grey[300]!),
                  image: _selectedImage != null
                      ? DecorationImage(
                          image: FileImage(_selectedImage!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: _selectedImage == null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_a_photo_outlined,
                              color: Colors.grey[600], size: 40),
                          const SizedBox(height: 8),
                          Text('Toca para subir foto',
                              style: TextStyle(color: Colors.grey[700])),
                        ],
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              'Detalles de la mascota',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark),
            ),
            const SizedBox(height: 16),

            _buildTextField(_nameCtrl, 'Nombre', Icons.pets_outlined),
            const SizedBox(height: 16),

            _buildDropdown(),
            const SizedBox(height: 16),

            _buildTextField(_breedCtrl, 'Raza', Icons.label_outline),
            const SizedBox(height: 16),

            _buildGenderToggle(),
            const SizedBox(height: 16),

            _buildTextField(_ageCtrl, 'Edad (ej. 6 meses)',
                Icons.calendar_today_outlined),
            const SizedBox(height: 16),

            _buildTextField(
                _locationCtrl, 'Ubicación', Icons.location_on_outlined),
            const SizedBox(height: 32),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.textLight,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              onPressed: _loading ? null : _publishPost,
              child: _loading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('PUBLICAR'),
            ),
          ],
        ),
      ),
    );
  }

  // --- Subir foto ---
  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (picked != null) {
      setState(() => _selectedImage = File(picked.path));
    }
  }

  // --- Publicar post ---
  Future<void> _publishPost() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    if (_nameCtrl.text.isEmpty ||
        _selectedSpecies == null ||
        _breedCtrl.text.isEmpty ||
        _ageCtrl.text.isEmpty ||
        _locationCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor completa todos los campos')),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      // 1. Subir foto al Storage
      String? photoUrl;
      if (_selectedImage != null) {
        final ref = FirebaseStorage.instance
            .ref()
            .child('pet_photos/${user.uid}_${DateTime.now().millisecondsSinceEpoch}.jpg');
        await ref.putFile(_selectedImage!);
        photoUrl = await ref.getDownloadURL();
      }

      // 2. Subir datos a Firestore
      await FirebaseFirestore.instance.collection('pets').add({
        'userId': user.uid,
        'name': _nameCtrl.text.trim(),
        'species': _selectedSpecies,
        'breed': _breedCtrl.text.trim(),
        'gender': _genderSelection[0] ? 'Macho' : 'Hembra',
        'age': _ageCtrl.text.trim(),
        'location': _locationCtrl.text.trim(),
        'photoUrl': photoUrl ?? '',
        'createdAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Publicación creada exitosamente')),
      );

      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al publicar: $e')),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  // --- Helpers visuales ---
  Widget _buildTextField(TextEditingController ctrl, String hint, IconData icon) {
    return TextField(
      controller: ctrl,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.grey[600]),
        filled: true,
        fillColor: AppColors.accent,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedSpecies,
          isExpanded: true,
          hint: Row(
            children: [
              Icon(Icons.category_outlined, color: Colors.grey[600]),
              const SizedBox(width: 12),
              Text('Especie', style: TextStyle(color: Colors.grey[700])),
            ],
          ),
          icon: const Icon(Icons.arrow_drop_down),
          onChanged: (String? value) => setState(() => _selectedSpecies = value),
          items: ['Perro', 'Gato', 'Otro']
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
        ),
      ),
    );
  }

  Widget _buildGenderToggle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Género',
            style: TextStyle(color: AppColors.textDark, fontSize: 16)),
        const SizedBox(height: 8),
        ToggleButtons(
          isSelected: _genderSelection,
          onPressed: (int index) {
            setState(() {
              for (int i = 0; i < _genderSelection.length; i++) {
                _genderSelection[i] = (i == index);
              }
            });
          },
          borderRadius: BorderRadius.circular(12.0),
          selectedColor: AppColors.textLight,
          color: AppColors.primary,
          fillColor: AppColors.primary,
          borderColor: AppColors.primary,
          selectedBorderColor: AppColors.primary,
          constraints: BoxConstraints(
            minHeight: 45.0,
            minWidth: (MediaQuery.of(context).size.width - 52) / 2,
          ),
          children: const [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Icon(Icons.male), SizedBox(width: 8), Text('Macho')],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Icon(Icons.female), SizedBox(width: 8), Text('Hembra')],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
