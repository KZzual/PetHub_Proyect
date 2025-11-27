import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:exif/exif.dart';
import 'package:http/http.dart' as http;

// Modelo del resultado del análisis IA
class AIAnalysisResult {
  final bool isPet;
  final bool exifValid;
  final String autoDescription;
  final List<String> labels;

  AIAnalysisResult({
    required this.isPet,
    required this.exifValid,
    required this.autoDescription,
    required this.labels,
  });

  Map<String, dynamic> toMap() => {
        'isPet': isPet,
        'exifValid': exifValid,
        'autoDescription': autoDescription,
        'labels': labels,
      };

  factory AIAnalysisResult.fromMap(Map<String, dynamic> map) => AIAnalysisResult(
        isPet: map['isPet'] ?? false,
        exifValid: map['exifValid'] ?? false,
        autoDescription: map['autoDescription'] ?? '',
        labels: List<String>.from(map['labels'] ?? []),
      );
}

// Servicio de IA 
class AiService {
  static const String _apiKey = 'AIzaSyBdgEMPJkFyDd7oqzsgMf72O9UutlvlOwU'; // Reemplazar con clave real
   
   // Analiza imagen local y guarda/carga resultados en caché
  static Future<AIAnalysisResult> analyzePetImage(File imageFile) async {
    //Generar un hash único de la imagen ===
    final bytes = await imageFile.readAsBytes();
    final hash = sha1.convert(bytes).toString();
    final cacheRef =
        FirebaseFirestore.instance.collection('ai_cache').doc(hash);

    // 2Revisar si ya existe análisis previo ===
    final cached = await cacheRef.get();
    if (cached.exists) {
      print(' [IA CACHE HIT] Resultado recuperado de Firestore');
      return AIAnalysisResult.fromMap(cached.data()!);
    }

    print('[IA CACHE MISS] Analizando imagen con Google Vision...');

    // Validar EXIF
    final exifValid = await _checkExifData(imageFile);

    // Enviar a Google Cloud Vision
    final visionData = await _analyzeWithGoogleVision(bytes);
    final labels = (visionData['responses']?[0]['labelAnnotations'] as List?)
            ?.map((l) => l['description'].toString())
            .toList() ??
        [];

    // Detectar tipo de mascota 
    final lower = labels.map((e) => e.toLowerCase()).toList();
    final isPet = lower.any((l) =>
        l.contains('dog') ||
        l.contains('cat') ||
        l.contains('puppy') ||
        l.contains('kitten'));

    // Generar descripción automática dinámica
    final desc = generateDynamicDescription(labels);

    //Crear resultado y guardar en caché 
    final result = AIAnalysisResult(
      isPet: isPet,
      exifValid: exifValid,
      autoDescription: desc,
      labels: labels,
    );

    await cacheRef.set(result.toMap());
    print(' [IA CACHE SAVE] Resultado almacenado con hash: $hash');

    return result;
  }

  // Validar EXIF (origen real)
  static Future<bool> _checkExifData(File imageFile) async {
    try {
      final data = await readExifFromBytes(await imageFile.readAsBytes());
      if (data.isEmpty) return false;
      return data.containsKey('Image Make') ||
          data.containsKey('EXIF LensModel') ||
          data.containsKey('Image DateTime');
    } catch (_) {
      return false;
    }
  }

  // Llamada al endpoint de Google Vision
  static Future<Map<String, dynamic>> _analyzeWithGoogleVision(
      List<int> bytes) async {
    final base64Image = base64Encode(bytes);
    final url =
        Uri.parse('https://vision.googleapis.com/v1/images:annotate?key=$_apiKey');

    final body = jsonEncode({
      'requests': [
        {
          'image': {'content': base64Image},
          'features': [
            {'type': 'LABEL_DETECTION', 'maxResults': 15},
          ],
        },
      ],
    });

    final response = await http.post(url,
        headers: {'Content-Type': 'application/json'}, body: body);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
          'Error Vision API: ${response.statusCode} - ${response.body}');
    }
  }

  // Generador dinámico de descripciones
  static String generateDynamicDescription(List<String> labels) {
    final lower = labels.map((e) => e.toLowerCase()).toList();
    final random = Random();

    bool isDog = lower.any((l) => l.contains('dog') || l.contains('puppy'));
    bool isCat = lower.any((l) => l.contains('cat') || l.contains('kitten'));
    bool isPet = isDog || isCat;

    if (!isPet) return 'No se detectó una mascota válida en la imagen.';

    // Posibles atributos detectables por color o textura
    final colors = [
      'blanco',
      'negro',
      'gris',
      'marrón',
      'beige',
      'naranja',
      'atigrado',
      'bicolor'
    ];
    final eyes = [
      'ojos claros',
      'ojos oscuros',
      'ojos verdes',
      'ojos marrones',
      'mirada curiosa'
    ];
    final temperamentDog = [
      'juguetón',
      'leal',
      'activo',
      'tranquilo',
      'protector',
      'sociable',
      'noble'
    ];
    final temperamentCat = [
      'curioso',
      'tranquilo',
      'independiente',
      'afectuoso',
      'observador',
      'perezoso',
      'amistoso'
    ];

    // Intentar inferir color a partir de etiquetas
    String color = colors.firstWhere(
      (c) => lower.any((l) => l.contains(c)),
      orElse: () => colors[random.nextInt(colors.length)],
    );

    // Elegir adjetivos aleatorios
    String eye = eyes[random.nextInt(eyes.length)];
    String temperament = (isDog
        ? temperamentDog[random.nextInt(temperamentDog.length)]
        : temperamentCat[random.nextInt(temperamentCat.length)]);

    // Estructuras dinámicas de frases
    final patterns = [
      isDog
          ? 'Perro de pelaje $color y $eye, se ve $temperament y amigable.'
          : 'Gato de pelaje $color y $eye, parece $temperament y tranquilo.',
      isDog
          ? 'Este perrito de color $color tiene $eye, con un aire $temperament.'
          : 'Este gatito de color $color tiene $eye, con un temperamento $temperament.',
      isDog
          ? 'Un perro $color con $eye, ideal para quienes buscan un compañero $temperament.'
          : 'Un gato $color con $eye, perfecto para hogares donde se valore su lado $temperament.',
      isDog
          ? 'Perrito $color de $eye, se nota muy $temperament y con buen ánimo.'
          : 'Gatito $color de $eye, luce $temperament y muy tierno.',
    ];

    return patterns[random.nextInt(patterns.length)];
  }
}
