-keep class com.google.firebase.messaging.FirebaseMessagingService { *; }
-keep class com.google.firebase.iid.FirebaseInstanceIdReceiver { *; }

# Si tienes servicios propios de notificaciones
-keepclassmembers class com.duocdevs.pethub.** {
    *;
}
