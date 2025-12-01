import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/app_colors.dart';
import '../services/ai_service.dart';

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
  final _descCtrl = TextEditingController();

  String? _selectedSpecies;
  final List<bool> _genderSelection = [false, false];
  bool _loading = false;
  bool _analyzing = false;
  String? _detectedType;

  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Crear Publicación',
          style: TextStyle(color: AppColors.textLight),
        ),
        iconTheme: const IconThemeData(color: AppColors.textLight),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Añadir foto',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark),
            ),
            const SizedBox(height: 8),
            
            // Imagen + IA
            GestureDetector(
              onTap: _showImageSourceSelector,
              child: Container(
                height: 300,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(12),
                  image: _selectedImage != null
                      ? DecorationImage(
                          image: FileImage(_selectedImage!),
                          fit: BoxFit.contain,
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
                    : _analyzing
                        ? const Center(
                            child: CircularProgressIndicator(
                                color: AppColors.primary),
                          )
                        : null,
              ),
            ),
            const SizedBox(height: 24),

            if (_detectedType != null)
              AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOut,
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: _detectedType == 'Perro 🐶'
                      ? Colors.green.shade50
                      : Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _detectedType == 'Perro 🐶'
                        ? Colors.green.shade300
                        : Colors.blue.shade300,
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '🧠 Tipo detectado: $_detectedType',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (_descCtrl.text.isNotEmpty)
                      Text(
                        '💬 Descripción sugerida por IA:\n${_descCtrl.text}',
                        style: TextStyle(color: Colors.grey[800]),
                      ),
                  ],
                ),
              ),

            const Text(
              'Detalles de la mascota',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
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
            _buildTextField(
                _ageCtrl, 'Edad (ej. 6 meses)', Icons.calendar_today_outlined),
            const SizedBox(height: 16),
            _buildTextField(
                _locationCtrl, 'Ubicación', Icons.location_on_outlined),
            const SizedBox(height: 16),
            _buildTextField(
              _descCtrl,
              'Descripción (editable, sugerida por IA si disponible)',
              Icons.description_outlined,
              maxLines: 3,
            ),

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

  // Analizar imagen con IA
  void _showImageSourceSelector() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Tomar foto'),
            onTap: () {
              Navigator.pop(context);
              _pickImageAndAnalyze(ImageSource.camera);
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Elegir de galería'),
            onTap: () {
              Navigator.pop(context);
              _pickImageAndAnalyze(ImageSource.gallery);
            },
          ),
        ],
      ),
    );
  }

  // SELECCIÓN + IA
  Future<void> _pickImageAndAnalyze(ImageSource source) async {
    final picked =
        await _picker.pickImage(source: source, imageQuality: 80);
    if (picked == null) return;

    setState(() {
      _selectedImage = File(picked.path);
      _analyzing = true;
      _detectedType = null;
    });
    
     try {
      final analysis = await AiService.analyzePetImage(_selectedImage!);
      final lowerLabels = analysis.labels.map((e) => e.toLowerCase()).toList();

      String detectedType = '';
      if (lowerLabels.any((l) => l.contains('dog') || l.contains('puppy'))) {
        detectedType = 'Perro 🐶';
      } else if (lowerLabels.any((l) => l.contains('cat') || l.contains('kitten'))) {
        detectedType = 'Gato 🐱';
      }

      if (detectedType.isEmpty) {
        _selectedImage = null;
        _descCtrl.clear();

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            behavior: SnackBarBehavior.floating, 
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), 
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            backgroundColor: Colors.redAccent,
            content: const Text(
              'La imagen no parece ser un perro o gato.\nIntenta otra foto',
              style: TextStyle(color: Colors.white),
            ),
            duration: Duration(seconds: 3), // opcional: controla cuánto dura visible
          ),
        );

        setState(() => _analyzing = false);
        return;
      }

      //  Mostrar tipo y descripción sugerida
      setState(() {
        _detectedType = detectedType;
        _selectedSpecies =
            detectedType.contains('Perro') ? 'Perro' : 'Gato';
        _descCtrl.text = analysis.autoDescription.isNotEmpty
            ? analysis.autoDescription
            : 'Generando descripción...';
      });

      // Si la IA tarda, actualiza una vez más cuando llegue el texto real
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted && analysis.autoDescription.isNotEmpty) {
          setState(() => _descCtrl.text = analysis.autoDescription);
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), 
        shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0), 
        ),
        backgroundColor:
            detectedType == 'Perro 🐶' ? Colors.green[600] : Colors.blue[600],
        content: Text(
          '✅ Imagen detectada como $detectedType',
          style: const TextStyle(color: Colors.white),
        ),
      ));
    } catch (e) {
      _selectedImage = null;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al analizar imagen: $e')),
      );
    }
    setState(() => _analyzing = false);
    }

  // === Publicar ===
  Future<void> _publishPost() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    if (!_genderSelection.contains(true)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona el género')),
      );
      return;
    }

    if (_nameCtrl.text.isEmpty ||
        _selectedSpecies == null ||
        _breedCtrl.text.isEmpty ||
        _ageCtrl.text.isEmpty ||
        _locationCtrl.text.isEmpty ||
        _selectedImage == null ||
        _detectedType == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), 
        shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0), 
        ),
        content: Text('Por favor revisa todos los campos y la imagen'),
      ));
      return;
    }

    setState(() => _loading = true);

    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('pet_photos/${user.uid}_${DateTime.now().millisecondsSinceEpoch}.jpg');
      await ref.putFile(_selectedImage!);
      final photoUrl = await ref.getDownloadURL();

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      final userData = userDoc.data() ?? {};

      await FirebaseFirestore.instance.collection('pets').add({
        'userId': user.uid,
        'userName': userData['name'] ?? 'Usuario desconocido',
        'userPhoto': userData['photoUrl'] ?? '',
        'name': _nameCtrl.text.trim(),
        'species': _selectedSpecies,
        'breed': _breedCtrl.text.trim(),
        'gender': _genderSelection[0] ? 'Macho' : 'Hembra',
        'age': _ageCtrl.text.trim(),
        'location': _locationCtrl.text.trim(),
        'photoUrl': photoUrl,
        'description': _descCtrl.text.trim(),
        'detectedType': _detectedType,
        'createdAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), 
        shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0), 
        ),
        content: Text('Mascota publicada 🎉'),
      ));
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), 
        shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0), 
        ),
        content: Text('Error al publicar: $e')),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  // === Widgets auxiliares ===
  Widget _buildTextField(TextEditingController ctrl, String hint, IconData icon,
      {int maxLines = 1}) {
    return TextField(
      controller: ctrl,
      maxLines: maxLines,
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
          border: Border.all(
            color: _selectedSpecies == 'Perro'
                ? Colors.green.shade300
                : _selectedSpecies == 'Gato'
                    ? Colors.blue.shade300
                    : Colors.grey.shade300,
            width: 1,
          ),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: _selectedSpecies,
            isExpanded: true,
            hint: Row(
              children: [
                Icon(Icons.category_outlined, color: Colors.grey[600]),
                const SizedBox(width: 12),
                Text(
                  _selectedSpecies == null
                      ? 'Tipo'
                      : 'Tipo: $_selectedSpecies',
                  style: TextStyle(color: Colors.grey[700]),
                ),
              ],
            ),
            icon: const Icon(Icons.arrow_drop_down),
            onChanged: (String? value) {
              setState(() => _selectedSpecies = value);
            },
            items: ['Perro', 'Gato']
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
