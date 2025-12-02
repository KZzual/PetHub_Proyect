# ALCANCE DEL PROYECTO PETHUB

## 📐 Definición del Alcance

### DESCRIPCIÓN GENERAL DEL PROYECTO
PetHub es una aplicación móvil desarrollada con Flutter para la plataforma Android, que funciona como intermediario digital entre personas que desean dar en adopción o cuidado temporal a sus mascotas y potenciales adoptantes en la comuna de San Joaquín, Región Metropolitana de Chile.

---

## ✅ DENTRO DEL ALCANCE (In-Scope)

### 1. Plataformas y Dispositivos

#### 1.1 Plataformas Soportadas
- ✅ **Android:** Aplicación nativa compilada para dispositivos Android
- ✅ **Compatibilidad:** Android 5.0 (API 21) en adelante
- ✅ **Arquitectura:** Soporte para arm64-v8a, armeabi-v7a, x86_64

#### 1.2 Navegadores Web (Limitado)
- ✅ **Política de Privacidad:** Visualización web mediante WebView
- ✅ **Términos y Condiciones:** Visualización web mediante WebView
- ✅ **Archivos HTML públicos:** Hospedados en Firebase Hosting

---

### 2. Funcionalidades de Autenticación

#### 2.1 Registro de Usuarios
- ✅ Registro mediante correo electrónico y contraseña
- ✅ Verificación obligatoria de correo electrónico
- ✅ Validación de formato de email
- ✅ Creación automática de perfil en Firestore al registrarse
- ✅ Captura de datos básicos: nombre, teléfono (+569), email

#### 2.2 Inicio de Sesión
- ✅ Login con email y contraseña
- ✅ Opción "Recordarme" usando Shared Preferences
- ✅ Recuperación de contraseña mediante email
- ✅ Persistencia de sesión entre reinicios de app

#### 2.3 Gestión de Sesión
- ✅ Cierre de sesión seguro
- ✅ Verificación de estado de autenticación en tiempo real
- ✅ Redirección automática según estado de verificación de email

---

### 3. Gestión de Perfiles de Usuario

#### 3.1 Creación y Edición de Perfil
- ✅ Edición de datos personales: nombre, teléfono, comuna, descripción
- ✅ Selección de comuna de residencia (lista predefinida de 10 comunas de RM)
- ✅ Carga y actualización de foto de perfil
- ✅ Almacenamiento de foto en Firebase Storage
- ✅ Visualización de perfil propio y de otros usuarios

#### 3.2 Datos Almacenados por Usuario
- ✅ Información básica: name, email, phone, comuna
- ✅ Foto de perfil (photoUrl)
- ✅ Descripción personal
- ✅ Rol predefinido: "adoptante"
- ✅ Token FCM para notificaciones push
- ✅ Timestamp de creación (createdAt)

---

### 4. Publicación de Mascotas

#### 4.1 Creación de Publicaciones
- ✅ Formulario de publicación con campos obligatorios y opcionales:
  - Nombre de la mascota (obligatorio)
  - Especie: Perro o Gato (obligatorio)
  - Género: Macho o Hembra (obligatorio)
  - Raza (obligatorio)
  - Edad (obligatorio)
  - Ubicación (obligatorio)
  - Descripción (opcional, puede usar descripción generada por IA)
  - Foto (obligatorio)

#### 4.2 Análisis Inteligente con IA
- ✅ Integración con Google Cloud Vision API
- ✅ Detección automática si la imagen contiene un perro o gato
- ✅ Generación automática de descripción basada en etiquetas detectadas
- ✅ Validación de datos EXIF para verificar autenticidad de foto
- ✅ Sistema de caché en Firestore para evitar análisis duplicados (hash SHA-1)
- ✅ Feedback visual durante análisis (icono IA + mensaje)

#### 4.3 Gestión de Publicaciones Propias
- ✅ Visualización de historial de publicaciones del usuario
- ✅ Edición de publicaciones existentes
- ✅ Cambio de estado: "En Adopción" ↔ "Adoptado"
- ✅ Eliminación de publicaciones propias
- ✅ Confirmación de eliminación con diálogo

#### 4.4 Almacenamiento de Imágenes
- ✅ Subida de imágenes a Firebase Storage
- ✅ Nomenclatura única: `pet_photos/{userId}_{timestamp}.jpg`
- ✅ Eliminación automática de imagen al borrar publicación
- ✅ Selección desde galería o cámara del dispositivo
- ✅ Compresión de imagen (quality: 80%)

---

### 5. Búsqueda y Filtrado de Mascotas

#### 5.1 Búsqueda Textual
- ✅ Campo de búsqueda en tiempo real
- ✅ Búsqueda por nombre de mascota
- ✅ Búsqueda por raza
- ✅ Búsqueda case-insensitive

#### 5.2 Filtros Avanzados
- ✅ Filtro por especie: Todos / Perro / Gato
- ✅ Filtro por género: Todos / Macho / Hembra
- ✅ Modal de filtros con interfaz amigable
- ✅ Aplicación simultánea de múltiples filtros
- ✅ Feedback visual de filtros activos

#### 5.3 Visualización de Resultados
- ✅ Lista en formato cards (tarjetas) con imagen y datos clave
- ✅ Ordenamiento por fecha de creación (más reciente primero)
- ✅ Mensaje cuando no hay resultados
- ✅ Actualización en tiempo real mediante StreamBuilder

---

### 6. Detalle de Publicaciones

#### 6.1 Visualización de Detalle
- ✅ Pantalla completa con toda la información de la mascota
- ✅ Imagen de la mascota con efecto blur en fondo
- ✅ Información del dueño (nombre, foto)
- ✅ Datos de la mascota: especie, raza, género, edad, ubicación
- ✅ Descripción completa
- ✅ Estado actual (En Adopción / Adoptado)

#### 6.2 Acciones Desde Detalle
- ✅ Botón "Contactar" para iniciar conversación
- ✅ Navegación al perfil del dueño
- ✅ Registro automático de vista reciente
- ✅ Verificación de disponibilidad de mascota

---

### 7. Sistema de Mensajería

#### 7.1 Chat Uno-a-Uno
- ✅ Creación automática de chat al contactar por primera vez
- ✅ Interfaz de chat en tiempo real
- ✅ Envío y recepción de mensajes de texto
- ✅ Indicador visual de mensajes propios vs recibidos
- ✅ Scroll automático al enviar mensaje
- ✅ Timestamp de último mensaje

#### 7.2 Gestión de Conversaciones
- ✅ Lista de todas las conversaciones del usuario
- ✅ Ordenamiento por último mensaje (más reciente arriba)
- ✅ Vista previa del último mensaje
- ✅ Foto y nombre del otro participante
- ✅ Indicador de mensajes no leídos (badge con número)
- ✅ Marcado automático como leído al abrir chat

#### 7.3 Almacenamiento de Mensajes
- ✅ Colección principal: `chats`
- ✅ Subcolección por chat: `messages`
- ✅ Información de participantes en documento de chat
- ✅ Campo `lastMessage` y `lastTimestamp` en chat
- ✅ Campo `unreadCount` para contador de no leídos

---

### 8. Sistema de Notificaciones

#### 8.1 Notificaciones Push (FCM)
- ✅ Notificaciones de nuevos mensajes cuando app está cerrada
- ✅ Notificaciones cuando app está en background
- ✅ Firebase Cloud Functions para envío automático
- ✅ Almacenamiento de token FCM por usuario
- ✅ Actualización automática de token FCM
- ✅ Solicitud de permisos en Android 13+

#### 8.2 Notificaciones Locales
- ✅ Flutter Local Notifications para notificaciones en foreground
- ✅ Canal de alta importancia configurado
- ✅ Icono personalizado en notificación
- ✅ Navegación directa al chat al tocar notificación
- ✅ Payload con datos de chatId y senderId

#### 8.3 Notificaciones de Cambio de Estado
- ✅ Sistema de "vistas recientes" por usuario
- ✅ Detección automática de cambios de estado de mascotas vistas
- ✅ Página dedicada para notificaciones de estado
- ✅ Badge numérico en tab de notificaciones
- ✅ Stream en tiempo real de notificaciones pendientes

---

### 9. Interfaz de Usuario (UI/UX)

#### 9.1 Diseño Visual
- ✅ Sistema de colores personalizado (AppColors)
- ✅ Tipografía con Google Fonts
- ✅ Diseño Material Design
- ✅ Tema claro consistente
- ✅ Iconos personalizados de launcher

#### 9.2 Navegación
- ✅ Bottom Navigation Bar con 5 secciones:
  1. Inicio (feed de mascotas)
  2. Historial (publicaciones propias)
  3. Publicar (crear nueva publicación)
  4. Notificaciones (cambios de estado)
  5. Mensajes (conversaciones)
- ✅ AppBar personalizado por pantalla
- ✅ Navegación por push/pop entre pantallas
- ✅ GlobalKey para navegación desde notificaciones

#### 9.3 Componentes Reutilizables
- ✅ PetCard: Tarjeta de mascota
- ✅ PetFilterModal: Modal de filtros
- ✅ InfoChip: Chip de información
- ✅ ComunaSelector: Selector de comuna

#### 9.4 Feedback al Usuario
- ✅ SnackBars para mensajes de éxito/error
- ✅ CircularProgressIndicator durante carga
- ✅ Diálogos de confirmación para acciones críticas
- ✅ Animaciones de transición entre pantallas
- ✅ Estados vacíos con mensajes informativos

---

### 10. Backend Serverless

#### 10.1 Firebase Cloud Functions
- ✅ Función `notifyNewMessage`: Notificación automática de mensajes
- ✅ Trigger en creación de documento en `chats/{chatId}/messages/{msgId}`
- ✅ Envío de payload FCM con título, cuerpo y datos
- ✅ Incremento automático de contador `unreadCount`
- ✅ Node.js 22 como runtime

#### 10.2 Firebase Services
- ✅ **Firebase Authentication:** Gestión de usuarios
- ✅ **Cloud Firestore:** Base de datos NoSQL en tiempo real
- ✅ **Firebase Storage:** Almacenamiento de imágenes
- ✅ **Firebase Cloud Messaging:** Notificaciones push
- ✅ **Firebase Hosting:** Hospedaje de HTML públicos

---

### 11. Gestión de Datos

#### 11.1 Colecciones de Firestore
- ✅ **users:** Perfiles de usuario
  - Subcolección `recent_views`: Mascotas vistas recientemente
- ✅ **pets:** Publicaciones de mascotas
- ✅ **chats:** Conversaciones
  - Subcolección `messages`: Mensajes de cada chat
- ✅ **ai_cache:** Caché de análisis de IA (por hash de imagen)

#### 11.2 Operaciones en Tiempo Real
- ✅ StreamBuilder para actualización automática de UI
- ✅ Snapshots de Firestore sin polling manual
- ✅ Listeners activos mientras la app está abierta

---

### 12. Seguridad

#### 12.1 Validaciones
- ✅ Validación de campos obligatorios en formularios
- ✅ Trim de espacios en entradas de usuario
- ✅ Validación de formato de teléfono (+569)
- ✅ Verificación de email antes de acceso completo

#### 12.2 Autenticación y Autorización
- ✅ Solo usuarios autenticados pueden publicar/chatear
- ✅ Verificación de UID antes de operaciones críticas
- ✅ Usuarios solo pueden editar/eliminar sus propias publicaciones

---

### 13. Almacenamiento Local

#### 13.1 Shared Preferences
- ✅ Persistencia de estado de sesión
- ✅ Opción "Recordarme" en login
- ✅ Almacenamiento de preferencias del usuario

---

### 14. Configuración y Ajustes

#### 14.1 Página de Configuración
- ✅ Switch de notificaciones (UI, no funcional backend)
- ✅ Switch de modo oscuro (UI, no implementado)
- ✅ Acceso a Política de Privacidad
- ✅ Acceso a Términos y Condiciones
- ✅ Información de versión de la app

---

### 15. Geolocalización

#### 15.1 Selección de Comuna
- ✅ Lista predefinida de 10 comunas de la Región Metropolitana:
  - San Joaquín
  - La Florida
  - Macul
  - Ñuñoa
  - Santiago Centro
  - Providencia
  - La Cisterna
  - Maipú
  - Puente Alto
  - San Miguel

---

## ❌ FUERA DEL ALCANCE (Out-of-Scope)

### 1. Plataformas NO Soportadas
- ❌ **iOS:** No se desarrolla versión para iPhone/iPad
- ❌ **Web:** No hay versión web navegable completa (solo HTML estáticos)
- ❌ **Windows/macOS/Linux:** No se compila para escritorio
- ❌ **Tablets:** No hay diseño específico para tablets

---

### 2. Funcionalidades NO Implementadas

#### 2.1 Autenticación Avanzada
- ❌ Login con Google, Facebook, Apple
- ❌ Autenticación de dos factores (2FA)
- ❌ Biometría (huella, Face ID)
- ❌ Login anónimo
- ❌ Vinculación de múltiples proveedores

#### 2.2 Gestión de Usuarios
- ❌ Roles diferenciados (admin, moderador, etc.) - Solo "adoptante"
- ❌ Verificación de identidad real
- ❌ Sistema de reportes de usuarios
- ❌ Bloqueo de usuarios
- ❌ Lista de usuarios bloqueados
- ❌ Perfiles públicos/privados
- ❌ Seguimiento de usuarios (follow/unfollow)
- ❌ Sistema de reputación o puntuación

#### 2.3 Publicaciones Avanzadas
- ❌ Publicación de aves, reptiles, roedores u otras mascotas (solo perros/gatos)
- ❌ Múltiples imágenes por publicación (solo 1 foto)
- ❌ Videos de mascotas
- ❌ Galerías de fotos
- ❌ Edición de imagen dentro de la app (filtros, recorte)
- ❌ Publicaciones destacadas o premium
- ❌ Publicidad pagada

#### 2.4 Interacción Social
- ❌ Sistema de "me gusta" o reacciones
- ❌ Comentarios públicos en publicaciones
- ❌ Compartir publicaciones en redes sociales
- ❌ Guardado de favoritos/lista de deseos
- ❌ Compartir perfil de mascota por link
- ❌ Sistema de valoraciones o reviews

#### 2.5 Búsqueda y Filtros
- ❌ Filtro por ubicación geográfica con mapa
- ❌ Filtro por rango de edad
- ❌ Filtro por tamaño de mascota
- ❌ Filtro por color
- ❌ Búsqueda por características especiales (apto niños, apto departamento, etc.)
- ❌ Recomendaciones personalizadas con IA
- ❌ Búsqueda avanzada con múltiples criterios combinados

#### 2.6 Mensajería Avanzada
- ❌ Envío de imágenes en chat
- ❌ Envío de audio/video
- ❌ Videollamada
- ❌ Llamada de voz
- ❌ Compartir ubicación en tiempo real
- ❌ Mensajes con formato (negrita, cursiva, etc.)
- ❌ Eliminación de mensajes enviados
- ❌ Edición de mensajes
- ❌ Responder a mensaje específico (quote)
- ❌ Indicador de "escribiendo..."
- ❌ Confirmación de lectura (check azul)
- ❌ Cifrado end-to-end

#### 2.7 Notificaciones
- ❌ Notificaciones por email
- ❌ Notificaciones por SMS
- ❌ Configuración granular de notificaciones
- ❌ Horarios de silencio personalizados
- ❌ Notificaciones de mascotas similares a preferencias
- ❌ Recordatorios programados

#### 2.8 Geolocalización
- ❌ GPS en tiempo real
- ❌ Mapa interactivo con ubicación de mascotas
- ❌ Cálculo de distancia entre usuario y mascota
- ❌ Filtro por radio de distancia
- ❌ Direcciones exactas (solo comuna)

#### 2.9 Pagos y Monetización
- ❌ Sistema de pagos integrado
- ❌ Donaciones a refugios
- ❌ Planes premium/suscripciones
- ❌ Publicidad dentro de la app
- ❌ Compra de accesorios para mascotas

#### 2.10 Administración
- ❌ Panel de administración web
- ❌ Moderación de contenido
- ❌ Dashboard con estadísticas
- ❌ Reportes de actividad
- ❌ Gestión de usuarios desde panel admin
- ❌ Logs de auditoría

#### 2.11 Integraciones
- ❌ Integración con veterinarias
- ❌ Integración con tiendas de mascotas
- ❌ Integración con ONG's de rescate animal
- ❌ API pública para terceros
- ❌ Webhooks

#### 2.12 Funcionalidades Especiales
- ❌ Calendario de eventos de adopción
- ❌ Historial médico de mascotas
- ❌ Recordatorios de vacunas
- ❌ Tips de cuidado de mascotas
- ❌ Blog o artículos informativos
- ❌ Foro de la comunidad
- ❌ Programa de referidos
- ❌ Gamificación (logros, badges)

#### 2.13 Offline y Sincronización
- ❌ Modo offline completo
- ❌ Sincronización automática al recuperar conexión
- ❌ Caché de imágenes para visualización offline

#### 2.14 Accesibilidad
- ❌ Soporte completo de lectores de pantalla
- ❌ Modo de alto contraste
- ❌ Ajuste de tamaño de fuente
- ❌ Soporte de múltiples idiomas (solo español)

#### 2.15 Soporte Técnico
- ❌ Chat de soporte en vivo
- ❌ Sistema de tickets de soporte
- ❌ FAQ interactivo
- ❌ Tutoriales en video

---

## 🔄 LIMITACIONES Y RESTRICCIONES

### 1. Limitaciones Técnicas
- **Un solo idioma:** Español (Chile) únicamente
- **Una imagen por publicación:** No se soportan galerías
- **Solo texto en chat:** No se pueden enviar multimedia
- **Android únicamente:** No hay versión iOS
- **Dependencia de internet:** App requiere conexión activa para funcionar

### 2. Limitaciones Geográficas
- **Enfoque local:** Aplicación diseñada específicamente para San Joaquín
- **Comunas limitadas:** Solo 10 comunas de Región Metropolitana
- **Sin geolocalización precisa:** Solo selección manual de comuna

### 3. Limitaciones de Negocio
- **Sin verificación de adoptantes:** No hay proceso de validación formal
- **Sin seguimiento post-adopción:** No se rastrea qué pasó con la mascota
- **Sin garantías legales:** La app no gestiona contratos de adopción
- **Sin respaldo veterinario:** No hay validación médica de mascotas

### 4. Limitaciones de IA
- **Solo perros y gatos:** Google Vision solo entrena para estas especies
- **Detección básica:** No identifica razas específicas automáticamente
- **Descripciones genéricas:** IA genera texto simple basado en etiquetas
- **Dependencia de API externa:** Requiere clave de Google Cloud Vision

---

## 📊 MÉTRICAS DEL ALCANCE

| Categoría | Dentro del Alcance | Fuera del Alcance |
|-----------|-------------------|-------------------|
| **Plataformas** | 1 (Android) | 4 (iOS, Web, Windows, macOS) |
| **Pantallas Principales** | 16 | - |
| **Servicios Firebase** | 5 | 3 (Analytics, Crashlytics, Remote Config) |
| **Tipos de Mascotas** | 2 (Perro, Gato) | 5+ (Ave, Reptil, Roedor, etc.) |
| **Métodos de Login** | 1 (Email/Password) | 4+ (Google, Facebook, etc.) |
| **Idiomas** | 1 (Español) | 10+ |
| **Funcionalidades Core** | 14 categorías | 15 categorías |

---

## 🎯 ENTREGABLES INCLUIDOS

### Código y Repositorio
- ✅ Código fuente completo en Dart/Flutter
- ✅ Configuración de Firebase
- ✅ Cloud Functions (Node.js)
- ✅ Archivos HTML públicos
- ✅ README con instrucciones de instalación

### Diseño
- ✅ Sistema de colores documentado
- ✅ Componentes reutilizables
- ✅ Iconos de launcher personalizados

### Documentación Implícita
- ✅ Código comentado en secciones clave
- ✅ Estructura de carpetas organizada por features
- ✅ Servicios modularizados

---

## 📅 VERSIÓN Y ALCANCE TEMPORAL

- **Versión Actual:** 1.4.0+1
- **Estado:** En producción/desarrollo activo
- **Alcance Temporal:** Proyecto académico (Capstone)
- **Mantenimiento Futuro:** No especificado

---

**Fecha de Análisis:** 30 de noviembre de 2025  
**Documento:** Alcance del Proyecto PetHub  
**Autor del Análisis:** GitHub Copilot con Claude Sonnet 4.5
