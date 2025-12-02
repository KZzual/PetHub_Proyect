# REQUERIMIENTOS FUNCIONALES Y NO FUNCIONALES - PETHUB

## 📋 Tabla de Contenidos
1. [Requerimientos Funcionales (RF)](#requerimientos-funcionales)
2. [Requerimientos No Funcionales (RNF)](#requerimientos-no-funcionales)

---

## REQUERIMIENTOS FUNCIONALES

Los requerimientos funcionales describen las funcionalidades específicas que el sistema debe proporcionar a los usuarios.

### 🔐 Autenticación y Gestión de Usuarios

| ID | Nombre | Sub-tipo | Tipo | Descripción |
|---|---|---|---|---|
| RF-0001 | Registro de usuario con correo electrónico | Requerimiento de Usuario | Funcional | Permitir crear cuenta usando email y contraseña. |
| RF-0002 | Validación de formato de correo electrónico | Requerimiento de Sistema | Funcional | El sistema debe validar que el email tenga formato válido antes de registrar. |
| RF-0003 | Envío automático de correo de verificación | Requerimiento de Sistema | Funcional | Al registrarse, enviar automáticamente email de verificación a la dirección proporcionada. |
| RF-0004 | Verificación obligatoria de correo | Requerimiento de Negocio | Funcional | El usuario debe verificar su correo antes de acceder completamente a la aplicación. |
| RF-0005 | Inicio de sesión con credenciales | Requerimiento de Usuario | Funcional | Permitir login con email y contraseña previamente registrados. |
| RF-0006 | Opción "Recordarme" en login | Requerimiento de Usuario | Funcional | Mantener sesión activa entre reinicios de app si el usuario lo selecciona. |
| RF-0007 | Recuperación de contraseña | Requerimiento de Usuario | Funcional | Enviar email con enlace para restablecer contraseña olvidada. |
| RF-0008 | Cierre de sesión | Requerimiento de Usuario | Funcional | Permitir al usuario cerrar sesión manualmente desde configuración. |
| RF-0009 | Persistencia de sesión | Requerimiento de Sistema | Funcional | Mantener sesión activa usando Firebase Auth y Shared Preferences. |
| RF-0010 | Redirección según estado de verificación | Requerimiento de Sistema | Funcional | Redirigir a pantalla de verificación si email no está confirmado. |

---

### 👤 Gestión de Perfiles

| ID | Nombre | Sub-tipo | Tipo | Descripción |
|---|---|---|---|---|
| RF-0011 | Creación automática de perfil en Firestore | Requerimiento de Sistema | Funcional | Al registrarse, crear documento de usuario en colección 'users'. |
| RF-0012 | Edición de nombre de usuario | Requerimiento de Usuario | Funcional | Permitir cambiar el nombre del perfil desde editar perfil. |
| RF-0013 | Edición de número de teléfono | Requerimiento de Usuario | Funcional | Permitir actualizar teléfono con formato +569 XXXXXXXX. |
| RF-0014 | Selección de comuna de residencia | Requerimiento de Usuario | Funcional | Seleccionar comuna desde lista predefinida de 10 comunas RM. |
| RF-0015 | Carga de foto de perfil | Requerimiento de Usuario | Funcional | Subir imagen de perfil desde galería del dispositivo. |
| RF-0016 | Almacenamiento de foto en Storage | Requerimiento de Sistema | Funcional | Guardar foto en Firebase Storage con ruta `profile_photos/{uid}.jpg`. |
| RF-0017 | Actualización de descripción personal | Requerimiento de Usuario | Funcional | Escribir y guardar descripción de texto libre en el perfil. |
| RF-0018 | Visualización de perfil propio | Requerimiento de Usuario | Funcional | Ver datos completos del perfil propio con opción de editar. |
| RF-0019 | Visualización de perfil de otros usuarios | Requerimiento de Usuario | Funcional | Visualizar perfil público de otros usuarios sin opción de editar. |
| RF-0020 | Almacenamiento de token FCM | Requerimiento de Sistema | Funcional | Guardar token FCM del dispositivo para notificaciones push. |

---

### 🐾 Publicación de Mascotas

| ID | Nombre | Sub-tipo | Tipo | Descripción |
|---|---|---|---|---|
| RF-0021 | Creación de publicación de mascota | Requerimiento de Usuario | Funcional | Permitir crear nueva publicación con formulario completo. |
| RF-0022 | Campo obligatorio: Nombre de mascota | Requerimiento de Negocio | Funcional | El nombre de la mascota debe ser obligatorio. |
| RF-0023 | Selección de especie (Perro/Gato) | Requerimiento de Usuario | Funcional | Seleccionar especie mediante botones de opción. |
| RF-0024 | Selección de género (Macho/Hembra) | Requerimiento de Usuario | Funcional | Seleccionar género mediante toggle buttons. |
| RF-0025 | Campo obligatorio: Raza | Requerimiento de Negocio | Funcional | La raza debe ser campo obligatorio de texto. |
| RF-0026 | Campo obligatorio: Edad | Requerimiento de Negocio | Funcional | La edad debe ser campo obligatorio. |
| RF-0027 | Campo obligatorio: Ubicación | Requerimiento de Negocio | Funcional | La ubicación debe ser campo obligatorio. |
| RF-0028 | Campo opcional: Descripción | Requerimiento de Usuario | Funcional | Permitir descripción manual opcional. |
| RF-0029 | Carga de foto de mascota | Requerimiento de Usuario | Funcional | Subir una imagen desde galería o cámara. |
| RF-0030 | Selección de fuente de imagen | Requerimiento de Usuario | Funcional | Mostrar modal para elegir entre galería o cámara. |
| RF-0031 | Análisis de imagen con Google Vision | Requerimiento de Sistema | Funcional | Enviar imagen a Google Cloud Vision API para análisis. |
| RF-0032 | Detección de tipo de mascota con IA | Requerimiento de Sistema | Funcional | Identificar si la imagen contiene perro o gato. |
| RF-0033 | Generación automática de descripción con IA | Requerimiento de Sistema | Funcional | Crear descripción basada en etiquetas detectadas por Vision API. |
| RF-0034 | Validación de datos EXIF | Requerimiento de Sistema | Funcional | Verificar autenticidad de foto mediante metadatos EXIF. |
| RF-0035 | Feedback visual durante análisis IA | Requerimiento de Usuario | Funcional | Mostrar indicador de carga y mensaje de análisis en progreso. |
| RF-0036 | Sistema de caché de análisis IA | Requerimiento de Sistema | Funcional | Cachear resultados de análisis usando hash SHA-1 en Firestore. |
| RF-0037 | Almacenamiento de imagen en Storage | Requerimiento de Sistema | Funcional | Subir imagen a ruta `pet_photos/{userId}_{timestamp}.jpg`. |
| RF-0038 | Compresión de imagen antes de subir | Requerimiento de Sistema | Funcional | Comprimir imagen con quality 80% antes de almacenar. |
| RF-0039 | Almacenamiento de publicación en Firestore | Requerimiento de Sistema | Funcional | Guardar documento en colección 'pets' con todos los campos. |
| RF-0040 | Timestamp de creación de publicación | Requerimiento de Sistema | Funcional | Registrar fecha/hora de creación automáticamente. |

---

### 📝 Gestión de Publicaciones Propias

| ID | Nombre | Sub-tipo | Tipo | Descripción |
|---|---|---|---|---|
| RF-0041 | Visualización de historial de publicaciones | Requerimiento de Usuario | Funcional | Mostrar lista de todas las publicaciones propias del usuario. |
| RF-0042 | Edición de publicación existente | Requerimiento de Usuario | Funcional | Permitir modificar datos de publicación propia. |
| RF-0043 | Cambio de estado a "Adoptado" | Requerimiento de Usuario | Funcional | Marcar mascota como adoptada mediante toggle. |
| RF-0044 | Cambio de estado a "En Adopción" | Requerimiento de Usuario | Funcional | Volver a marcar como disponible si se cancela adopción. |
| RF-0045 | Eliminación de publicación | Requerimiento de Usuario | Funcional | Borrar completamente una publicación propia. |
| RF-0046 | Confirmación antes de eliminar | Requerimiento de Usuario | Funcional | Mostrar diálogo de confirmación antes de borrar. |
| RF-0047 | Eliminación de imagen al borrar publicación | Requerimiento de Sistema | Funcional | Borrar imagen de Storage cuando se elimina publicación. |
| RF-0048 | Actualización de imagen en edición | Requerimiento de Usuario | Funcional | Permitir cambiar imagen de mascota al editar. |
| RF-0049 | Preservación de datos al editar | Requerimiento de Sistema | Funcional | Mantener datos existentes si no se modifican. |
| RF-0050 | Validación de permisos de edición | Requerimiento de Sistema | Funcional | Solo el dueño puede editar/eliminar su publicación. |

---

### 🔍 Búsqueda y Filtrado

| ID | Nombre | Sub-tipo | Tipo | Descripción |
|---|---|---|---|---|
| RF-0051 | Búsqueda por nombre de mascota | Requerimiento de Usuario | Funcional | Buscar en tiempo real por nombre ingresado. |
| RF-0052 | Búsqueda por raza | Requerimiento de Usuario | Funcional | Buscar mascotas por raza especificada. |
| RF-0053 | Búsqueda case-insensitive | Requerimiento de Sistema | Funcional | Ignorar mayúsculas/minúsculas en búsqueda. |
| RF-0054 | Búsqueda en tiempo real | Requerimiento de Sistema | Funcional | Actualizar resultados automáticamente al escribir. |
| RF-0055 | Filtro por especie (Todos/Perro/Gato) | Requerimiento de Usuario | Funcional | Filtrar publicaciones por tipo de animal. |
| RF-0056 | Filtro por género (Todos/Macho/Hembra) | Requerimiento de Usuario | Funcional | Filtrar publicaciones por sexo del animal. |
| RF-0057 | Aplicación simultánea de múltiples filtros | Requerimiento de Sistema | Funcional | Combinar búsqueda de texto + especie + género. |
| RF-0058 | Modal de filtros avanzados | Requerimiento de Usuario | Funcional | Mostrar bottom sheet con opciones de filtrado. |
| RF-0059 | Botón aplicar filtros | Requerimiento de Usuario | Funcional | Confirmar selección de filtros y cerrar modal. |
| RF-0060 | Indicador visual de filtros activos | Requerimiento de Usuario | Funcional | Mostrar cuántos filtros están aplicados. |

---

### 📋 Visualización de Publicaciones

| ID | Nombre | Sub-tipo | Tipo | Descripción |
|---|---|---|---|---|
| RF-0061 | Feed principal de mascotas | Requerimiento de Usuario | Funcional | Mostrar lista de todas las publicaciones en home. |
| RF-0062 | Formato de tarjetas (cards) | Requerimiento de Usuario | Funcional | Visualizar cada publicación como card con imagen y datos clave. |
| RF-0063 | Ordenamiento por fecha descendente | Requerimiento de Sistema | Funcional | Mostrar publicaciones más recientes primero. |
| RF-0064 | Actualización en tiempo real del feed | Requerimiento de Sistema | Funcional | Usar StreamBuilder para refrescar automáticamente. |
| RF-0065 | Visualización de imagen de mascota | Requerimiento de Usuario | Funcional | Mostrar foto principal en cada card. |
| RF-0066 | Visualización de nombre y raza | Requerimiento de Usuario | Funcional | Mostrar nombre y raza en card. |
| RF-0067 | Visualización de especie y género | Requerimiento de Usuario | Funcional | Mostrar especie y género con iconos. |
| RF-0068 | Mensaje cuando no hay resultados | Requerimiento de Usuario | Funcional | Mostrar texto informativo si filtros no retornan mascotas. |
| RF-0069 | Indicador de carga | Requerimiento de Usuario | Funcional | Mostrar CircularProgressIndicator mientras carga datos. |
| RF-0070 | Navegación a detalle al tocar card | Requerimiento de Usuario | Funcional | Abrir pantalla de detalle al presionar una publicación. |

---

### 📱 Detalle de Publicación

| ID | Nombre | Sub-tipo | Tipo | Descripción |
|---|---|---|---|---|
| RF-0071 | Pantalla de detalle completo | Requerimiento de Usuario | Funcional | Mostrar toda la información de la mascota. |
| RF-0072 | Imagen de mascota en pantalla completa | Requerimiento de Usuario | Funcional | Visualizar foto con efecto blur en fondo. |
| RF-0073 | Información del dueño | Requerimiento de Usuario | Funcional | Mostrar nombre y foto del publicador. |
| RF-0074 | Datos completos de la mascota | Requerimiento de Usuario | Funcional | Mostrar especie, raza, género, edad, ubicación. |
| RF-0075 | Descripción completa | Requerimiento de Usuario | Funcional | Visualizar descripción manual o generada por IA. |
| RF-0076 | Indicador de estado de adopción | Requerimiento de Usuario | Funcional | Mostrar si está "En Adopción" o "Adoptado". |
| RF-0077 | Botón "Contactar" | Requerimiento de Usuario | Funcional | Permitir iniciar conversación con el dueño. |
| RF-0078 | Deshabilitación de contacto si adoptado | Requerimiento de Sistema | Funcional | Deshabilitar botón contactar si mascota está adoptada. |
| RF-0079 | Navegación a perfil del dueño | Requerimiento de Usuario | Funcional | Permitir ver perfil completo del publicador. |
| RF-0080 | Registro automático de vista reciente | Requerimiento de Sistema | Funcional | Guardar en subcolección recent_views al entrar a detalle. |

---

### 💬 Sistema de Mensajería

| ID | Nombre | Sub-tipo | Tipo | Descripción |
|---|---|---|---|---|
| RF-0081 | Creación automática de chat | Requerimiento de Sistema | Funcional | Crear documento de chat al contactar por primera vez. |
| RF-0082 | Verificación de chat existente | Requerimiento de Sistema | Funcional | Buscar si ya existe conversación antes de crear nueva. |
| RF-0083 | Envío de mensajes de texto | Requerimiento de Usuario | Funcional | Permitir escribir y enviar mensaje en chat. |
| RF-0084 | Recepción de mensajes en tiempo real | Requerimiento de Sistema | Funcional | Mostrar mensajes nuevos automáticamente sin refrescar. |
| RF-0085 | Diferenciación visual mensajes propios/ajenos | Requerimiento de Usuario | Funcional | Distinguir mensajes enviados de recibidos por color/alineación. |
| RF-0086 | Scroll automático a último mensaje | Requerimiento de Usuario | Funcional | Desplazarse al final al enviar mensaje. |
| RF-0087 | Timestamp de mensajes | Requerimiento de Sistema | Funcional | Registrar fecha/hora de cada mensaje. |
| RF-0088 | Almacenamiento en subcolección messages | Requerimiento de Sistema | Funcional | Guardar mensajes en chats/{chatId}/messages/. |
| RF-0089 | Actualización de último mensaje en chat | Requerimiento de Sistema | Funcional | Actualizar campo lastMessage del documento chat. |
| RF-0090 | Lista de conversaciones | Requerimiento de Usuario | Funcional | Mostrar todas las conversaciones del usuario. |

---

### 📬 Gestión de Conversaciones

| ID | Nombre | Sub-tipo | Tipo | Descripción |
|---|---|---|---|---|
| RF-0091 | Ordenamiento por último mensaje | Requerimiento de Sistema | Funcional | Ordenar chats por lastTimestamp descendente. |
| RF-0092 | Vista previa de último mensaje | Requerimiento de Usuario | Funcional | Mostrar texto del último mensaje en lista. |
| RF-0093 | Foto y nombre del otro participante | Requerimiento de Usuario | Funcional | Visualizar avatar y nombre del contacto. |
| RF-0094 | Contador de mensajes no leídos | Requerimiento de Usuario | Funcional | Mostrar badge con número de mensajes sin leer. |
| RF-0095 | Marcado automático como leído | Requerimiento de Sistema | Funcional | Marcar mensajes como vistos al abrir chat. |
| RF-0096 | Reseteo de contador al abrir | Requerimiento de Sistema | Funcional | Poner unreadCount en 0 al entrar al chat. |
| RF-0097 | Información de participantes en chat | Requerimiento de Sistema | Funcional | Almacenar datos de ambos usuarios en documento chat. |
| RF-0098 | Navegación a chat desde lista | Requerimiento de Usuario | Funcional | Abrir chat al presionar conversación. |
| RF-0099 | Formato de timestamp legible | Requerimiento de Usuario | Funcional | Mostrar fecha/hora en formato amigable. |
| RF-0100 | Mensaje cuando no hay conversaciones | Requerimiento de Usuario | Funcional | Mostrar texto informativo si lista está vacía. |

---

## REQUERIMIENTOS NO FUNCIONALES

Los requerimientos no funcionales describen características de calidad, rendimiento, seguridad y usabilidad del sistema.

### ⚡ Rendimiento

| ID | Nombre | Sub-tipo | Tipo | Descripción |
|---|---|---|---|---|
| RNF-0001 | Tiempo de carga de feed < 3 segundos | Requerimiento de Rendimiento | No Funcional | El feed principal debe cargar en menos de 3 segundos con conexión 4G. |
| RNF-0002 | Actualización en tiempo real | Requerimiento de Rendimiento | No Funcional | Cambios en Firestore deben reflejarse en UI en menos de 1 segundo. |
| RNF-0003 | Compresión de imágenes | Requerimiento de Rendimiento | No Funcional | Imágenes deben comprimirse a 80% quality antes de subir. |
| RNF-0004 | Caché de análisis IA | Requerimiento de Rendimiento | No Funcional | Resultados de Vision API deben cachearse para evitar análisis duplicados. |
| RNF-0005 | Uso eficiente de StreamBuilder | Requerimiento de Rendimiento | No Funcional | Usar streams solo donde sea necesario tiempo real. |
| RNF-0006 | Lazy loading de imágenes | Requerimiento de Rendimiento | No Funcional | Cargar imágenes bajo demanda según scroll. |
| RNF-0007 | Tiempo de respuesta de búsqueda | Requerimiento de Rendimiento | No Funcional | Resultados de búsqueda deben aparecer instantáneamente. |
| RNF-0008 | Optimización de consultas Firestore | Requerimiento de Rendimiento | No Funcional | Limitar queries a campos indexados. |
| RNF-0009 | Tamaño máximo de imagen | Requerimiento de Rendimiento | No Funcional | Imágenes no deben exceder 5 MB. |
| RNF-0010 | Consumo de datos moderado | Requerimiento de Rendimiento | No Funcional | App debe consumir menos de 50 MB por sesión promedio. |

---

### 🔒 Seguridad

| ID | Nombre | Sub-tipo | Tipo | Descripción |
|---|---|---|---|---|
| RNF-0011 | Autenticación obligatoria | Requerimiento de Seguridad | No Funcional | Usuario debe estar autenticado para acceder a funciones principales. |
| RNF-0012 | Verificación de email obligatoria | Requerimiento de Seguridad | No Funcional | Email debe estar verificado para publicar o chatear. |
| RNF-0013 | Cifrado de contraseñas | Requerimiento de Seguridad | No Funcional | Firebase Auth debe cifrar contraseñas con bcrypt. |
| RNF-0014 | Comunicación HTTPS | Requerimiento de Seguridad | No Funcional | Todas las comunicaciones con Firebase deben usar HTTPS. |
| RNF-0015 | Validación de permisos de edición | Requerimiento de Seguridad | No Funcional | Solo el dueño puede modificar/eliminar su contenido. |
| RNF-0016 | Token FCM seguro | Requerimiento de Seguridad | No Funcional | Tokens FCM deben almacenarse de forma segura. |
| RNF-0017 | Firestore Security Rules | Requerimiento de Seguridad | No Funcional | Implementar reglas de seguridad para proteger colecciones. |
| RNF-0018 | Sanitización de inputs | Requerimiento de Seguridad | No Funcional | Aplicar trim y validación a todas las entradas de usuario. |
| RNF-0019 | Almacenamiento seguro en Storage | Requerimiento de Seguridad | No Funcional | Firebase Storage debe tener reglas de acceso configuradas. |
| RNF-0020 | Expiración de sesión | Requerimiento de Seguridad | No Funcional | Sesiones inactivas deben expirar según políticas de Firebase. |

---

### 🎨 Usabilidad

| ID | Nombre | Sub-tipo | Tipo | Descripción |
|---|---|---|---|---|
| RNF-0021 | Interfaz intuitiva | Requerimiento de Usabilidad | No Funcional | Usuario nuevo debe entender la app sin tutorial. |
| RNF-0022 | Consistencia visual | Requerimiento de Usabilidad | No Funcional | Aplicar sistema de colores AppColors en toda la app. |
| RNF-0023 | Tipografía legible | Requerimiento de Usabilidad | No Funcional | Usar Google Fonts con tamaños mínimos de 14px. |
| RNF-0024 | Feedback visual en acciones | Requerimiento de Usabilidad | No Funcional | Mostrar SnackBar o diálogo tras cada acción importante. |
| RNF-0025 | Indicadores de carga | Requerimiento de Usabilidad | No Funcional | Mostrar loading spinner durante operaciones asíncronas. |
| RNF-0026 | Mensajes de error claros | Requerimiento de Usabilidad | No Funcional | Errores deben describirse en lenguaje sencillo. |
| RNF-0027 | Navegación coherente | Requerimiento de Usabilidad | No Funcional | Bottom Navigation debe estar disponible en pantallas principales. |
| RNF-0028 | Confirmación antes de acciones críticas | Requerimiento de Usabilidad | No Funcional | Pedir confirmación antes de eliminar publicaciones. |
| RNF-0029 | Estados vacíos informativos | Requerimiento de Usabilidad | No Funcional | Mostrar mensajes útiles cuando listas están vacías. |
| RNF-0030 | Accesibilidad de botones | Requerimiento de Usabilidad | No Funcional | Botones deben tener tamaño mínimo táctil de 48x48 dp. |

---

### 📱 Compatibilidad

| ID | Nombre | Sub-tipo | Tipo | Descripción |
|---|---|---|---|---|
| RNF-0031 | Soporte Android 5.0+ | Requerimiento de Compatibilidad | No Funcional | App debe funcionar en Android API 21 en adelante. |
| RNF-0032 | Soporte de múltiples resoluciones | Requerimiento de Compatibilidad | No Funcional | Diseño responsive para pantallas de 4.5" a 7". |
| RNF-0033 | Compatibilidad con diferentes densidades | Requerimiento de Compatibilidad | No Funcional | Soportar mdpi, hdpi, xhdpi, xxhdpi, xxxhdpi. |
| RNF-0034 | Flutter SDK 3.9.2+ | Requerimiento de Compatibilidad | No Funcional | Compilar con Flutter SDK mínimo 3.9.2. |
| RNF-0035 | Dart 3.x | Requerimiento de Compatibilidad | No Funcional | Código compatible con Dart 3.0 en adelante. |
| RNF-0036 | Firebase SDK actualizado | Requerimiento de Compatibilidad | No Funcional | Usar versiones recientes de paquetes Firebase. |
| RNF-0037 | Google Play Services | Requerimiento de Compatibilidad | No Funcional | Dispositivo debe tener Google Play Services instalado. |
| RNF-0038 | Arquitecturas ARM | Requerimiento de Compatibilidad | No Funcional | Soporte para arm64-v8a y armeabi-v7a. |
| RNF-0039 | Sin dependencias obsoletas | Requerimiento de Compatibilidad | No Funcional | Evitar paquetes deprecated o sin mantenimiento. |
| RNF-0040 | Compatibilidad con Android 13+ | Requerimiento de Compatibilidad | No Funcional | Solicitar permisos de notificaciones en runtime. |

---

### 🛠️ Mantenibilidad

| ID | Nombre | Sub-tipo | Tipo | Descripción |
|---|---|---|---|---|
| RNF-0041 | Código modular | Requerimiento de Mantenibilidad | No Funcional | Separar lógica en servicios reutilizables. |
| RNF-0042 | Estructura de carpetas organizada | Requerimiento de Mantenibilidad | No Funcional | Organizar por features: screens, services, widgets, utils. |
| RNF-0043 | Servicios singleton | Requerimiento de Mantenibilidad | No Funcional | AuthService, ChatService, etc. deben ser singletons. |
| RNF-0044 | Widgets reutilizables | Requerimiento de Mantenibilidad | No Funcional | Crear componentes como PetCard, InfoChip. |
| RNF-0045 | Nomenclatura consistente | Requerimiento de Mantenibilidad | No Funcional | Seguir convenciones de Dart (camelCase, PascalCase). |
| RNF-0046 | Comentarios en código complejo | Requerimiento de Mantenibilidad | No Funcional | Documentar lógica no trivial con comentarios. |
| RNF-0047 | Sin código duplicado | Requerimiento de Mantenibilidad | No Funcional | Refactorizar código repetido a funciones/métodos. |
| RNF-0048 | Separación de concerns | Requerimiento de Mantenibilidad | No Funcional | UI separada de lógica de negocio. |
| RNF-0049 | Versionado semántico | Requerimiento de Mantenibilidad | No Funcional | Seguir formato major.minor.patch+build. |
| RNF-0050 | Control de versiones con Git | Requerimiento de Mantenibilidad | No Funcional | Usar Git para historial de cambios. |

---

### 🚀 Escalabilidad

| ID | Nombre | Sub-tipo | Tipo | Descripción |
|---|---|---|---|---|
| RNF-0051 | Arquitectura cloud-native | Requerimiento de Escalabilidad | No Funcional | Usar servicios serverless de Firebase. |
| RNF-0052 | Cloud Functions escalables | Requerimiento de Escalabilidad | No Funcional | Functions deben escalar automáticamente con demanda. |
| RNF-0053 | Firestore escalable | Requerimiento de Escalabilidad | No Funcional | Base de datos debe soportar crecimiento sin rediseño. |
| RNF-0054 | Storage escalable | Requerimiento de Escalabilidad | No Funcional | Firebase Storage debe manejar incremento de imágenes. |
| RNF-0055 | Índices de Firestore | Requerimiento de Escalabilidad | No Funcional | Crear índices compuestos para queries complejas. |
| RNF-0056 | Paginación de resultados | Requerimiento de Escalabilidad | No Funcional | Implementar lazy loading para grandes volúmenes. |
| RNF-0057 | Caché de datos frecuentes | Requerimiento de Escalabilidad | No Funcional | Cachear análisis IA y datos estáticos. |
| RNF-0058 | Límites de consultas | Requerimiento de Escalabilidad | No Funcional | Limitar queries a 50-100 documentos por request. |
| RNF-0059 | Uso eficiente de FCM | Requerimiento de Escalabilidad | No Funcional | Enviar notificaciones solo cuando sea necesario. |
| RNF-0060 | Arquitectura preparada para crecimiento | Requerimiento de Escalabilidad | No Funcional | Diseño debe permitir agregar features sin refactorizar. |

---

### 📊 Disponibilidad

| ID | Nombre | Sub-tipo | Tipo | Descripción |
|---|---|---|---|---|
| RNF-0061 | Disponibilidad de Firebase | Requerimiento de Disponibilidad | No Funcional | Aprovechar SLA de Firebase (99.95% uptime). |
| RNF-0062 | Manejo de pérdida de conexión | Requerimiento de Disponibilidad | No Funcional | Mostrar mensaje si no hay conexión a internet. |
| RNF-0063 | Reconexión automática | Requerimiento de Disponibilidad | No Funcional | Firebase debe reconectar automáticamente. |
| RNF-0064 | Tolerancia a fallos de API | Requerimiento de Disponibilidad | No Funcional | Continuar funcionando si Vision API falla. |
| RNF-0065 | Persistencia local de sesión | Requerimiento de Disponibilidad | No Funcional | Mantener sesión aunque Firebase esté offline temporalmente. |
| RNF-0066 | Mensajes de error amigables | Requerimiento de Disponibilidad | No Funcional | Informar al usuario de problemas de conexión. |
| RNF-0067 | Recuperación de estado | Requerimiento de Disponibilidad | No Funcional | App debe recuperarse tras crash sin perder datos. |
| RNF-0068 | Sin pérdida de mensajes | Requerimiento de Disponibilidad | No Funcional | Mensajes deben guardarse aunque haya desconexión. |
| RNF-0069 | Reintentos automáticos | Requerimiento de Disponibilidad | No Funcional | Reintentar operaciones fallidas automáticamente. |
| RNF-0070 | Logging de errores | Requerimiento de Disponibilidad | No Funcional | Registrar errores en consola para debugging. |

---

### 🔄 Portabilidad

| ID | Nombre | Sub-tipo | Tipo | Descripción |
|---|---|---|---|---|
| RNF-0071 | Código Flutter multiplataforma | Requerimiento de Portabilidad | No Funcional | Código debe ser portable a iOS con mínimos cambios. |
| RNF-0072 | Dependencias cross-platform | Requerimiento de Portabilidad | No Funcional | Usar paquetes que soporten múltiples plataformas. |
| RNF-0073 | Configuración Firebase por plataforma | Requerimiento de Portabilidad | No Funcional | Usar firebase_options.dart generado por FlutterFire. |
| RNF-0074 | Sin código específico de Android | Requerimiento de Portabilidad | No Funcional | Evitar código nativo Android innecesario. |
| RNF-0075 | Assets multiplataforma | Requerimiento de Portabilidad | No Funcional | Recursos deben funcionar en cualquier plataforma. |
| RNF-0076 | Rutas relativas | Requerimiento de Portabilidad | No Funcional | Usar rutas relativas en lugar de absolutas. |
| RNF-0077 | Separación de configuración | Requerimiento de Portabilidad | No Funcional | Config específica de plataforma en archivos separados. |
| RNF-0078 | Sin hardcoding de paths | Requerimiento de Portabilidad | No Funcional | Evitar rutas fijas en código. |
| RNF-0079 | Uso de paquetes oficiales | Requerimiento de Portabilidad | No Funcional | Preferir paquetes mantenidos por Flutter team. |
| RNF-0080 | Exportabilidad de datos | Requerimiento de Portabilidad | No Funcional | Datos en Firestore son exportables. |

---

### ⚙️ Configurabilidad

| ID | Nombre | Sub-tipo | Tipo | Descripción |
|---|---|---|---|---|
| RNF-0081 | Variables de entorno | Requerimiento de Configurabilidad | No Funcional | API keys deben estar en constantes configurables. |
| RNF-0082 | Firebase config desde archivo | Requerimiento de Configurabilidad | No Funcional | Usar firebase_options.dart generado. |
| RNF-0083 | Colores centralizados | Requerimiento de Configurabilidad | No Funcional | AppColors debe definir toda la paleta. |
| RNF-0084 | Lista de comunas configurable | Requerimiento de Configurabilidad | No Funcional | Comunas deben estar en archivo de datos separado. |
| RNF-0085 | Configuración de compresión | Requerimiento de Configurabilidad | No Funcional | Quality de imagen debe ser modificable. |
| RNF-0086 | Límites configurables | Requerimiento de Configurabilidad | No Funcional | Límites de queries deben ser constantes ajustables. |
| RNF-0087 | Timeout de operaciones | Requerimiento de Configurabilidad | No Funcional | Timeouts deben ser configurables. |
| RNF-0088 | URLs de políticas | Requerimiento de Configurabilidad | No Funcional | URLs de HTML públicos deben estar centralizadas. |
| RNF-0089 | Tema personalizable | Requerimiento de Configurabilidad | No Funcional | Theme debe estar en archivo de configuración. |
| RNF-0090 | Idioma configurable | Requerimiento de Configurabilidad | No Funcional | Textos deben estar preparados para i18n futuro. |

---

### 🧪 Testabilidad

| ID | Nombre | Sub-tipo | Tipo | Descripción |
|---|---|---|---|---|
| RNF-0091 | Servicios testables | Requerimiento de Testabilidad | No Funcional | Servicios deben ser testables unitariamente. |
| RNF-0092 | Mocks de Firebase | Requerimiento de Testabilidad | No Funcional | Permitir uso de Firebase Test SDK. |
| RNF-0093 | Separación de lógica | Requerimiento de Testabilidad | No Funcional | Lógica de negocio separada de UI. |
| RNF-0094 | Widgets testables | Requerimiento de Testabilidad | No Funcional | Widgets deben ser testables con widget tests. |
| RNF-0095 | Sin dependencias hardcoded | Requerimiento de Testabilidad | No Funcional | Dependencias deben ser inyectables. |
| RNF-0096 | Logging para debugging | Requerimiento de Testabilidad | No Funcional | Logs de operaciones importantes. |
| RNF-0097 | Manejo de errores consistente | Requerimiento de Testabilidad | No Funcional | Try-catch en operaciones asíncronas. |
| RNF-0098 | Estado predecible | Requerimiento de Testabilidad | No Funcional | Estado de app debe ser reproducible. |
| RNF-0099 | Funciones puras donde sea posible | Requerimiento de Testabilidad | No Funcional | Funciones sin side effects son preferibles. |
| RNF-0100 | Cobertura de código | Requerimiento de Testabilidad | No Funcional | Objetivo: >50% code coverage en servicios críticos. |

---

## 📊 RESUMEN CUANTITATIVO

### Requerimientos Funcionales
- **Total:** 100 requerimientos
- **Categorías:** 10
- **Requerimientos de Usuario:** 45
- **Requerimientos de Sistema:** 47
- **Requerimientos de Negocio:** 8

### Requerimientos No Funcionales
- **Total:** 100 requerimientos
- **Categorías:** 10
- **Rendimiento:** 10
- **Seguridad:** 10
- **Usabilidad:** 10
- **Compatibilidad:** 10
- **Mantenibilidad:** 10
- **Escalabilidad:** 10
- **Disponibilidad:** 10
- **Portabilidad:** 10
- **Configurabilidad:** 10
- **Testabilidad:** 10

---

## 🎯 MATRIZ DE TRAZABILIDAD

### Priorización de Requerimientos

#### Críticos (Must Have)
- RF-0001 a RF-0010: Autenticación
- RF-0021 a RF-0040: Publicación de mascotas
- RF-0081 a RF-0090: Mensajería básica
- RNF-0011 a RNF-0020: Seguridad
- RNF-0031 a RNF-0040: Compatibilidad

#### Importantes (Should Have)
- RF-0041 a RF-0050: Gestión de publicaciones
- RF-0051 a RF-0060: Búsqueda y filtrado
- RNF-0001 a RNF-0010: Rendimiento
- RNF-0021 a RNF-0030: Usabilidad

#### Deseables (Nice to Have)
- RF-0011 a RF-0020: Gestión de perfiles avanzada
- RF-0061 a RF-0080: Visualización mejorada
- RNF-0041 a RNF-0060: Mantenibilidad y escalabilidad

---

**Fecha de Análisis:** 30 de noviembre de 2025  
**Versión del Proyecto:** 1.4.0+1  
**Total de Requerimientos:** 200 (100 Funcionales + 100 No Funcionales)
