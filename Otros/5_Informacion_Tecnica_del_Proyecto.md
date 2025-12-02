# INFORMACIÓN TÉCNICA DEL PROYECTO PETHUB

## 📋 Especificaciones Técnicas Completas

---

## 1️⃣ INFORMACIÓN GENERAL

### Identificación del Proyecto

| Campo | Valor |
|---|---|
| **Nombre del Proyecto** | PetHub |
| **Versión Actual** | 1.4.0+1 |
| **Tipo de Aplicación** | Aplicación móvil nativa Android |
| **Framework Principal** | Flutter |
| **Lenguaje de Programación** | Dart |
| **Backend** | Firebase (Backend as a Service) |
| **Repositorio** | https://github.com/KZzual/PetHub_Proyect |
| **Propietario** | KZzual |
| **Branch Principal** | main |
| **Branch de Desarrollo** | firebase |
| **Licencia** | No especificada (Proyecto Académico) |
| **Contexto** | Proyecto Capstone - Aplicación de Adopción de Mascotas |
| **Alcance Geográfico** | Comuna de San Joaquín, Región Metropolitana, Chile |

---

## 2️⃣ VERSIONES Y COMPATIBILIDAD

### Versión de la Aplicación

```yaml
version: 1.4.0+1
```

**Desglose:**
- **Major:** 1 (Primera versión estable)
- **Minor:** 4 (Cuarta actualización de features)
- **Patch:** 0 (Sin parches aplicados en esta versión)
- **Build Number:** +1 (Primera compilación de esta versión)

---

### Entorno de Desarrollo

#### Flutter SDK

```yaml
environment:
  sdk: ^3.9.2
```

| Componente | Versión |
|---|---|
| **Flutter SDK Mínimo** | 3.9.2 |
| **Dart SDK** | ^3.9.2 (incluido con Flutter) |
| **Flutter Channel** | Stable (recomendado) |

---

#### Compatibilidad de Plataformas

| Plataforma | Soportada | Versión Mínima | Notas |
|---|---|---|---|
| **Android** | ✅ Sí | API 21 (Android 5.0 Lollipop) | Plataforma principal |
| **iOS** | ⚠️ Parcial | No compilado | Código compatible pero no configurado |
| **Web** | ❌ No | - | Solo archivos HTML estáticos |
| **Windows** | ❌ No | - | Estructura generada pero no implementada |
| **macOS** | ❌ No | - | Estructura generada pero no implementada |
| **Linux** | ❌ No | - | Estructura generada pero no implementada |

---

### Android Específico

#### Configuración de Build

**Archivo:** `android/build.gradle.kts`

```kotlin
// Versiones inferidas del proyecto
Android Gradle Plugin: 8.x
Kotlin: 1.9.x
Gradle: 8.x
compileSdkVersion: 34
minSdkVersion: 21
targetSdkVersion: 34
```

**Arquitecturas Soportadas:**
- arm64-v8a (64-bit ARM)
- armeabi-v7a (32-bit ARM)
- x86_64 (64-bit Intel - para emuladores)

---

## 3️⃣ DEPENDENCIAS DEL PROYECTO

### Dependencias Principales (Production)

#### Firebase Core

```yaml
firebase_core: ^4.2.0
```
**Propósito:** Inicialización de Firebase y configuración base  
**Proveedor:** Firebase (Google)  
**Documentación:** https://firebase.google.com/docs/flutter/setup

---

#### Firebase Authentication

```yaml
firebase_auth: ^6.1.1
```
**Propósito:** Autenticación de usuarios (email/password)  
**Características usadas:**
- Registro de usuarios
- Login
- Verificación de email
- Recuperación de contraseña
- Persistencia de sesión

---

#### Cloud Firestore

```yaml
cloud_firestore: ^6.0.3
```
**Propósito:** Base de datos NoSQL en tiempo real  
**Colecciones utilizadas:**
- `users` → Perfiles de usuario
- `pets` → Publicaciones de mascotas
- `chats` → Conversaciones
- `ai_cache` → Caché de análisis IA

**Features usadas:**
- Snapshots en tiempo real
- Queries con orderBy
- Subcolecciones
- Timestamps del servidor

---

#### Firebase Storage

```yaml
firebase_storage: ^13.0.3
```
**Propósito:** Almacenamiento de archivos en la nube  
**Archivos almacenados:**
- Fotos de perfil: `profile_photos/{userId}.jpg`
- Fotos de mascotas: `pet_photos/{userId}_{timestamp}.jpg`

**Features usadas:**
- Upload de archivos
- Download URLs
- Eliminación de archivos

---

#### Firebase Cloud Messaging

```yaml
firebase_messaging: ^16.0.4
```
**Propósito:** Notificaciones push  
**Features usadas:**
- Token FCM por dispositivo
- Mensajes en foreground
- Mensajes en background
- Data payload
- Navegación profunda

---

#### Flutter Local Notifications

```yaml
flutter_local_notifications: ^17.2.1
```
**Propósito:** Notificaciones locales (foreground)  
**Features usadas:**
- Notificaciones cuando app está abierta
- Canal de alta importancia
- Payload personalizado
- Callback al tocar notificación

---

#### HTTP Client

```yaml
http: ^1.5.0
```
**Propósito:** Realizar peticiones HTTP  
**Uso:** Llamadas a Google Cloud Vision API

---

#### Image Picker

```yaml
image_picker: ^1.2.0
```
**Propósito:** Seleccionar imágenes desde galería o cámara  
**Features usadas:**
- Selección desde galería
- Captura con cámara
- Compresión de imagen (quality: 80%)

---

#### Google Fonts

```yaml
google_fonts: ^6.3.2
```
**Propósito:** Fuentes personalizadas de Google  
**Uso:** Mejorar tipografía de la aplicación

---

#### Shared Preferences

```yaml
shared_preferences: ^2.5.3
```
**Propósito:** Almacenamiento local de preferencias  
**Datos almacenados:**
- Estado de sesión
- Preferencia "Recordarme"
- Configuraciones de usuario

---

#### Image Processing

```yaml
image: ^4.0.17
```
**Propósito:** Procesamiento y manipulación de imágenes  
**Uso:** Redimensionamiento y compresión de fotos

---

#### EXIF Metadata

```yaml
exif: ^3.1.4
```
**Propósito:** Leer metadatos EXIF de imágenes  
**Uso:** Validar autenticidad de fotografías (detectar si es original o descargada)

---

#### Crypto

```yaml
crypto: ^3.0.3
```
**Propósito:** Funciones criptográficas  
**Uso:** Generar hash SHA-1 de imágenes para sistema de caché

---

#### WebView Flutter

```yaml
webview_flutter: ^4.7.0
```
**Propósito:** Mostrar contenido web dentro de la app  
**Uso:** Visualizar Política de Privacidad y Términos y Condiciones

---

#### Lottie

```yaml
lottie: ^3.3.2
```
**Propósito:** Animaciones vectoriales  
**Uso:** Animaciones en pantallas de éxito/carga (si se implementaron)

---

#### Cupertino Icons

```yaml
cupertino_icons: ^1.0.8
```
**Propósito:** Iconos de estilo iOS  
**Uso:** Complementar Material Icons

---

### Dependencias de Desarrollo (DevDependencies)

#### Flutter Test

```yaml
flutter_test:
  sdk: flutter
```
**Propósito:** Framework de testing de Flutter  
**Uso:** Tests unitarios y de widgets

---

#### Flutter Lints

```yaml
flutter_lints: ^5.0.0
```
**Propósito:** Reglas de linting para código Dart  
**Uso:** Mantener calidad y estilo de código

---

#### Flutter Launcher Icons

```yaml
flutter_launcher_icons: ^0.13.1
```
**Propósito:** Generar iconos de lanzador  
**Configuración:**
```yaml
flutter_icons:
  android: true
  ios: true
  image_path: "assets/icon/icon.png"
  adaptive_icon_background: "#ffffff"
  adaptive_icon_foreground: "assets/icon/icon.png"
```

---

## 4️⃣ BACKEND Y SERVICIOS EN LA NUBE

### Firebase Services

#### Firebase Authentication
- **Plan:** Spark (Gratuito)
- **Método de autenticación:** Email/Password
- **Usuarios ilimitados** en plan gratuito
- **Verificación de email:** Habilitada

#### Cloud Firestore
- **Plan:** Spark (Gratuito)
- **Límites del plan gratuito:**
  - 50,000 lecturas/día
  - 20,000 escrituras/día
  - 20,000 eliminaciones/día
  - 1 GB de almacenamiento
- **Modo:** Native mode
- **Región:** us-central (inferido)

#### Firebase Storage
- **Plan:** Spark (Gratuito)
- **Límites:**
  - 5 GB de almacenamiento total
  - 1 GB de descarga/día
  - 20,000 operaciones de subida/día

#### Firebase Cloud Messaging
- **Plan:** Gratuito ilimitado
- **Plataformas:** Android
- **Features usadas:**
  - Data messages
  - Notification messages
  - Topics: No
  - Device groups: No

#### Firebase Hosting
- **Plan:** Spark (Gratuito)
- **Archivos hospedados:**
  - `privacy-policy.html`
  - `terms-conditions.html`
- **Límites:**
  - 10 GB de almacenamiento
  - 360 MB/día de transferencia

---

### Firebase Cloud Functions

**Archivo:** `functions/package.json`

```json
{
  "name": "functions",
  "description": "Cloud Functions for Firebase",
  "engines": {
    "node": "22"
  },
  "main": "index.js",
  "dependencies": {
    "firebase-admin": "^12.6.0",
    "firebase-functions": "^6.0.1"
  }
}
```

#### Especificaciones

| Campo | Valor |
|---|---|
| **Runtime** | Node.js 22 |
| **Región** | us-central1 (default) |
| **Memoria** | 256 MB (default) |
| **Timeout** | 60 segundos (default) |
| **Funciones desplegadas** | 1 |

#### Función: `notifyNewMessage`

```javascript
exports.notifyNewMessage = onDocumentCreated(
  "chats/{chatId}/messages/{msgId}",
  async (event) => {
    // Envía notificación push al receptor del mensaje
  }
);
```

**Trigger:** Creación de documento en `chats/{chatId}/messages/{msgId}`  
**Acción:**
1. Obtiene datos del chat
2. Identifica al receptor
3. Obtiene token FCM del receptor
4. Incrementa contador `unreadCount`
5. Envía notificación push con FCM

---

### Google Cloud Platform APIs

#### Google Cloud Vision API

**Versión:** v1  
**Endpoint:** `https://vision.googleapis.com/v1/images:annotate`  
**API Key:** `AIzaSyBdgEMPJkFyDd7oqzsgMf72O9UutlvlOwU` ⚠️ (expuesta en código)

**Features utilizadas:**
- **LABEL_DETECTION:** Detecta etiquetas de objetos en imagen
- **Uso:** Identificar si imagen contiene perro o gato
- **Uso:** Generar descripción automática de mascota

**Costo estimado:**
- 1,000 requests gratuitas/mes
- $1.50 por cada 1,000 requests adicionales

**Sistema de caché implementado:**
- Hash SHA-1 de imagen → Firestore `ai_cache`
- Evita requests duplicadas
- Ahorro de costos

---

## 5️⃣ ARQUITECTURA DEL PROYECTO

### Estructura de Carpetas

```
PetHub_Proyect/
│
├── firebase.json                    # Configuración de Firebase
├── README.md                        # Documentación del proyecto
│
├── functions/                       # Cloud Functions (Backend)
│   ├── index.js                     # Función notifyNewMessage
│   └── package.json                 # Dependencias Node.js
│
├── Otros/                           # Documentación adicional
│
└── Pethub-app/
    └── pethub/                      # Aplicación Flutter principal
        │
        ├── pubspec.yaml             # Dependencias y metadatos
        ├── firebase.json            # Config Firebase de la app
        │
        ├── android/                 # Configuración Android
        │   ├── build.gradle.kts
        │   ├── settings.gradle.kts
        │   └── app/
        │       ├── build.gradle.kts
        │       └── google-services.json  # Credenciales Firebase
        │
        ├── assets/                  # Recursos estáticos
        │   ├── icon/                # Iconos de launcher
        │   └── images/              # Imágenes (background.jpg)
        │
        ├── lib/                     # Código fuente Dart
        │   │
        │   ├── main.dart            # Punto de entrada
        │   ├── main_shell.dart      # Shell con BottomNavBar
        │   ├── auth_service.dart    # Servicio de autenticación
        │   ├── firebase_options.dart # Config generada de Firebase
        │   │
        │   ├── data/                # Datos estáticos
        │   │   └── comunas_rm.dart  # Lista de comunas
        │   │
        │   ├── screens/             # Pantallas de la app (16)
        │   │   ├── login_page.dart
        │   │   ├── home_page.dart
        │   │   ├── create_post_page.dart
        │   │   ├── profile_page.dart
        │   │   ├── edit_profile_page.dart
        │   │   ├── chat_page.dart
        │   │   ├── messages_page.dart
        │   │   ├── notifications_page.dart
        │   │   ├── pet_detail_page.dart
        │   │   ├── my_post_page.dart
        │   │   ├── post_history_page.dart
        │   │   ├── settings_page.dart
        │   │   ├── verify_email_page.dart
        │   │   ├── success_account_page.dart
        │   │   ├── privacy_policy_page.dart
        │   │   └── terms_conditios.dart
        │   │
        │   ├── services/            # Servicios de lógica de negocio
        │   │   ├── ai_service.dart          # Integración Google Vision
        │   │   ├── chat_service.dart        # Gestión de chats
        │   │   ├── notification_service.dart # Notificaciones locales
        │   │   └── user_service.dart        # Gestión de usuarios
        │   │
        │   ├── utils/               # Utilidades
        │   │   └── app_colors.dart  # Paleta de colores
        │   │
        │   └── widgets/             # Componentes reutilizables
        │       ├── comuna_selector.dart
        │       ├── info_chip.dart
        │       ├── pet_card.dart
        │       └── pet_filter_modal.dart
        │
        ├── public/                  # Archivos públicos (Hosting)
        │   ├── privacy-policy.html
        │   └── terms-conditions.html
        │
        └── test/                    # Tests
            └── widget_test.dart
```

---

### Arquitectura de Servicios (Singleton Pattern)

#### AuthService

```dart
class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();
  
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  // Métodos:
  // - signIn()
  // - signUp()
  // - sendEmailVerification()
  // - sendPasswordReset()
  // - signOut()
}
```

**Patrón:** Singleton privado  
**Responsabilidad:** Gestión de autenticación

---

#### UserService

```dart
class UserService {
  static final _firestore = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;
  
  // Métodos estáticos:
  // - createUserProfile()
  // - streamUserProfile()
  // - getCurrentUserProfile()
  // - updateUserProfile()
  // - refreshFcmToken()
}
```

**Patrón:** Clase estática con métodos estáticos  
**Responsabilidad:** CRUD de perfiles de usuario

---

#### ChatService

```dart
class ChatService {
  static final _firestore = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;
  
  // Métodos estáticos:
  // - createOrGetChat()
  // - sendMessage()
  // - streamMessages()
  // - markMessagesAsSeen()
}
```

**Patrón:** Clase estática  
**Responsabilidad:** Gestión de mensajería

---

#### AiService

```dart
class AiService {
  static const String _apiKey = 'AIzaSyBdgEMPJkFyDd7oqzsgMf72O9UutlvlOwU';
  
  // Métodos estáticos:
  // - analyzePetImage()
  // - _checkExifData()
  // - _analyzeWithGoogleVision()
  // - generateDynamicDescription()
}
```

**Patrón:** Clase estática  
**Responsabilidad:** Análisis de imágenes con IA

---

#### NotificationService

```dart
class NotificationService {
  // Métodos estáticos:
  // - get pendingStatusChangeNotifications (Stream)
}
```

**Patrón:** Clase estática  
**Responsabilidad:** Contador de notificaciones pendientes

---

## 6️⃣ MODELO DE DATOS (FIRESTORE)

### Colección: `users`

**Path:** `/users/{userId}`

| Campo | Tipo | Descripción | Obligatorio |
|---|---|---|---|
| `name` | String | Nombre del usuario | Sí |
| `email` | String | Correo electrónico | Sí |
| `phone` | String | Teléfono con formato +569XXXXXXXX | Sí |
| `comuna` | String | Comuna de residencia | No |
| `photoUrl` | String | URL de foto de perfil | No |
| `description` | String | Descripción personal | No |
| `role` | String | Rol (siempre "adoptante") | Sí |
| `fcmToken` | String | Token FCM para notificaciones | Sí |
| `createdAt` | Timestamp | Fecha de creación | Sí |

**Subcolección:** `/users/{userId}/recent_views/{petId}`

| Campo | Tipo | Descripción |
|---|---|---|
| `name` | String | Nombre de la mascota |
| `photoUrl` | String | URL de foto |
| `species` | String | Especie (Perro/Gato) |
| `status` | String | Estado actual |
| `lastStatus` | String | Último estado conocido |
| `viewedAt` | Timestamp | Fecha de visualización |

---

### Colección: `pets`

**Path:** `/pets/{petId}`

| Campo | Tipo | Descripción | Obligatorio |
|---|---|---|---|
| `userId` | String | UID del dueño | Sí |
| `userName` | String | Nombre del dueño | Sí |
| `userPhoto` | String | Foto del dueño | No |
| `name` | String | Nombre de la mascota | Sí |
| `species` | String | "Perro" o "Gato" | Sí |
| `breed` | String | Raza | Sí |
| `gender` | String | "Macho" o "Hembra" | Sí |
| `age` | String | Edad (texto libre) | Sí |
| `location` | String | Ubicación (texto libre) | Sí |
| `description` | String | Descripción manual | No |
| `autoDescription` | String | Descripción generada por IA | No |
| `photoUrl` | String | URL de foto en Storage | Sí |
| `status` | String | "En Adopción" o "Adoptado" | Sí |
| `createdAt` | Timestamp | Fecha de publicación | Sí |
| `aiAnalysis` | Map | Datos del análisis IA | No |

---

### Colección: `chats`

**Path:** `/chats/{chatId}`

| Campo | Tipo | Descripción |
|---|---|---|
| `users` | Array<String> | [userId1, userId2] |
| `participants` | Map | {userId: {name, photoUrl}} |
| `lastMessage` | String | Texto del último mensaje |
| `lastTimestamp` | Timestamp | Fecha del último mensaje |
| `unreadCount` | Number | Contador de no leídos |

**Subcolección:** `/chats/{chatId}/messages/{messageId}`

| Campo | Tipo | Descripción |
|---|---|---|
| `senderId` | String | UID del remitente |
| `text` | String | Contenido del mensaje |
| `timestamp` | Timestamp | Fecha de envío |
| `seen` | Boolean | Si fue leído |

---

### Colección: `ai_cache`

**Path:** `/ai_cache/{imageHash}`

| Campo | Tipo | Descripción |
|---|---|---|
| `isPet` | Boolean | Si la imagen contiene mascota |
| `exifValid` | Boolean | Si tiene metadatos EXIF válidos |
| `autoDescription` | String | Descripción generada |
| `labels` | Array<String> | Etiquetas detectadas |

---

## 7️⃣ CONFIGURACIÓN DE SEGURIDAD

### Firebase Security Rules (Inferidas)

#### Firestore Rules (Recomendadas)

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // Usuarios
    match /users/{userId} {
      allow read: if request.auth != null;
      allow write: if request.auth.uid == userId;
      
      match /recent_views/{petId} {
        allow read, write: if request.auth.uid == userId;
      }
    }
    
    // Publicaciones de mascotas
    match /pets/{petId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null;
      allow update, delete: if request.auth.uid == resource.data.userId;
    }
    
    // Chats
    match /chats/{chatId} {
      allow read, write: if request.auth != null && 
                            request.auth.uid in resource.data.users;
      
      match /messages/{messageId} {
        allow read, write: if request.auth != null;
      }
    }
    
    // Caché de IA
    match /ai_cache/{hash} {
      allow read, write: if request.auth != null;
    }
  }
}
```

---

#### Storage Rules (Recomendadas)

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    
    // Fotos de perfil
    match /profile_photos/{userId}.jpg {
      allow read: if request.auth != null;
      allow write: if request.auth.uid == userId;
    }
    
    // Fotos de mascotas
    match /pet_photos/{allPaths=**} {
      allow read: if request.auth != null;
      allow write: if request.auth != null;
    }
  }
}
```

---

## 8️⃣ CARACTERÍSTICAS TÉCNICAS AVANZADAS

### Sistema de Caché de IA

**Implementación:**

```dart
// 1. Generar hash SHA-1 de la imagen
final bytes = await imageFile.readAsBytes();
final hash = sha1.convert(bytes).toString();

// 2. Verificar si existe en caché
final cacheRef = FirebaseFirestore.instance
    .collection('ai_cache')
    .doc(hash);

final cached = await cacheRef.get();
if (cached.exists) {
  // Cache HIT → Retornar resultado guardado
  return AIAnalysisResult.fromMap(cached.data()!);
}

// 3. Cache MISS → Analizar con API y guardar
final result = await _analyzeWithGoogleVision(bytes);
await cacheRef.set(result.toMap());
```

**Beneficios:**
- ✅ Evita análisis duplicados
- ✅ Reduce costos de Google Vision API
- ✅ Mejora velocidad de respuesta
- ✅ Funciona aunque la API esté offline

---

### Stream-Based Real-Time Updates

**Implementación con StreamBuilder:**

```dart
StreamBuilder<QuerySnapshot>(
  stream: FirebaseFirestore.instance
      .collection('pets')
      .orderBy('createdAt', descending: true)
      .snapshots(),
  builder: (context, snapshot) {
    // UI se actualiza automáticamente
  },
)
```

**Ventajas:**
- ✅ Sin polling manual
- ✅ Actualización instantánea
- ✅ Menos código
- ✅ Eficiente en recursos

---

### Push Notifications con Deep Linking

**Flujo completo:**

1. **Cloud Function detecta nuevo mensaje**
2. **Envía notificación con payload:**
```json
{
  "notification": {
    "title": "Mensaje de Juan",
    "body": "Hola, me interesa tu mascota"
  },
  "data": {
    "chatId": "abc123",
    "senderId": "user456"
  }
}
```
3. **Usuario toca notificación**
4. **App navega directamente al chat:**
```dart
onDidReceiveNotificationResponse: (response) {
  if (response.payload != null) {
    final data = Uri.splitQueryString(response.payload!);
    navigatorKey.currentState?.pushNamed(
      '/chat',
      arguments: data['chatId'],
    );
  }
}
```

---

### Sistema de Vistas Recientes

**Implementación:**

```dart
// 1. Al abrir detalle de mascota, registrar vista
Future<void> _registerRecentView() async {
  final recentRef = FirebaseFirestore.instance
      .collection('users')
      .doc(currentUserId)
      .collection('recent_views')
      .doc(petId);

  await recentRef.set({
    'name': petData['name'],
    'status': petData['status'],
    'lastStatus': petData['status'],
    'viewedAt': FieldValue.serverTimestamp(),
  }, SetOptions(merge: true));
}

// 2. Stream detecta cambios de estado
Stream<int> get pendingStatusChangeNotifications {
  return recentRef.snapshots().asyncMap((recentSnap) async {
    int counter = 0;
    for (final doc in recentSnap.docs) {
      final petSnap = await FirebaseFirestore.instance
          .collection('pets')
          .doc(doc.id)
          .get();
      
      if (currentStatus != lastStatus) {
        counter++;
      }
    }
    return counter;
  });
}
```

---

## 9️⃣ RENDIMIENTO Y OPTIMIZACIÓN

### Compresión de Imágenes

```dart
final XFile? image = await picker.pickImage(
  source: ImageSource.gallery,
  imageQuality: 80,  // Compresión al 80%
);
```

**Beneficios:**
- ✅ Reduce tamaño de archivo ~60%
- ✅ Upload más rápido
- ✅ Menor uso de datos
- ✅ Ahorro en Firebase Storage

---

### Índices de Firestore

**Índices compuestos necesarios:**

```
Collection: chats
Fields: users (ARRAY_CONTAINS) + lastTimestamp (DESCENDING)
```

**Creación:**
- Automática al intentar query
- Firebase genera link en consola de error
- Crear en Firebase Console

---

### Lazy Loading Implícito

```dart
// Firestore solo carga lo visible
ListView.builder(
  itemCount: snapshot.data!.docs.length,
  itemBuilder: (context, index) {
    // Solo construye items visibles
  },
)
```

---

## 🔟 SEGURIDAD Y VALIDACIÓN

### Validación de Inputs

#### Email
```dart
email.trim()  // Eliminar espacios
// Firebase valida formato automáticamente
```

#### Teléfono
```dart
final formattedPhone = '+569${phoneController.text.trim()}';
// Guarda con prefijo +569
```

#### Descripción
```dart
description.trim()  // Evitar solo espacios
```

---

### Verificación de Permisos

```dart
// Solo el dueño puede editar/eliminar
if (currentUserId == post['userId']) {
  // Permitir edición
} else {
  // Mostrar error
}
```

---

### Sanitización

```dart
final sanitized = input.trim();  // Básico
// No hay sanitización HTML (no necesaria, sin rich text)
```

---

## 1️⃣1️⃣ RECURSOS Y ASSETS

### Imágenes

| Archivo | Ruta | Uso |
|---|---|---|
| `background.jpg` | `assets/images/background.jpg` | Fondo de login |
| `icon.png` | `assets/icon/icon.png` | Icono de launcher |

---

### Fuentes

**Google Fonts:**
```dart
import 'package:google_fonts/google_fonts.dart';

// Uso en ThemeData
theme: ThemeData(
  textTheme: GoogleFonts.poppinsTextTheme(),
)
```

**Fuentes incluidas:**
- Poppins (inferido, fuente común en Google Fonts)

---

### Colores

**Paleta definida en `AppColors`:**

```dart
class AppColors {
  static const Color primary = Color(0xFF6C5CE7);     // Morado
  static const Color accent = Color(0xFFF5F5F5);      // Gris claro
  static const Color background = Color(0xFFFFFFFF);  // Blanco
  static const Color textDark = Color(0xFF2D3436);    // Gris oscuro
  static const Color textLight = Color(0xFFFFFFFF);   // Blanco
}
```

**Hexadecimales:**
- Primary: #6C5CE7
- Accent: #F5F5F5
- Background: #FFFFFF
- Text Dark: #2D3436
- Text Light: #FFFFFF

---

## 1️⃣2️⃣ COMANDOS Y SCRIPTS

### Instalación

```bash
# 1. Clonar repositorio
git clone https://github.com/KZzual/PetHub_Proyect
cd PetHub_Proyect/Pethub-app/pethub

# 2. Instalar dependencias
flutter pub get

# 3. Configurar Firebase (manual)
# Añadir google-services.json a android/app/

# 4. Ejecutar
flutter run
```

---

### Compilación

```bash
# Debug APK
flutter build apk --debug

# Release APK
flutter build apk --release

# App Bundle (para Google Play)
flutter build appbundle --release
```

---

### Limpieza

```bash
# Limpiar build anterior
flutter clean

# Reinstalar dependencias
flutter pub get
```

---

### Firebase Functions

```bash
cd functions

# Instalar dependencias
npm install

# Desplegar función
firebase deploy --only functions

# Logs en vivo
firebase functions:log
```

---

### Generar Iconos

```bash
# Configurar en pubspec.yaml y ejecutar
flutter pub run flutter_launcher_icons
```

---

## 1️⃣3️⃣ CONFIGURACIÓN DE DESARROLLO

### IDE Recomendado

**Visual Studio Code:**
- Extensión: Dart
- Extensión: Flutter
- Extensión: Firebase

**Android Studio:**
- Flutter Plugin
- Dart Plugin

---

### Variables de Entorno

**Google Vision API Key:**
```dart
// Actualmente hardcoded en ai_service.dart
static const String _apiKey = 'AIzaSyBdgEMPJkFyDd7oqzsgMf72O9UutlvlOwU';

// ⚠️ RECOMENDACIÓN: Mover a archivo .env
```

---

### Emuladores

**Android Virtual Device (AVD):**
- API Level: 21+
- RAM: 2 GB mínimo
- Resolución: 1080x1920 (420dpi)

**Dispositivo Físico:**
- Android 5.0+
- USB Debugging habilitado
- Google Play Services instalado

---

## 1️⃣4️⃣ LIMITACIONES TÉCNICAS

### Actuales

1. **Sin modo offline:** Requiere internet para funcionar
2. **Solo mensajes de texto:** No soporta multimedia en chat
3. **Una imagen por publicación:** No hay galerías
4. **Sin compresión avanzada:** Solo imageQuality parameter
5. **API Key expuesta:** En código fuente (riesgo de seguridad)
6. **Sin testing automatizado:** Solo estructura básica
7. **Sin CI/CD:** Despliegue manual
8. **Español únicamente:** Sin i18n
9. **Android solo:** iOS no compilado

---

### Escalabilidad

**Límites de Firebase (Plan Spark):**
- Firestore: 50k lecturas/día
- Storage: 5 GB total
- Functions: 125k invocaciones/mes

**Para escalar se requiere:**
- Upgrade a plan Blaze (pay-as-you-go)
- Implementar paginación
- Optimizar queries
- CDN para imágenes

---

## 1️⃣5️⃣ RESUMEN DE TECNOLOGÍAS

| Categoría | Tecnología | Versión |
|---|---|---|
| **Frontend** | Flutter | 3.9.2+ |
| **Lenguaje** | Dart | 3.9.2+ |
| **Backend** | Firebase | - |
| **Base de Datos** | Cloud Firestore | 6.0.3 |
| **Autenticación** | Firebase Auth | 6.1.1 |
| **Storage** | Firebase Storage | 13.0.3 |
| **Messaging** | FCM | 16.0.4 |
| **Serverless** | Cloud Functions | Node.js 22 |
| **IA** | Google Vision API | v1 |
| **Notificaciones Locales** | Flutter Local Notifications | 17.2.1 |
| **HTTP Client** | http | 1.5.0 |
| **Image Processing** | image | 4.0.17 |
| **Crypto** | crypto | 3.0.3 |
| **Local Storage** | shared_preferences | 2.5.3 |
| **Fonts** | google_fonts | 6.3.2 |
| **WebView** | webview_flutter | 4.7.0 |

---

**Fecha de Análisis:** 30 de noviembre de 2025  
**Versión Analizada:** 1.4.0+1  
**Total de Dependencias:** 16 (production) + 3 (dev)  
**Total de Pantallas:** 16  
**Total de Servicios:** 5  
**Total de Widgets Personalizados:** 4
