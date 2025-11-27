// 1. IMPORTS
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/pet_card.dart';
import '../utils/app_colors.dart';
import 'pet_detail_page.dart';
import '../widgets/pet_filter_modal.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Variables del Buscador
  String _searchText = "";
  
  // VARIABLES PARA LOS FILTROS
  String _filterSpecies = "Todos";
  String _filterGender = "Todos";

  late Stream<QuerySnapshot> _petsStream;

  @override
  void initState() {
    super.initState();
    _petsStream = FirebaseFirestore.instance
        .collection('pets')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // FUNCIÓN PARA ABRIR EL MENU DE FILTROS
  void _showFilters() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent, // Para ver las esquinas redondeadas
      builder: (context) => PetFilterModal(
        currentSpecies: _filterSpecies,
        currentGender: _filterGender,
        onApply: (species, gender) {
          // Cuando le den a "Aplicar", actualizamos el estado aquí
          setState(() {
            _filterSpecies = species;
            _filterGender = gender;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSubHeader(),
        _buildSearchBar(), // El botón dentro de aquí llamará a _showFilters

        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: _petsStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return const Center(child: Text('Error al cargar publicaciones'));
              }

              final allPetsDocs = snapshot.data?.docs ?? [];

              // LÓGICA MAESTRA DE FILTRADO 
              final filteredPets = allPetsDocs.where((doc) {
                final data = doc.data() as Map<String, dynamic>;
                
                // A. Filtro de Texto 
                final name = (data['name'] ?? '').toString().toLowerCase();
                final breed = (data['breed'] ?? '').toString().toLowerCase();
                final searchLower = _searchText.toLowerCase();
                bool passSearch = name.contains(searchLower) || breed.contains(searchLower);

                // B. Filtro de Especie 
                final species = (data['species'] ?? '').toString();
                bool passSpecies = _filterSpecies == 'Todos' || species == _filterSpecies;

                // C. Filtro de Género 
                final gender = (data['gender'] ?? '').toString();
                bool passGender = _filterGender == 'Todos' || gender == _filterGender;

                // TIENE QUE CUMPLIR LAS 3 COSAS
                return passSearch && passSpecies && passGender;
              }).toList();

              // --- UI CUANDO NO HAY RESULTADOS ---
              if (filteredPets.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Column(
                      children: [
                        const Icon(Icons.filter_alt_off, size: 50, color: Colors.grey),
                        const SizedBox(height: 10),
                        const Text(
                          'No encontramos mascotas con esos criterios',
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                        // Botón extra para limpiar si hay filtros activos
                        if (_filterSpecies != 'Todos' || _filterGender != 'Todos')
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _filterSpecies = 'Todos';
                                _filterGender = 'Todos';
                                _searchText = '';
                              });
                            },
                            child: const Text('Limpiar filtros'),
                          )
                      ],
                    ),
                  ),
                );
              }

              return ListView(
                padding: const EdgeInsets.only(bottom: 20),
                children: [
                  // Indicador de filtros activos
                  if (_filterSpecies != 'Todos' || _filterGender != 'Todos')
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                      child: Row(
                        children: [
                          const Text('Filtros: ', style: TextStyle(fontSize: 12, color: Colors.grey)),
                          if(_filterSpecies != 'Todos') Chip(label: Text(_filterSpecies), visualDensity: VisualDensity.compact,),
                          const SizedBox(width: 5),
                          if(_filterGender != 'Todos') Chip(label: Text(_filterGender), visualDensity: VisualDensity.compact,),
                        ],
                      ),
                    ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Text(
                      '${filteredPets.length} mascotas encontradas',
                      style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textDark, fontSize: 16),
                    ),
                  ),
                  ...filteredPets.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    final timestamp = data['createdAt'];
                  String timeAgo = '';
                  if (timestamp != null) {
                    final postDate = (timestamp as Timestamp).toDate();
                    final diff = DateTime.now().difference(postDate);

                    if (diff.inSeconds < 60) {
                      timeAgo = 'Hace unos segundos';
                    } else if (diff.inMinutes < 60) {
                      timeAgo = 'Hace ${diff.inMinutes} min';
                    } else if (diff.inHours < 24) {
                      timeAgo = 'Hace ${diff.inHours} h';
                    } else if (diff.inDays < 7) {
                      timeAgo = 'Hace ${diff.inDays} días';
                    } else {
                      final weeks = (diff.inDays / 7).floor();
                      timeAgo = 'Hace $weeks semana${weeks > 1 ? 's' : ''}';
                    }
                  }
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PetDetailPage(docId: doc.id, petData: data),
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
              onChanged: (value) {
                setState(() => _searchText = value);
              },
              decoration: InputDecoration(
                hintText: 'Buscar por nombre o raza...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchText.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => setState(() => _searchText = ""),
                      )
                    : null,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide.none),
                filled: true,
                fillColor: AppColors.accent,
              ),
            ),
          ),
          const SizedBox(width: 10),
          
          // CONEXIÓN DEL BOTÓN
          IconButton(
            icon: const Icon(Icons.tune), // Icono de ajustes/filtros
            style: IconButton.styleFrom(
              // Si hay filtros activos, pintamos el botón para avisar al usuario
              backgroundColor: (_filterSpecies != 'Todos' || _filterGender != 'Todos')
                  ? AppColors.primary 
                  : AppColors.primary.withValues(alpha: 0.2),
              foregroundColor: (_filterSpecies != 'Todos' || _filterGender != 'Todos')
                  ? Colors.white 
                  : AppColors.primary,
            ),
            onPressed: _showFilters, // LLAMAMOS A LA FUNCIÓN AQUÍ
          ),
        ],
      ),
    );
  }
}
