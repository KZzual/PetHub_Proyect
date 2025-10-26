// 1. IMPORT DE MATERIAL
import 'package:flutter/material.dart';

// 2. IMPORTS CORREGIDOS (con '../' para subir un nivel)
import '../widgets/pet_card.dart'; 
import '../utils/app_colors.dart'; 

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    
    // 3. ¡SIN SCAFFOLD Y SIN APPBAR!
    // MainShell (el padre) ahora los provee.
    return ListView(
      children: [
        _buildSubHeader(),
        _buildSearchBar(),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            '4 mascotas encontradas',
            style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textDark),
          ),
        ),
        
        const PetCard(),
      ],
    );
  }

  // --- Los métodos de ayuda se quedan igual ---

  Widget _buildSubHeader() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: AppColors.primary, 
      width: double.infinity,
      child: const Text(
        'Encuentra a tu compañero perfecto',
        style: TextStyle(color: AppColors.textLight, fontSize: 16.0),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar por nombre, raza o ubicación...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: AppColors.accent, 
              ),
            ),
          ),
          const SizedBox(width: 10),
          IconButton(
            icon: const Icon(Icons.filter_list),
            style: IconButton.styleFrom(
              backgroundColor: AppColors.primary.withAlpha(50),
              foregroundColor: AppColors.primary,
            ),
            onPressed: () { /* Acción para filtros */ },
          ),
        ],
      ),
    );
  }
}

