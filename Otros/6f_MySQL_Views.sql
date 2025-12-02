-- Vistas analíticas MySQL 8+ para PetHub
-- Fecha: 2025-12-01
-- Requiere esquema previamente creado (ver 6b_MySQL_Schema.sql)

-- Conteo de mascotas por estado
CREATE OR REPLACE VIEW v_pets_status_counts AS
SELECT status, COUNT(*) AS total
FROM pets
GROUP BY status
ORDER BY total DESC;

-- Mensajes por chat (volumen)
CREATE OR REPLACE VIEW v_messages_per_chat AS
SELECT c.id AS chat_id,
       COUNT(m.id) AS messages_count,
       MAX(m.timestamp) AS last_message_ts
FROM chats c
LEFT JOIN chat_messages m ON m.chat_id = c.id
GROUP BY c.id;

-- Frecuencia de etiquetas Vision AI
CREATE OR REPLACE VIEW v_labels_frequency AS
SELECT label, COUNT(*) AS frequency
FROM ai_cache_labels
GROUP BY label
ORDER BY frequency DESC;

-- Cambios de estado detectados (status != last_status)
CREATE OR REPLACE VIEW v_recent_views_changes AS
SELECT user_id, pet_id, name, status, last_status, viewed_at
FROM users_recent_views
WHERE status <> last_status;

-- Actividad de usuario: número de mascotas publicadas y mensajes enviados
CREATE OR REPLACE VIEW v_user_activity_summary AS
SELECT u.id AS user_id,
       u.name,
       COUNT(DISTINCT p.id) AS pets_published,
       COUNT(DISTINCT m.id) AS messages_sent
FROM users u
LEFT JOIN pets p ON p.user_id = u.id
LEFT JOIN chat_messages m ON m.sender_id = u.id
GROUP BY u.id, u.name;

-- Top 10 usuarios por mensajes enviados
CREATE OR REPLACE VIEW v_top_users_messages AS
SELECT user_id, name, messages_sent
FROM v_user_activity_summary
ORDER BY messages_sent DESC
LIMIT 10;

-- Promedio de mensajes por chat
CREATE OR REPLACE VIEW v_avg_messages_per_chat AS
SELECT ROUND(AVG(messages_count),2) AS avg_messages
FROM v_messages_per_chat;

-- Frecuencia de vistas recientes por especie
CREATE OR REPLACE VIEW v_recent_views_species AS
SELECT species, COUNT(*) AS views
FROM users_recent_views
GROUP BY species
ORDER BY views DESC;

-- Etiquetas con frecuencia sobre la media
CREATE OR REPLACE VIEW v_labels_above_average AS
SELECT lf.label, lf.frequency
FROM v_labels_frequency lf
JOIN (
    SELECT AVG(frequency) AS avg_freq FROM v_labels_frequency
) stats ON lf.frequency > stats.avg_freq
ORDER BY lf.frequency DESC;
