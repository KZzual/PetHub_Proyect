-- PostgreSQL Schema for PetHub (Relacional derivado de Firestore)
-- Fecha: 2025-12-01
-- NOTA: Este esquema es una representación lógica; Firestore no aplica FKs ni transacciones relacionales.
-- Ajustar según necesidades reales (particiones, índices adicionales, etc.).

-- =============================================================
-- ENUM TYPES
-- =============================================================
CREATE TYPE species_enum AS ENUM ('Perro','Gato');
CREATE TYPE gender_enum AS ENUM ('Macho','Hembra');
CREATE TYPE adoption_status_enum AS ENUM ('En Adopción','Adoptado');
CREATE TYPE comuna_rm_enum AS ENUM (
  'San Joaquín','La Florida','Macul','Ñuñoa','Santiago Centro',
  'Providencia','La Cisterna','Maipú','Puente Alto','San Miguel'
);

-- =============================================================
-- TABLE: users
-- =============================================================
CREATE TABLE users (
  id              VARCHAR(64) PRIMARY KEY, -- Firebase UID
  name            VARCHAR(120) NOT NULL,
  email           VARCHAR(160) NOT NULL UNIQUE,
  phone           VARCHAR(25) NOT NULL,
  comuna          comuna_rm_enum NULL,
  description     TEXT NULL,
  photo_url       TEXT NULL,
  role            VARCHAR(40) NOT NULL DEFAULT 'adoptante',
  fcm_token       TEXT NULL,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_users_created_at ON users(created_at);

-- =============================================================
-- TABLE: pets
-- =============================================================
CREATE TABLE pets (
  id               VARCHAR(64) PRIMARY KEY,
  user_id          VARCHAR(64) NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  user_name        VARCHAR(120) NOT NULL,
  user_photo       TEXT NULL,
  name             VARCHAR(120) NOT NULL,
  species          species_enum NOT NULL,
  breed            VARCHAR(120) NOT NULL,
  gender           gender_enum NOT NULL,
  age              VARCHAR(40) NOT NULL,            -- Texto libre (ej: "2 años")
  location         VARCHAR(160) NOT NULL,
  description      TEXT NULL,
  auto_description TEXT NULL,
  photo_url        TEXT NOT NULL,
  status           adoption_status_enum NOT NULL DEFAULT 'En Adopción',
  created_at       TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_pets_user_created ON pets(user_id, created_at DESC);
CREATE INDEX idx_pets_created_at ON pets(created_at DESC);
CREATE INDEX idx_pets_status ON pets(status);

-- =============================================================
-- TABLE: ai_cache
-- =============================================================
CREATE TABLE ai_cache (
  hash             VARCHAR(64) PRIMARY KEY, -- sha1
  is_pet           BOOLEAN NOT NULL DEFAULT FALSE,
  exif_valid       BOOLEAN NOT NULL DEFAULT FALSE,
  auto_description TEXT NULL,
  created_at       TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- =============================================================
-- TABLE: ai_cache_labels
-- =============================================================
CREATE TABLE ai_cache_labels (
  hash  VARCHAR(64) NOT NULL REFERENCES ai_cache(hash) ON DELETE CASCADE,
  label VARCHAR(160) NOT NULL,
  PRIMARY KEY (hash, label)
);

CREATE INDEX idx_ai_label ON ai_cache_labels(label);

-- =============================================================
-- TABLE: chats
-- =============================================================
CREATE TABLE chats (
  id             VARCHAR(64) PRIMARY KEY,
  last_message   TEXT NULL,
  last_timestamp TIMESTAMPTZ NULL,
  unread_count   INT NOT NULL DEFAULT 0
);

CREATE INDEX idx_chats_last_ts_desc ON chats(last_timestamp DESC);

-- =============================================================
-- TABLE: chat_participants
-- Representa el mapa participants y el arreglo users
-- =============================================================
CREATE TABLE chat_participants (
  chat_id   VARCHAR(64) NOT NULL REFERENCES chats(id) ON DELETE CASCADE,
  user_id   VARCHAR(64) NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  name      VARCHAR(120) NOT NULL,
  photo_url TEXT NULL,
  PRIMARY KEY (chat_id, user_id)
);

CREATE INDEX idx_participant_user_chat ON chat_participants(user_id, chat_id);

-- =============================================================
-- TABLE: chat_messages
-- Subcolección messages
-- =============================================================
CREATE TABLE chat_messages (
  id         VARCHAR(64) PRIMARY KEY,
  chat_id    VARCHAR(64) NOT NULL REFERENCES chats(id) ON DELETE CASCADE,
  sender_id  VARCHAR(64) NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  text       TEXT NOT NULL,
  timestamp  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  seen       BOOLEAN NOT NULL DEFAULT FALSE
);

CREATE INDEX idx_msgs_chat_time ON chat_messages(chat_id, timestamp);
CREATE INDEX idx_msgs_sender ON chat_messages(sender_id);

-- =============================================================
-- TABLE: users_recent_views
-- Subcolección recent_views
-- =============================================================
CREATE TABLE users_recent_views (
  user_id     VARCHAR(64) NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  pet_id      VARCHAR(64) NOT NULL REFERENCES pets(id) ON DELETE CASCADE,
  name        VARCHAR(120) NOT NULL,
  photo_url   TEXT NULL,
  species     species_enum NOT NULL,
  status      adoption_status_enum NOT NULL,
  last_status adoption_status_enum NOT NULL,
  viewed_at   TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  PRIMARY KEY (user_id, pet_id)
);

CREATE INDEX idx_recent_user_time ON users_recent_views(user_id, viewed_at DESC);
CREATE INDEX idx_recent_status_change ON users_recent_views(status, last_status);

-- =============================================================
-- OPTIONAL: MATERIALIZED VIEW for status changes (example)
-- =============================================================
-- CREATE MATERIALIZED VIEW mv_status_changes AS
-- SELECT user_id, pet_id, name, status, last_status, viewed_at
-- FROM users_recent_views
-- WHERE status <> last_status;
-- REFRESH MATERIALIZED VIEW mv_status_changes;

-- =============================================================
-- SECURITY / ROW LEVEL SUGGESTIONS (Not implemented here)
-- =============================================================
-- Row Level Security could be enabled if multi-tenancy is desired:
-- ALTER TABLE users ENABLE ROW LEVEL SECURITY;
-- CREATE POLICY user_is_self ON users USING (id = current_setting('app.user_id'));

-- =============================================================
-- END OF SCHEMA
