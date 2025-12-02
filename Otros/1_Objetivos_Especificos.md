# OBJETIVOS ESPECÍFICOS DEL PROYECTO PETHUB

## 📋 Análisis de Objetivos del Proyecto

### OBJETIVO GENERAL
Desarrollar una aplicación móvil multiplataforma que facilite la adopción y cuidado temporal de mascotas en la comuna de San Joaquín, mediante el uso de tecnologías Firebase y Flutter, proporcionando una plataforma segura, intuitiva y eficiente para conectar adoptantes con mascotas en búsqueda de hogar.

---

## 🎯 OBJETIVOS ESPECÍFICOS

### 1. Gestión de Usuarios y Autenticación
**OE-01:** Implementar un sistema de autenticación seguro utilizando Firebase Authentication que permita el registro, inicio de sesión y recuperación de contraseñas de usuarios mediante correo electrónico y contraseña.

**OE-02:** Desarrollar un sistema de verificación de correo electrónico obligatorio para garantizar la autenticidad de los usuarios registrados en la plataforma.

**OE-03:** Crear perfiles de usuario personalizables que incluyan información básica (nombre, teléfono, comuna, foto de perfil) y descripción personal almacenada en Cloud Firestore.

---

### 2. Publicación y Gestión de Mascotas

**OE-04:** Diseñar e implementar un módulo de creación de publicaciones de mascotas que incluya campos obligatorios como nombre, especie, raza, género, edad, ubicación y fotografía.

**OE-05:** Integrar Google Cloud Vision API para análisis automático de imágenes de mascotas, detectando si la imagen corresponde a un animal doméstico (perro o gato) y generando descripciones automáticas basadas en etiquetas detectadas.

**OE-06:** Implementar un sistema de validación EXIF para verificar la autenticidad de las fotografías cargadas y prevenir el uso de imágenes descargadas de internet.

**OE-07:** Desarrollar funcionalidades de edición y eliminación de publicaciones propias, permitiendo a los usuarios mantener actualizada la información de sus mascotas.

**OE-08:** Implementar un sistema de estados de publicación (En Adopción / Adoptado) para reflejar la disponibilidad actual de cada mascota.

---

### 3. Búsqueda y Filtrado de Publicaciones

**OE-09:** Crear un sistema de búsqueda en tiempo real que permita a los usuarios buscar mascotas por nombre o raza mediante un campo de texto.

**OE-10:** Implementar filtros avanzados que permitan la clasificación de publicaciones por especie (Perro/Gato/Todos) y género (Macho/Hembra/Todos).

**OE-11:** Desarrollar una interfaz de usuario intuitiva que muestre las publicaciones de mascotas en formato de tarjetas (cards) con información relevante y fotografía.

**OE-12:** Implementar ordenamiento cronológico de publicaciones mostrando las más recientes primero mediante consultas ordenadas de Firestore.

---

### 4. Sistema de Mensajería en Tiempo Real

**OE-13:** Desarrollar un sistema de chat privado uno-a-uno entre usuarios interesados en adoptar y dueños de mascotas publicadas.

**OE-14:** Implementar la creación automática de conversaciones cuando un usuario contacta al dueño de una publicación por primera vez.

**OE-15:** Diseñar una interfaz de mensajería que muestre en tiempo real los mensajes enviados y recibidos mediante Firestore Snapshots.

**OE-16:** Crear un historial de conversaciones que persista información de participantes, último mensaje enviado y timestamp.

---

### 5. Sistema de Notificaciones Push

**OE-17:** Integrar Firebase Cloud Messaging (FCM) para el envío de notificaciones push a dispositivos Android.

**OE-18:** Implementar Firebase Cloud Functions para detectar automáticamente nuevos mensajes en conversaciones y enviar notificaciones al receptor cuando esté offline.

**OE-19:** Desarrollar notificaciones locales mediante Flutter Local Notifications para mostrar alertas cuando la aplicación esté en primer plano.

**OE-20:** Crear un sistema de navegación profunda (deep linking) que permita a los usuarios acceder directamente a una conversación específica al presionar una notificación.

**OE-21:** Implementar contador de mensajes no leídos por conversación, incrementándose automáticamente mediante Cloud Functions y resetándose al abrir el chat.

---

### 6. Sistema de Notificaciones de Cambio de Estado

**OE-22:** Desarrollar un sistema que registre las publicaciones vistas por cada usuario en una subcolección personal de Firestore.

**OE-23:** Implementar detección automática de cambios de estado (Adopción ↔ En búsqueda) de publicaciones previamente vistas por el usuario.

**OE-24:** Crear una página de notificaciones que muestre en tiempo real los cambios de estado de mascotas de interés del usuario.

**OE-25:** Diseñar un indicador visual (badge) en la barra de navegación que muestre el número de notificaciones pendientes.

---

### 7. Gestión de Almacenamiento en la Nube

**OE-26:** Implementar Firebase Storage para almacenar imágenes de mascotas con nomenclatura única basada en timestamp y ID de usuario.

**OE-27:** Desarrollar funcionalidad de compresión automática de imágenes antes de subir a Storage para optimizar uso de datos y almacenamiento.

**OE-28:** Implementar almacenamiento de fotos de perfil de usuarios en rutas específicas de Firebase Storage.

**OE-29:** Crear sistema de caché de análisis de IA en Firestore utilizando hash SHA-1 de imágenes para evitar análisis duplicados y reducir costos de API.

---

### 8. Interfaz de Usuario y Experiencia (UI/UX)

**OE-30:** Diseñar una interfaz visual consistente aplicando un sistema de colores personalizado basado en paleta definida (AppColors).

**OE-31:** Implementar Google Fonts (específicamente fuentes personalizadas) para mejorar la tipografía y legibilidad de la aplicación.

**OE-32:** Desarrollar animaciones y transiciones fluidas utilizando widgets AnimatedContainer, AnimatedSwitcher y Hero para mejorar la experiencia del usuario.

**OE-33:** Crear componentes reutilizables (widgets) como PetCard, PetFilterModal, InfoChip y ComunaSelector para mantener consistencia visual.

**OE-34:** Implementar navegación mediante Bottom Navigation Bar con 5 secciones principales: Inicio, Historial, Publicar, Notificaciones y Mensajes.

**OE-35:** Diseñar pantallas responsivas que se adapten a diferentes tamaños de pantalla Android.

---

### 9. Contenido Legal y Transparencia

**OE-36:** Desarrollar e integrar Política de Privacidad accesible desde la aplicación mediante WebView.

**OE-37:** Crear y publicar Términos y Condiciones de uso de la plataforma, accesibles desde configuración.

**OE-38:** Implementar rutas web públicas (privacy-policy.html, terms-conditions.html) hospedadas en Firebase Hosting.

---

### 10. Persistencia Local y Gestión de Sesiones

**OE-39:** Implementar Shared Preferences para mantener la sesión activa del usuario entre reinicios de la aplicación.

**OE-40:** Desarrollar funcionalidad "Recordarme" en inicio de sesión para mejorar la experiencia del usuario.

**OE-41:** Crear sistema de cierre de sesión que limpie tanto la autenticación de Firebase como las preferencias locales.

---

### 11. Optimización y Rendimiento

**OE-42:** Implementar StreamBuilder para actualización en tiempo real de datos sin recargar la aplicación manualmente.

**OE-43:** Utilizar paginación implícita mediante snapshots de Firestore para optimizar carga de publicaciones.

**OE-44:** Implementar manejo de errores robusto con mensajes informativos al usuario mediante SnackBars.

**OE-45:** Desarrollar indicadores de carga (CircularProgressIndicator) durante operaciones asíncronas para mejorar feedback al usuario.

---

### 12. Seguridad y Validación

**OE-46:** Implementar validación de campos obligatorios en formularios de registro y publicación.

**OE-47:** Desarrollar sanitización de entradas de usuario (trim) para prevenir errores por espacios innecesarios.

**OE-48:** Crear sistema de permisos de Firebase Security Rules para proteger colecciones de datos (users, pets, chats).

**OE-49:** Implementar validación de formato de teléfono con prefijo +569 para estandarizar datos de contacto.

---

### 13. Integración de Servicios Externos

**OE-50:** Integrar Google Cloud Vision API para análisis inteligente de imágenes de mascotas.

**OE-51:** Implementar solicitud de permisos de notificaciones en tiempo de ejecución para Android 13+.

**OE-52:** Desarrollar configuración multiplataforma de Firebase mediante FlutterFire CLI.

---

### 14. Despliegue y Distribución

**OE-53:** Configurar compilación de APK release para distribución Android.

**OE-54:** Implementar sistema de versionado semántico (versión 1.4.0+1).

**OE-55:** Generar iconos de lanzador personalizados para Android usando flutter_launcher_icons.

**OE-56:** Preparar infraestructura de Firebase Cloud Functions con Node.js 22 para backend serverless.

---

## 📊 Resumen Cuantitativo

- **Total de Objetivos Específicos:** 56
- **Categorías Principales:** 14
- **Tecnologías Integradas:** 12+ (Flutter, Firebase Auth, Firestore, Storage, Functions, Messaging, Cloud Vision, etc.)
- **Pantallas/Módulos Principales:** 16

---

## 🔄 Alineación con Metodología Tradicional

Los objetivos específicos están estructurados siguiendo una metodología de desarrollo tradicional en cascada:

1. **Requisitos** → Definición clara de funcionalidades (OE-01 a OE-08)
2. **Diseño** → Arquitectura de servicios y UI/UX (OE-30 a OE-35)
3. **Implementación** → Desarrollo modular por componentes (OE-09 a OE-29)
4. **Pruebas** → Validación y manejo de errores (OE-46 a OE-49)
5. **Despliegue** → Distribución y versionado (OE-53 a OE-56)

---

**Fecha de Análisis:** 30 de noviembre de 2025  
**Versión del Proyecto Analizada:** 1.4.0+1  
**Nombre del Proyecto:** PetHub - Aplicación de Adopción de Mascotas
