# README ETL Firestore → SQL (PetHub)

Este documento explica el uso del script `6d_ETL_Firestore_to_SQL.dart` para generar sentencias SQL de inserción a partir de un export simplificado de Firestore.

## 1. Formato de Entrada

Se espera un archivo JSON con listas de objetos por colección:

```json
{
  "users": [{"id": "U1", "name": "Ana", "email": "ana@example.com", "created_at": "2025-11-30T10:15:00Z"}],
  "pets": [{"id": "P1", "user_id": "U1", "name": "Firulais", "species": "Perro", "status": "En Adopción"}],
  "ai_cache": [{"hash": "abc123", "is_pet": true, "created_at": "2025-11-30T11:00:00Z"}],
  "ai_cache_labels": [{"hash": "abc123", "label": "Dog"}],
  "chats": [{"id": "C1", "last_message": "Hola", "unread_count": 0}],
  "chat_messages": [{"id": "M1", "chat_id": "C1", "sender_id": "U1", "text": "Hola", "timestamp": "2025-11-30T12:00:00Z"}],
  "users_recent_views": [{"user_id": "U1", "pet_id": "P1", "name": "Firulais", "species": "Perro", "status": "En Adopción", "last_status": "En Adopción"}]
}
```

Subcolecciones reales de Firestore suelen exportarse en archivos separados; adapte el merge según su pipeline.

## 2. Ejecución del Script

Asegúrate de tener Dart SDK instalado.

```bash
# Ejecutar (PostgreSQL por defecto)
dart run Otros/6d_ETL_Firestore_to_SQL.dart --input=export.json --out=etl_postgres.sql --dialect=postgres

# Para MySQL
dart run Otros/6d_ETL_Firestore_to_SQL.dart --input=export.json --out=etl_mysql.sql --dialect=mysql
```

## 3. Dialectos

- `postgres`: Usa `NOW()` y formato compatible con ENUM definidos en el esquema.
- `mysql`: Genera valores apropiados (1/0) para booleanos; ENUM deben existir previamente.

## 4. Limitaciones y Ajustes

- No procesa arrays anidados complejos; agregar lógica adicional según se requiera.
- El formato de export oficial de Firestore (gcloud) difiere; se requiere parsing adicional.
- No valida FKs; se asume que el orden de inserción no rompe integridad (users antes que pets, etc.).
- Fechas: si falta `created_at` se reemplaza por `NOW()`. Ajustar para consistencia histórica.

## 5. Orden Sugerido de Carga

1. users
2. pets
3. ai_cache
4. ai_cache_labels
5. chats
6. chat_messages
7. users_recent_views

## 6. Verificación Post-Carga

Ejecutar consultas rápidas:

```sql
SELECT COUNT(*) FROM users;
SELECT status, COUNT(*) FROM pets GROUP BY status;
SELECT COUNT(*) FROM chat_messages;
SELECT COUNT(*) FROM ai_cache_labels;
```

## 7. Optimización Posterior

- Batch inserts (COPY en PostgreSQL, LOAD DATA en MySQL) para grandes volúmenes.
- Desactivar índices secundarios durante carga masiva y reconstruirlos luego.
- Validar colisiones de PK antes de inserciones (sha1 repetidos, ids duplicados).

## 8. Extensiones Posibles

- Script para generar CSV por tabla y usar import nativo.
- Verificación de integridad referencial después de cada lote.
- Normalización adicional (tabla breeds, roles, etc.).

## 9. Seguridad

- No incluir datos sensibles (contraseñas, tokens de sesión) en el export.
- Rotar `fcm_token` tras migración si hubo exposición prolongada.

## 10. Troubleshooting

| Problema | Causa | Solución |
|----------|-------|----------|
| Error de ENUM | Valor no listado | Agregar valor o mapear a categoría existente |
| FK falla | Orden de inserción incorrecto | Reordenar o usar transacciones |
| Fechas nulas | Campo ausente en JSON | Prellenar con timestamp aproximado |
| Duplicados PK | Datos fusionados varias veces | Filtrar previamente y deduplicar |

---

¿Necesitas versión Node.js o soporte para export oficial de Firestore? Pídelo y lo agrego.
