import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class PetFilterModal extends StatefulWidget {
  // Estos valores nos llegan desde el Home para saber qué estaba marcado
  final String currentSpecies; // 'Todos', 'Perro', 'Gato'
  final String currentGender;  // 'Todos', 'Macho', 'Hembra'
  
  // Esta función servirá para devolverle los datos al Home
  final Function(String species, String gender) onApply;

  const PetFilterModal({
    super.key,
    required this.currentSpecies,
    required this.currentGender,
    required this.onApply,
  });

  @override
  State<PetFilterModal> createState() => _PetFilterModalState();
}

class _PetFilterModalState extends State<PetFilterModal> {
  // Variables temporales para controlar la selección dentro del menú
  late String _selectedSpecies;
  late String _selectedGender;

  @override
  void initState() {
    super.initState();
    // Inicializamos con lo que nos mandó el Home
    _selectedSpecies = widget.currentSpecies;
    _selectedGender = widget.currentGender;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Se ajusta al contenido
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Título y Botón Limpiar ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Filtros', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              TextButton(
                onPressed: () {
                  setState(() {
                    _selectedSpecies = 'Todos';
                    _selectedGender = 'Todos';
                  });
                },
                child: const Text('Limpiar', style: TextStyle(color: Colors.grey)),
              )
            ],
          ),
          const Divider(),
          const SizedBox(height: 15),

          // --- SECCIÓN 1: ESPECIE ---
          const Text('Especie', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            children: ['Todos', 'Perro', 'Gato', 'Otro'].map((label) {
              final isSelected = _selectedSpecies == label;
              return FilterChip(
                label: Text(label),
                selected: isSelected,
                selectedColor: AppColors.primary.withValues(alpha: 0.2),
                checkmarkColor: AppColors.primary,
                labelStyle: TextStyle(
                  color: isSelected ? AppColors.primary : Colors.black87,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                backgroundColor: Colors.grey[100],
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                side: BorderSide.none,
                onSelected: (bool selected) {
                  setState(() {
                    _selectedSpecies = label;
                  });
                },
              );
            }).toList(),
          ),

          const SizedBox(height: 20),

          // --- SECCIÓN 2: GÉNERO ---
          const Text('Género', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          Row(
            children: ['Todos', 'Macho', 'Hembra'].map((label) {
              final isSelected = _selectedGender == label;
              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: ChoiceChip(
                  label: Text(label),
                  selected: isSelected,
                  selectedColor: AppColors.primary,
                  labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
                  backgroundColor: Colors.grey[100],
                  onSelected: (selected) {
                    if (selected) setState(() => _selectedGender = label);
                  },
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 30),

          // --- BOTÓN APLICAR ---
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                elevation: 2,
              ),
              onPressed: () {
                // 1. Enviamos los datos de vuelta al Home
                widget.onApply(_selectedSpecies, _selectedGender);
                // 2. Cerramos el menú
                Navigator.pop(context);
              },
              child: const Text('Aplicar Filtros', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
