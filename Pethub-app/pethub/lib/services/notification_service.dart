import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotificationService {
  /// Cuenta cuántas publicaciones vistas tienen un estado diferente
  static Stream<int> get pendingStatusChangeNotifications {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return const Stream.empty();

    final recentRef = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('recent_views');

    return recentRef.snapshots().asyncMap((recentSnap) async {
      int counter = 0;

      for (final doc in recentSnap.docs) {
        final data = doc.data();
        final petId = doc.id;

        final petSnap = await FirebaseFirestore.instance
            .collection('pets')
            .doc(petId)
            .get();

        if (!petSnap.exists) continue;

        final petData = petSnap.data() as Map<String, dynamic>;

        final currentStatus = petData['status'] ?? '';
        final lastStatus = data['lastStatus'] ?? '';

        if (currentStatus != lastStatus) {
          counter++;
        }
      }

      return counter;
    });
  }
}
