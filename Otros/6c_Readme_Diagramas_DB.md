# Guía de Diagramas y Esquemas Relacionales (PetHub)

Este documento explica cómo usar el archivo DBML y los scripts SQL generados para respaldar tareas de documentación, migración o análisis de la aplicación PetHub.

## Archivos Generados

- `6_DB_Diagram_PetHub.dbml`: Modelo lógico relacional derivado de colecciones Firestore.
- `6a_PostgreSQL_Schema.sql`: DDL optimizado para PostgreSQL (ENUM types separados, índices compuestos, ON DELETE CASCADE donde corresponde).
- `6b_MySQL_Schema.sql`: DDL para MySQL 8+ (ENUM internos, engine InnoDB, claves e índices equivalentes).

## Uso en dbdiagram.io

1. Abrir <https://dbdiagram.io>
2. Crear nuevo diagrama y elegir formato DBML.
3. Pegar contenido de `6_DB_Diagram_PetHub.dbml`.
4. Ajustar colores/nodos si se desea una mejor visualización.
5. Exportar imagen (PNG/SVG) para documentación o presentaciones.

## Adaptaciones del Modelo Firestore → Relacional

| Concepto Firestore | Transformación Relacional |
|--------------------|---------------------------|
| Documento raíz (users, pets, chats) | Tabla con PK (id) |
| Subcolección (messages, recent_views) | Tabla dependiente con FK + PK compuesto |
| Array/map participantes | Tabla puente `chat_participants` |
| Etiquetas Vision API | Tabla `ai_cache_labels` con PK compuesto (hash,label) |
| Campos calculados (unread_count) | Mantenido en `chats` (derivable pero útil) |

## Índices Clave

- Búsquedas de mascotas recientes: `pets(created_at DESC)`
- Filtrado por estado: `pets(status)`
- Mensajes por chat ordenados: `(chat_id, timestamp)`
- Cambios de estado recientes: `(status, last_status)`

## Posibles Extensiones

- Auditoría: tablas de eventos (adopción, cambios de perfil).
- Full Text Search: en descripciones (PostgreSQL `GIN` + `to_tsvector`, MySQL `FULLTEXT`).
- Particionamiento: por fecha en `chat_messages` para alto volumen.
- Cache semántico: tabla adicional para sinónimos de etiquetas.

## Migración Progresiva (Estrategia Sugerida)

1. Congelar estructura actual de Firestore y exportar snapshot.
2. Poblar tablas relacionales desde exports JSON/CSV.
3. Validar integridad (conteos, hashes, muestras aleatorias).
4. Implementar capa de acceso dual (Firestore + SQL) durante transición.
5. Migrar gradualmente servicios críticos (chat, búsqueda, reportes).

## Seguridad y Privacidad

- Aplicar RLS en PostgreSQL para aislar registros por usuario si se requiere multitenancy.
- Cifrar tokens sensibles fuera de la BD (FCM token se puede rotar/limitar).
- Limitar acceso a tablas de cache (`ai_cache`) sólo a procesos internos.

## Backup y Recuperación

- PostgreSQL: `pg_dump` + `pg_restore` (frecuencia diaria + incremental WAL).
- MySQL: `mysqldump` o Percona XtraBackup para grandes volúmenes.
- Versionar archivos DDL en control de código (ya incluidos en `Otros/`).

## Validación de Consistencia Post-Migración

Checklist rápido:

- Conteo de usuarios coincide.
- Cada `pets.user_id` existe en `users.id`.
- Relación `chat_participants` refleja chats y usuarios válidos.
- No existen etiquetas huérfanas (`ai_cache_labels.hash` ∈ `ai_cache.hash`).
- No hay diferencias en estados esperados (comparar muestras de `users_recent_views`).

## Próximos Pasos (Opcionales)

- Script ETL de ejemplo para migrar datos (Dart/Node).
- Diagrama ER estilizado en herramienta de modelado (Draw.io / PlantUML).
- Incorporar vistas analíticas (adopciones por comuna, tiempos promedio de adopción).

## Preguntas Frecuentes

**¿Por qué ENUM y no tablas lookup?** Para vocabularios muy estáticos (especies, género, estado) que cambian poco y benefician validación fuerte.

**¿Qué pasa si aparecen más especies?** En PostgreSQL: `ALTER TYPE species_enum ADD VALUE 'Ave';` En MySQL: requerirá recrear ENUM o migrar a tabla lookup.

**¿Se puede escalar chat_messages?** Sí: particionar por rango de fechas o por hash de `chat_id` si la cantidad crece exponencialmente.

---

Si necesitas el ETL o vistas analíticas, indícalo y las agrego.
