// ¡¡ESTA LÍNEA FALTABA!!
import 'package:flutter/material.dart';

import '../widgets/pet_card.dart'; // Importamos nuestra tarjeta
import '../utils/app_colors.dart'; // Importamos los colores

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. ELIMINAMOS el 'primaryColor' local, usaremos el Theme
    
    return Scaffold(
      // 2. El AppBar se mantiene igual
      appBar: AppBar(
        leading: const Icon(Icons.pets, color: AppColors.textLight),
        title: const Text('PetHub - Inicio', style: TextStyle(color: AppColors.textLight)),
        // El color lo toma del Theme en main.dart (AppColors.primary)
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline, color: AppColors.textLight),
            onPressed: () { /* Acción para ir al perfil */ },
          ),
        ],
      ),
      
      // 3. El Cuerpo de la App se mantiene igual
      body: ListView(
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
          // const PetCard(), // Podríamos añadir más
        ],
      ),

      // 4. ¡IMPORTANTE!
      // Se eliminó la propiedad 'bottomNavigationBar'.
      // MainShell (el widget padre) ahora se encarga de esto.
    );
  }

  // --- Métodos de Ayuda para construir partes de la UI ---

  Widget _buildSubHeader() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: AppColors.primary, // Usamos el color de la paleta
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
                fillColor: AppColors.accent, // Usamos el color de la paleta
              ),
            ),
          ),
          const SizedBox(width: 10),
          IconButton(
            icon: const Icon(Icons.filter_list),
            style: IconButton.styleFrom(
              backgroundColor: AppColors.primary.withAlpha(50), // Usamos el color
              foregroundColor: AppColors.primary, // Usamos el color
            ),
            onPressed: () { /* Acción para filtros */ },
          ),
        ],
      ),
    );
  }
}

