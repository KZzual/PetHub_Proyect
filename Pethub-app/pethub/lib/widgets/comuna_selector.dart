import 'package:flutter/material.dart';
import '../data/comunas_rm.dart';
import '../utils/app_colors.dart';

Future<String?> showComunaSelector(
  BuildContext context, {
  String? comunaActual,
}) async {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.background,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return FractionallySizedBox(
        heightFactor: 0.85, // 85% de altura
        child: _ComunaSelectorContent(comunaActual: comunaActual),
      );
    },
  );
}

class _ComunaSelectorContent extends StatefulWidget {
  final String? comunaActual;
  const _ComunaSelectorContent({this.comunaActual});

  @override
  State<_ComunaSelectorContent> createState() => _ComunaSelectorContentState();
}

class _ComunaSelectorContentState extends State<_ComunaSelectorContent> {
  String _searchText = "";

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header con buscador y botón cerrar
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  autofocus: true,
                  onChanged: (val) => setState(() => _searchText = val.trim()),
                  decoration: InputDecoration(
                    hintText: 'Buscar comuna...',
                    filled: true,
                    fillColor: AppColors.accent,
                    prefixIcon: const Icon(Icons.search, color: AppColors.textDark),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.close, color: AppColors.textDark),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),

        const Divider(height: 1),

        // Lista de Provincias y Comunas
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.only(bottom: 24),
            itemCount: provinciasRM.length,
            itemBuilder: (context, provIndex) {
              final provincia = provinciasRM[provIndex];

              // Filtrar comunas por búsqueda
              final comunasFiltradas = provincia.comunas.where((comuna) {
                final query = _normalize(_searchText);
                final target = _normalize(comuna);
                return target.contains(query);
              }).toList();

              if (comunasFiltradas.isEmpty) return const SizedBox();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header estilizado
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    color: AppColors.primary.withAlpha(28), // Color suave
                    child: Text(
                      provincia.nombre.toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                  ),

                  // Comunas filtradas
                  ...comunasFiltradas.map((comuna) {
                    final isSelected = comuna == widget.comunaActual;
                    return ListTile(
                      leading: const Icon(Icons.location_on_outlined,
                          color: AppColors.textDark),
                      title: Text(comuna,
                          style: const TextStyle(color: AppColors.textDark)),
                      trailing: isSelected
                          ? const Icon(Icons.check, color: AppColors.primary)
                          : null,
                      onTap: () {
                        Navigator.pop(context, comuna);
                      },
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

  // Normaliza texto quitando tildes / acentos
  String _normalize(String input) {
    return input
        .toLowerCase()
        .replaceAll(RegExp(r'[áàäâ]'), 'a')
        .replaceAll(RegExp(r'[éèëê]'), 'e')
        .replaceAll(RegExp(r'[íìïî]'), 'i')
        .replaceAll(RegExp(r'[óòöô]'), 'o')
        .replaceAll(RegExp(r'[úùüû]'), 'u');
  }
}
