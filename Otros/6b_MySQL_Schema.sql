-- MySQL Schema para PetHub (Relacional derivado de Firestore)
-- Fecha: 2025-12-01
-- NOTA: Ajustar a la versión de MySQL (>=8.0 recomendado por soporte de CHECK y funcionalidad moderna)
-- Las ENUM internas de MySQL se usan para vocabularios controlados; considerar tablas lookup si se requiere extensibilidad.

-- =============================================================
-- TABLE: users
-- =============================================================
CREATE TABLE users (
  id              VARCHAR(64) PRIMARY KEY, -- Firebase UID
  name            VARCHAR(120) NOT NULL,
  email           VARCHAR(160) NOT NULL UNIQUE,
  phone           VARCHAR(25) NOT NULL,
  comuna          ENUM('San Joaquín','La Florida','Macul','Ñuñoa','Santiago Centro','Providencia','La Cisterna','Maipú','Puente Alto','San Miguel') NULL,
  description     TEXT NULL,
  photo_url       TEXT NULL,
  role            VARCHAR(40) NOT NULL DEFAULT 'adoptante',
  fcm_token       TEXT NULL,
  created_at      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  KEY idx_users_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================================
-- TABLE: pets
-- =============================================================
CREATE TABLE pets (
  id               VARCHAR(64) PRIMARY KEY,
  user_id          VARCHAR(64) NOT NULL,
  user_name        VARCHAR(120) NOT NULL,
  user_photo       TEXT NULL,
  name             VARCHAR(120) NOT NULL,
  species          ENUM('Perro','Gato') NOT NULL,
  breed            VARCHAR(120) NOT NULL,
  gender           ENUM('Macho','Hembra') NOT NULL,
  age              VARCHAR(40) NOT NULL,
  location         VARCHAR(160) NOT NULL,
  description      TEXT NULL,
  auto_description TEXT NULL,
  photo_url        TEXT NOT NULL,
  status           ENUM('En Adopción','Adoptado') NOT NULL DEFAULT 'En Adopción',
  created_at       TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  KEY idx_pets_user_created (user_id, created_at),
  KEY idx_pets_created_at (created_at),
  KEY idx_pets_status (status),
  CONSTRAINT fk_pets_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================================
-- TABLE: ai_cache
-- =============================================================
CREATE TABLE ai_cache (
  hash             VARCHAR(64) PRIMARY KEY,
  is_pet           TINYINT(1) NOT NULL DEFAULT 0,
  exif_valid       TINYINT(1) NOT NULL DEFAULT 0,
  auto_description TEXT NULL,
  created_at       TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================================
-- TABLE: ai_cache_labels
-- =============================================================
CREATE TABLE ai_cache_labels (
  hash  VARCHAR(64) NOT NULL,
  label VARCHAR(160) NOT NULL,
  PRIMARY KEY (hash, label),
  KEY idx_ai_label (label),
  CONSTRAINT fk_ai_label_cache FOREIGN KEY (hash) REFERENCES ai_cache(hash) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================================
-- TABLE: chats
-- =============================================================
CREATE TABLE chats (
  id             VARCHAR(64) PRIMARY KEY,
  last_message   TEXT NULL,
  last_timestamp TIMESTAMP NULL,
  unread_count   INT NOT NULL DEFAULT 0,
  KEY idx_chats_last_ts_desc (last_timestamp)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================================
-- TABLE: chat_participants
-- =============================================================
CREATE TABLE chat_participants (
  chat_id   VARCHAR(64) NOT NULL,
  user_id   VARCHAR(64) NOT NULL,
  name      VARCHAR(120) NOT NULL,
  photo_url TEXT NULL,
  PRIMARY KEY (chat_id, user_id),
  KEY idx_participant_user_chat (user_id, chat_id),
  CONSTRAINT fk_participants_chat FOREIGN KEY (chat_id) REFERENCES chats(id) ON DELETE CASCADE,
  CONSTRAINT fk_participants_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================================
-- TABLE: chat_messages
-- =============================================================
CREATE TABLE chat_messages (
  id         VARCHAR(64) PRIMARY KEY,
  chat_id    VARCHAR(64) NOT NULL,
  sender_id  VARCHAR(64) NOT NULL,
  text       TEXT NOT NULL,
  timestamp  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  seen       TINYINT(1) NOT NULL DEFAULT 0,
  KEY idx_msgs_chat_time (chat_id, timestamp),
  KEY idx_msgs_sender (sender_id),
  CONSTRAINT fk_msgs_chat FOREIGN KEY (chat_id) REFERENCES chats(id) ON DELETE CASCADE,
  CONSTRAINT fk_msgs_sender FOREIGN KEY (sender_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================================
-- TABLE: users_recent_views
-- =============================================================
CREATE TABLE users_recent_views (
  user_id     VARCHAR(64) NOT NULL,
  pet_id      VARCHAR(64) NOT NULL,
  name        VARCHAR(120) NOT NULL,
  photo_url   TEXT NULL,
  species     ENUM('Perro','Gato') NOT NULL,
  status      ENUM('En Adopción','Adoptado') NOT NULL,
  last_status ENUM('En Adopción','Adoptado') NOT NULL,
  viewed_at   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (user_id, pet_id),
  KEY idx_recent_user_time (user_id, viewed_at),
  KEY idx_recent_status_change (status, last_status),
  CONSTRAINT fk_recent_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  CONSTRAINT fk_recent_pet FOREIGN KEY (pet_id) REFERENCES pets(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================================
-- VIEW de cambios de estado (opcional, NO MATERIALIZADA)
-- =============================================================
-- CREATE OR REPLACE VIEW v_status_changes AS
-- SELECT user_id, pet_id, name, status, last_status, viewed_at
-- FROM users_recent_views
-- WHERE status <> last_status;

-- =============================================================
-- Consideraciones de optimización:
-- - Ajustar LONGTEXT vs TEXT según tamaño máximo de descripciones
-- - Añadir índices FULLTEXT (MySQL) si se requiere búsqueda semántica en descripciones
-- - Revisar cardinalidad y tamaño de claves para sharding futuro
-- =============================================================
