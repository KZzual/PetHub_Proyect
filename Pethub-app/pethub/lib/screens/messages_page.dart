// 1. ¡AQUÍ ESTÁ EL IMPORT QUE FALTABA!
import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class MessagesPage extends StatelessWidget {
  const MessagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Esta página NO tiene su propio Scaffold o AppBar,
    // porque es controlada por MainShell.
    return ListView(
      padding: const EdgeInsets.all(8.0),
      children: const [
        // Usaremos un widget personalizado para cada item de la lista
        _MessageListItem(
          userName: 'María González',
          lastMessage: 'Hola, ¿Luna todavía está dispo...',
          time: '', // La captura no muestra hora para este
          unreadCount: 2,
          avatarUrl: 'https://placehold.co/100x100/EAA0A2/white?text=M',
        ),
        _MessageListItem(
          userName: 'Carlos Ruiz',
          lastMessage: 'Gracias por la información sobr...',
          time: '1:15 PM',
          unreadCount: 0, // 0 significa que no muestra badge
          avatarUrl: 'https://placehold.co/100x100/A2B9EA/white?text=C',
        ),
        _MessageListItem(
          userName: 'Ana Silva',
          lastMessage: '¿Podríamos conocer a Bella e...',
          time: '11:45 AM',
          unreadCount: 1,
          avatarUrl: 'https://placehold.co/100x100/EADAB2/white?text=A',
        ),
      ],
    );
  }
}

// --- Widget Privado para el Item de la Lista de Mensajes ---

class _MessageListItem extends StatelessWidget {
  final String userName;
  final String lastMessage;
  final String time;
  final int unreadCount;
  final String avatarUrl;

  const _MessageListItem({
    required this.userName,
    required this.lastMessage,
    required this.time,
    required this.unreadCount,
    required this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      color: AppColors.background, // Fondo blanco de la tarjeta
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        leading: CircleAvatar(
          radius: 25,
          backgroundImage: NetworkImage(avatarUrl),
          backgroundColor: AppColors.accent,
        ),
        title: Text(
          userName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        subtitle: Text(
          lastMessage,
          style: const TextStyle(color: Colors.grey),
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (time.isNotEmpty) // Solo muestra el tiempo si no está vacío
              Text(
                time,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            const SizedBox(height: 4),
            // Mostramos el badge solo si hay mensajes no leídos
            if (unreadCount > 0)
              _UnreadBadge(count: unreadCount)
            else
              const SizedBox(height: 20), // Espacio para alinear
          ],
        ),
        onTap: () {
          // Lógica para abrir la conversación
        },
      ),
    );
  }
}

// --- Widget Privado para el Badge Azul de No Leídos ---

class _UnreadBadge extends StatelessWidget {
  final int count;

  const _UnreadBadge({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: const BoxDecoration(
        color: Colors.blue, // Color del badge
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          count.toString(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

