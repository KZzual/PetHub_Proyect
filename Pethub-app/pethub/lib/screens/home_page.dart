// 1. IMPORTS
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/pet_card.dart';
import '../utils/app_colors.dart';
import 'pet_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _searchText = "";
  
  // 1. CORRECCIÓN CLAVE:
  // Declaramos el stream aquí para iniciarlo SOLO UNA VEZ.
  // Esto evita que la conexión se reinicie cada vez que escribes una letra.
  late Stream<QuerySnapshot> _petsStream;

  @override
  void initState() {
    super.initState();
    _petsStream = FirebaseFirestore.instance
        .collection('pets')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // --- HEADER Y BUSCADOR ---
        // Al estar fuera del StreamBuilder, no se reconstruyen innecesariamente
        // lo que mantiene el teclado abierto y el foco en el input.
        _buildSubHeader(),
        _buildSearchBar(),

        // --- LISTA DE RESULTADOS ---
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: _petsStream,
            builder: (context, snapshot) {
              // Estado de Carga
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              
              // Estado de Error
              if (snapshot.hasError) {
                return const Center(child: Text('Error al cargar publicaciones'));
              }

              // Obtener datos crudos
              final allPetsDocs = snapshot.data?.docs ?? [];

              // 2. LÓGICA DE FILTRADO
              final filteredPets = allPetsDocs.where((doc) {
                final data = doc.data() as Map<String, dynamic>;
                
                final name = (data['name'] ?? '').toString().toLowerCase();
                final breed = (data['breed'] ?? '').toString().toLowerCase();
                final searchLower = _searchText.toLowerCase();

                // Si no hay texto, searchLower es "", y contains("") siempre es true.
                return name.contains(searchLower) || breed.contains(searchLower);
              }).toList();

              // Estado Vacío (Sin resultados)
              if (filteredPets.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Column(
                      children: [
                        const Icon(Icons.search_off, size: 50, color: Colors.grey),
                        const SizedBox(height: 10),
                        Text(
                          _searchText.isEmpty
                              ? 'Aún no hay publicaciones 🐾'
                              : 'No encontramos mascotas con "$_searchText"',
                          style: const TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                );
              }

              // Lista de Mascotas
              return ListView(
                padding: const EdgeInsets.only(bottom: 20),
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Text(
                      '${filteredPets.length} mascotas encontradas',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  
                  // Renderizado de tarjetas
                  ...filteredPets.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    final timestamp = data['createdAt'];
                    
                    // Lógica básica de tiempo (puedes mejorarla con tu función getTimeAgo)
                    String timeAgo = 'Reciente';
                    if (timestamp != null) {
                       // Aquí puedes re-integrar tu lógica de cálculo de tiempo si la tienes
                    }

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PetDetailPage(
                              docId: doc.id,
                              petData: data,
                            ),
                          ),
                        );
                      },
                      child: PetCard(
                        name: data['name'] ?? 'Sin nombre',
                        species: data['species'] ?? 'Desconocido',
                        breed: data['breed'] ?? 'Sin raza',
                        gender: data['gender'] ?? 'No especificado',
                        age: data['age'] ?? '',
                        location: data['location'] ?? '',
                        photoUrl: data['photoUrl'] ?? '',
                        userId: data['userId'] ?? '',
                        userName: data['userName'] ?? 'Usuario desconocido',
                        userPhoto: data['userPhoto'] ?? '',
                        timeAgo: timeAgo,
                      ),
                    );
                  }),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  // --- Subheader ---
  Widget _buildSubHeader() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: AppColors.primary,
      width: double.infinity,
      child: const Text(
        'Encuentra a tu compañero perfecto',
        style: TextStyle(
          color: AppColors.textLight,
          fontSize: 16.0,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  // --- Barra de búsqueda ---
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              // Al cambiar el texto, actualizamos el estado
              onChanged: (value) {
                setState(() {
                  _searchText = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Buscar por nombre o raza...',
                prefixIcon: const Icon(Icons.search),
                
                // Botón para limpiar búsqueda
                suffixIcon: _searchText.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchText = "";
                            // Nota: Para limpiar el texto visualmente del input
                            // necesitarías un TextEditingController, pero esto limpia el filtro.
                          });
                        },
                      )
                    : null,
                
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
          
          // Botón de Filtros
          IconButton(
            icon: const Icon(Icons.filter_list),
            style: IconButton.styleFrom(
              // ACTUALIZADO: Uso moderno de transparencia (0.0 - 1.0)
              backgroundColor: AppColors.primary.withValues(alpha: 0.2),
              foregroundColor: AppColors.primary,
            ),
            onPressed: () {
              // Aquí iría la lógica para abrir el Modal de filtros avanzado
            },
          ),
        ],
      ),
    );
  }
}
