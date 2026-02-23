import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Uses Firebase Auth + Firestore for auth state and user data.
/// No SharedPreferences - all data comes from Firebase.
class LocalAuthHelper {
  static Future<void> saveLoginData(String userId, Map<String, dynamic> data) async {
    // No-op: Auth state is managed by Firebase Auth.
    // User data is stored in Firestore and fetched when needed.
  }

  static Future<String?> getUserId() async {
    return FirebaseAuth.instance.currentUser?.uid;
  }

  static Future<Map<String, dynamic>?> getLoginData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return null;
    try {
      final doc = await FirebaseFirestore.instance
          .collection('newusers')
          .doc(uid)
          .get();
      if (doc.exists && doc.data() != null) {
        final data = Map<String, dynamic>.from(doc.data()!);
        data['userId'] = uid;
        return data;
      }
    } catch (_) {}
    return null;
  }

  static Future<void> clearLoginData() async {
    await FirebaseAuth.instance.signOut();
  }

  static Future<bool> isLoggedIn() async {
    return FirebaseAuth.instance.currentUser != null;
  }
}