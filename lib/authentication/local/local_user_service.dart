import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Service to get user registration data for Trusted Contacts & SOS.
/// Uses native SharedPreferences first, then falls back to Firebase Auth + Firestore.
class LocalUserService {
  static const MethodChannel _channel = MethodChannel('com.avdhootsolutions.aswack/user_data');

  /// Get user registration data from native Android SharedPreferences
  /// Returns a map with 'mobile', 'email', 'name' fields
  /// Returns null if user is not registered or data is not available
  static Future<Map<String, String>?> getUserData() async {
    try {
      final result = await _channel.invokeMethod('getUserData');
      if (result != null && result is Map) {
        return Map<String, String>.from(result);
      }
      return null;
    } on PlatformException catch (e) {
      print('Error getting user data: ${e.message}');
      return null;
    }
  }

  /// Get user ID for Trusted Contacts (mobile preferred, then email).
  /// 1. Firebase Auth + Firestore (primary - for logged-in users)
  /// 2. Native SharedPreferences (fallback)
  /// Returns null only if user is not registered/logged in anywhere
  static Future<String?> getUserId() async {
    // 1. Primary: Firebase Auth + Firestore (when user is logged in)
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final doc = await FirebaseFirestore.instance
            .collection('newusers')
            .doc(user.uid)
            .get();

        if (doc.exists && doc.data() != null) {
          final data = doc.data()!;
          final mobile = data['mobile']?.toString().trim() ??
              data['phone']?.toString().trim() ??
              data['phoneNumber']?.toString().trim();
          final email = data['email']?.toString().trim();
          if (mobile != null && mobile.isNotEmpty) return _normalizePhone(mobile);
          if (email != null && email.isNotEmpty) return email;
        }
        return user.uid;
      }
    } catch (_) {}

    // 2. Fallback: Native SharedPreferences
    try {
      final userData = await getUserData();
      if (userData != null) {
        final phone = userData['mobile']?.trim();
        final email = userData['email']?.trim();
        if (phone != null && phone.isNotEmpty) return _normalizePhone(phone);
        if (email != null && email.isNotEmpty) return email;
      }
    } catch (_) {}

    return null;
  }

  static String _normalizePhone(String phone) {
    final digits = phone.replaceAll(RegExp(r'[^\d+]'), '');
    return digits.isNotEmpty ? digits : phone;
  }
}