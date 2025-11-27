class Provincia {
  final String nombre;
  final List<String> comunas;

  Provincia({required this.nombre, required this.comunas});
}

// Región Metropolitana — Provincias y Comunas (ordenadas alfabéticamente)
final List<Provincia> provinciasRM = [

  Provincia(
    nombre: "Santiago",
    comunas: [
      "Cerrillos",
      "Cerro Navia",
      "Conchalí",
      "El Bosque",
      "Estación Central",
      "Huechuraba",
      "Independencia",
      "La Cisterna",
      "La Florida",
      "La Granja",
      "La Pintana",
      "La Reina",
      "Las Condes",
      "Lo Barnechea",
      "Lo Espejo",
      "Lo Prado",
      "Macul",
      "Maipú",
      "Ñuñoa",
      "Pedro Aguirre Cerda",
      "Peñalolén",
      "Providencia",
      "Pudahuel",
      "Quilicura",
      "Quinta Normal",
      "Recoleta",
      "Renca",
      "San Joaquín",
      "San Miguel",
      "San Ramón",
      "Santiago",
      "Vitacura",
    ],
  ),

  Provincia(
    nombre: "Cordillera",
    comunas: [
      "Pirque",
      "Puente Alto",
      "San José de Maipo",
    ],
  ),

  Provincia(
    nombre: "Chacabuco",
    comunas: [
      "Colina",
      "Lampa",
      "Tiltil",
    ],
  ),

  Provincia(
    nombre: "Maipo",
    comunas: [
      "Buin",
      "Calera de Tango",
      "Paine",
      "San Bernardo",
    ],
  ),

  Provincia(
    nombre: "Talagante",
    comunas: [
      "El Monte",
      "Isla de Maipo",
      "Padre Hurtado",
      "Peñaflor",
      "Talagante",
    ],
  ),

  Provincia(
    nombre: "Melipilla",
    comunas: [
      "Alhué",
      "Curacaví",
      "María Pinto",
      "Melipilla",
      "San Pedro",
    ],
  ),

];
