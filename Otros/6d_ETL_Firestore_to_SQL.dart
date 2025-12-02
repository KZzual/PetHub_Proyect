/// ETL de ejemplo: Convierte un export JSON de Firestore a sentencias SQL INSERT.
/// Uso:
///   dart run Otros/6d_ETL_Firestore_to_SQL.dart --input=export.json --dialect=postgres --out=output.sql
/// Export esperado: un JSON con objetos de colecciones: users, pets, chats, ai_cache y subcolecciones embebidas.
/// NOTA: Este script es simplificado; Firestore export oficial genera múltiples archivos. Ajustar parser según formato real.

import 'dart:convert';
import 'dart:io';

enum SqlDialect { postgres, mysql }

void main(List<String> args) async {
  final params = _parseArgs(args);
  final inputPath = params['input'];
  final outPath = params['out'] ?? 'etl_output.sql';
  final dialect = params['dialect'] == 'mysql' ? SqlDialect.mysql : SqlDialect.postgres;

  if (inputPath == null) {
    stderr.writeln('ERROR: Debes indicar --input=archivo.json');
    exit(1);
  }

  final file = File(inputPath);
  if (!await file.exists()) {
    stderr.writeln('ERROR: No se encontró el archivo $inputPath');
    exit(1);
  }

  final content = await file.readAsString();
  final data = jsonDecode(content);
  if (data is! Map<String, dynamic>) {
    stderr.writeln('ERROR: Formato JSON inválido. Se esperaba objeto raíz.');
    exit(1);
  }

  final buffer = StringBuffer();
  buffer.writeln('-- SQL generado por ETL Firestore→Relacional');
  buffer.writeln('-- Dialecto: ${dialect.name}');
  buffer.writeln('-- Fecha: ${DateTime.now().toIso8601String()}');
  buffer.writeln();

  _emitUsers(data['users'], buffer, dialect);
  _emitPets(data['pets'], buffer, dialect);
  _emitAICache(data['ai_cache'], buffer, dialect);
  _emitChats(data['chats'], buffer, dialect);

  // Mensajes y vistas recientes (subcolecciones) pueden venir embebidas o en listas separadas.
  _emitChatMessages(data['chat_messages'], buffer, dialect);
  _emitRecentViews(data['users_recent_views'], buffer, dialect);
  _emitAICacheLabels(data['ai_cache_labels'], buffer, dialect);

  final outFile = File(outPath);
  await outFile.writeAsString(buffer.toString());
  stdout.writeln('ETL completo. Archivo generado: $outPath');
}

Map<String, String> _parseArgs(List<String> args) {
  final map = <String, String>{};
  for (final a in args) {
    if (a.startsWith('--') && a.contains('=')) {
      final parts = a.substring(2).split('=');
      if (parts.length == 2) map[parts[0]] = parts[1];
    }
  }
  return map;
}

String _q(String? v, SqlDialect d) {
  if (v == null) return 'NULL';
  final escaped = v.replaceAll("'", "''");
  return "'$escaped'";
}

void _emitUsers(dynamic raw, StringBuffer b, SqlDialect d) {
  if (raw is! List) return;
  b.writeln('-- Tabla: users');
  for (final u in raw) {
    if (u is! Map) continue;
    final cols = 'id,name,email,phone,comuna,description,photo_url,role,fcm_token,created_at';
    final vals = [
      _q(u['id'], d),
      _q(u['name'], d),
      _q(u['email'], d),
      _q(u['phone'], d),
      _q(u['comuna'], d),
      _q(u['description'], d),
      _q(u['photo_url'], d),
      _q(u['role'] ?? 'adoptante', d),
      _q(u['fcm_token'], d),
      _timestamp(u['created_at'])
    ];
    b.writeln('INSERT INTO users ($cols) VALUES (${vals.join(',')});');
  }
  b.writeln();
}

String _timestamp(dynamic v) {
  if (v == null) return 'NOW()';
  // Se espera ISO8601
  return "'${v.toString()}'";
}

void _emitPets(dynamic raw, StringBuffer b, SqlDialect d) {
  if (raw is! List) return;
  b.writeln('-- Tabla: pets');
  for (final p in raw) {
    if (p is! Map) continue;
    final cols = 'id,user_id,user_name,user_photo,name,species,breed,gender,age,location,description,auto_description,photo_url,status,created_at';
    final vals = [
      _q(p['id'], d),
      _q(p['user_id'], d),
      _q(p['user_name'], d),
      _q(p['user_photo'], d),
      _q(p['name'], d),
      _q(p['species'], d),
      _q(p['breed'], d),
      _q(p['gender'], d),
      _q(p['age'], d),
      _q(p['location'], d),
      _q(p['description'], d),
      _q(p['auto_description'], d),
      _q(p['photo_url'], d),
      _q(p['status'], d),
      _timestamp(p['created_at'])
    ];
    b.writeln('INSERT INTO pets ($cols) VALUES (${vals.join(',')});');
  }
  b.writeln();
}

void _emitAICache(dynamic raw, StringBuffer b, SqlDialect d) {
  if (raw is! List) return;
  b.writeln('-- Tabla: ai_cache');
  for (final c in raw) {
    if (c is! Map) continue;
    final cols = 'hash,is_pet,exif_valid,auto_description,created_at';
    final vals = [
      _q(c['hash'], d),
      (c['is_pet'] == true) ? '1' : '0',
      (c['exif_valid'] == true) ? '1' : '0',
      _q(c['auto_description'], d),
      _timestamp(c['created_at'])
    ];
    b.writeln('INSERT INTO ai_cache ($cols) VALUES (${vals.join(',')});');
  }
  b.writeln();
}

void _emitAICacheLabels(dynamic raw, StringBuffer b, SqlDialect d) {
  if (raw is! List) return;
  b.writeln('-- Tabla: ai_cache_labels');
  for (final l in raw) {
    if (l is! Map) continue;
    final cols = 'hash,label';
    final vals = [
      _q(l['hash'], d),
      _q(l['label'], d)
    ];
    b.writeln('INSERT INTO ai_cache_labels ($cols) VALUES (${vals.join(',')});');
  }
  b.writeln();
}

void _emitChats(dynamic raw, StringBuffer b, SqlDialect d) {
  if (raw is! List) return;
  b.writeln('-- Tabla: chats');
  for (final c in raw) {
    if (c is! Map) continue;
    final cols = 'id,last_message,last_timestamp,unread_count';
    final vals = [
      _q(c['id'], d),
      _q(c['last_message'], d),
      _timestamp(c['last_timestamp']),
      (c['unread_count'] ?? 0).toString()
    ];
    b.writeln('INSERT INTO chats ($cols) VALUES (${vals.join(',')});');
  }
  b.writeln();
}

void _emitChatMessages(dynamic raw, StringBuffer b, SqlDialect d) {
  if (raw is! List) return;
  b.writeln('-- Tabla: chat_messages');
  for (final m in raw) {
    if (m is! Map) continue;
    final cols = 'id,chat_id,sender_id,text,timestamp,seen';
    final vals = [
      _q(m['id'], d),
      _q(m['chat_id'], d),
      _q(m['sender_id'], d),
      _q(m['text'], d),
      _timestamp(m['timestamp']),
      (m['seen'] == true) ? '1' : '0'
    ];
    b.writeln('INSERT INTO chat_messages ($cols) VALUES (${vals.join(',')});');
  }
  b.writeln();
}

void _emitRecentViews(dynamic raw, StringBuffer b, SqlDialect d) {
  if (raw is! List) return;
  b.writeln('-- Tabla: users_recent_views');
  for (final r in raw) {
    if (r is! Map) continue;
    final cols = 'user_id,pet_id,name,photo_url,species,status,last_status,viewed_at';
    final vals = [
      _q(r['user_id'], d),
      _q(r['pet_id'], d),
      _q(r['name'], d),
      _q(r['photo_url'], d),
      _q(r['species'], d),
      _q(r['status'], d),
      _q(r['last_status'], d),
      _timestamp(r['viewed_at'])
    ];
    b.writeln('INSERT INTO users_recent_views ($cols) VALUES (${vals.join(',')});');
  }
  b.writeln();
}
