/**
 *  notificacion de chat nuevo mensaje
 *
 *  Descripción:
 *  Esta función se activa cuando se crea un nuevo documento en la subcolección
 *  "messages" de un chat específico en Firestore. Su propósito es enviar una
 *  notificación push al receptor del mensaje utilizando Firebase Cloud Messaging (FCM).
 */

const { onDocumentCreated } = require("firebase-functions/v2/firestore");
const { initializeApp } = require("firebase-admin/app");
const { getFirestore, FieldValue } = require("firebase-admin/firestore");
const { getMessaging } = require("firebase-admin/messaging");

initializeApp();

exports.notifyNewMessage = onDocumentCreated(
  "chats/{chatId}/messages/{msgId}",
  async (event) => {
    const snap = event.data;
    const context = event.params;

    const msg = snap.data();
    const chatId = context.chatId;

    const senderId = msg.senderId;
    const text = msg.text || "Nuevo mensaje";

    console.log("Nuevo mensaje detectado:", msg);

    // 1. Obtener datos del chat
    const db = getFirestore();
    const chatRef = db.collection("chats").doc(chatId);
    const chatSnap = await chatRef.get();

    if (!chatSnap.exists) {
      console.log("Chat no existe");
      return;
    }

    const chat = chatSnap.data();
    const users = chat.users || [];

    // 2. Identificar receptor
    const receiverId = users.find((u) => u !== senderId);

    if (!receiverId) {
      console.log(" No se encontró receptor");
      return;
    }

    // 3. Obtener datos del emisor
    const senderName =
      chat.participants?.[senderId]?.name || "Usuario";

    // 4. Obtener token del receptor
    const receiverRef = db.collection("users").doc(receiverId);
    const receiverSnap = await receiverRef.get();

    if (!receiverSnap.exists) {
      console.log("No existe el usuario receptor");
      return;
    }

    const token = receiverSnap.data().fcmToken;

    if (!token) {
      console.log("Usuario sin token FCM");
      return;
    }

    // 5. Incrementar unreadCount del receptor
    try {
      await chatRef.update({
        unreadCount: FieldValue.increment(1),
      });
    } catch (e) {
      console.log("Error al incrementar unreadCount:", e);
    }

    // 6. Payload notification
    const payload = {
      token: token,
      notification: {
        title: `Mensaje de ${senderName}`,
        body: text,
      },
      data: {
        chatId: chatId,
        senderId: senderId,
      },
      android: {
        priority: "high",
      },
      apns: {
        payload: {
          aps: {
            sound: "default",
            contentAvailable: true,
          },
        },
      },
    };

    // 7. Enviar notificación
    try {
      await getMessaging().send(payload);
      console.log("✅ Notificación enviada correctamente");
    } catch (error) {
      console.error("🔥 Error al enviar notificación:", error);
    }
  }
);

const { onDocumentUpdated } = require("firebase-functions/v2/firestore");
const { initializeApp } = require("firebase-admin/app");
const { getFirestore } = require("firebase-admin/firestore");
const { getMessaging } = require("firebase-admin/messaging");

initializeApp();

/**
 * NOTIFICAR CAMBIO DE ESTADO DE MASCOTA
 * Detecta cuando "status" cambia en un documento de /pets/{petId}
 */
exports.notifyPetStatusChange = onDocumentUpdated(
  "pets/{petId}",
  async (event) => {
    const before = event.data.before.data();
    const after = event.data.after.data();
    const petId = event.params.petId;

    const oldStatus = (before.status || "").trim();
    const newStatus = (after.status || "").trim();

    console.log("🐾 Revisando cambio de estado:", { oldStatus, newStatus });

    // --- Si el estado NO cambió, no notificamos ---
    if (oldStatus === newStatus) {
      console.log("➖ No hubo cambio de estado. No se envía notificación.");
      return;
    }

    // Obtener dueño
    const userId = after.userId;
    if (!userId) {
      console.log(" Mascota sin userId");
      return;
    }

    const db = getFirestore();

    // Datos del dueño (para obtener token FCM)
    const userSnap = await db.collection("users").doc(userId).get();
    if (!userSnap.exists) {
      console.log( " Dueño no existe");
      return;
    }

    const fcmToken = userSnap.data().fcmToken;
    if (!fcmToken) {
      console.log(" Dueño sin token FCM");
      return;
    }

    // Nombre mascota
    const petName = after.name || "Tu mascota";

    // Texto dinámico
    const title =
      newStatus === "Adoptado"
        ? `¡${petName} ha sido adoptado!`
        : `${petName} está nuevamente en adopción`;

    const body =
      newStatus === "Adoptado"
        ? "Tu publicación fue marcada como adoptada."
        : "Tu mascota vuelve a estar disponible.";

    // Payload FCM
    const payload = {
      token: fcmToken,
      notification: {
        title,
        body,
      },
      data: {
        petId: petId,
        newStatus: newStatus,
      },
      android: {
        priority: "high",
      },
    };

    try {
      await getMessaging().send(payload);
      console.log(" Notificación enviada correctamente");
    } catch (error) {
      console.error(" Error al enviar notificación:", error);
    }
  }
);
