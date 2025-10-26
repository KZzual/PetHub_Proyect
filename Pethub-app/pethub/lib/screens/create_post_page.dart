import 'package:flutter/material.dart';
import '../utils/app_colors.dart'; // Importamos la paleta de colores

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  // --- Estado del formulario ---

  // Valor seleccionado en el Dropdown de Especie
  String? _selectedSpecies; // null al inicio

  // Lista de estados para el ToggleButton de Género [Macho, Hembra]
  // true = seleccionado, false = no seleccionado
  final List<bool> _genderSelection = [false, false];

  // --- Fin del Estado ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Publicación', style: TextStyle(color: AppColors.textLight)),
        // El color lo toma del Theme (AppColors.primary)
        iconTheme: const IconThemeData(color: AppColors.textLight), // Flecha de atrás blanca
      ),
      body: SingleChildScrollView(
        // Permite hacer scroll si el contenido no cabe
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Campo Subir Fotos ---
            const Text(
              'Añadir fotos',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark),
            ),
            const SizedBox(height: 8),
            Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_a_photo_outlined, color: Colors.grey[600], size: 40),
                    const SizedBox(height: 8),
                    Text('Toca para subir fotos', style: TextStyle(color: Colors.grey[700])),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // --- Formulario ---
            const Text(
              'Detalles de la mascota',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark),
            ),
            const SizedBox(height: 16),

            _buildTextField(hint: 'Nombre', icon: Icons.pets_outlined),
            const SizedBox(height: 16),

            // --- Dropdown Especie ---
            _buildDropdown(),
            const SizedBox(height: 16),

            _buildTextField(hint: 'Raza', icon: Icons.label_outline),
            const SizedBox(height: 16),

            // --- Toggle Género ---
            _buildGenderToggle(),
            const SizedBox(height: 16),

            _buildTextField(hint: 'Edad (ej. 6 meses)', icon: Icons.calendar_today_outlined),
            const SizedBox(height: 16),

            _buildTextField(hint: 'Ubicación (ej. Madrid, España)', icon: Icons.location_on_outlined),
            const SizedBox(height: 32),

            // --- Botón Publicar ---
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.textLight,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              onPressed: () {
                // Lógica para publicar
              },
              child: const Text('PUBLICAR'),
            ),
          ],
        ),
      ),
    );
  }

  // --- Widgets de Ayuda para construir el formulario ---

  // Widget genérico para los campos de texto
  Widget _buildTextField({required String hint, required IconData icon}) {
    return TextField(
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

  // Widget para el Dropdown de Especie
  Widget _buildDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
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
          onChanged: (String? newValue) {
            setState(() {
              _selectedSpecies = newValue;
            });
          },
          items: <String>['Perro', 'Gato', 'Otro']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }

  // Widget para los botones de Género
  Widget _buildGenderToggle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Género',
          style: TextStyle(color: Colors.grey[700], fontSize: 16),
        ),
        const SizedBox(height: 8),
        ToggleButtons(
          isSelected: _genderSelection,
          onPressed: (int index) {
            setState(() {
              // Lógica para selección única
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
            minWidth: (MediaQuery.of(context).size.width - 52) / 2, // Ancho dividido
          ),
          children: const [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.male),
                  SizedBox(width: 8),
                  Text('Macho'),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.female),
                  SizedBox(width: 8),
                  Text('Hembra'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

