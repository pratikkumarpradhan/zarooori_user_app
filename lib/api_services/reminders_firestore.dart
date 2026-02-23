import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zarooori_user/models/product_model.dart';


const String _usersCollection = 'newusers';
const String _remindersSubcollection = 'reminders';

class RemindersFirestore {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Save a reminder to the user's Firestore subcollection.
  static Future<void> saveReminder({
    required String userId,
    required String title,
    required String description,
    required String date,
    required String time,
  }) async {
    final ref = _firestore
        .collection(_usersCollection)
        .doc(userId)
        .collection(_remindersSubcollection)
        .doc();
    await ref.set({
      'title': title,
      'description': description,
      'date': date,
      'time': time,
      'created_at': FieldValue.serverTimestamp(),
    });
  }

  /// Fetch all reminders for the given user, newest first.
  static Future<List<ReminderItem>> getMyReminders(String userId) async {
    final snapshot = await _firestore
        .collection(_usersCollection)
        .doc(userId)
        .collection(_remindersSubcollection)
        .orderBy('created_at', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      final created = data['created_at'] is Timestamp
          ? (data['created_at'] as Timestamp).toDate()
          : null;
      return ReminderItem(
        id: doc.id,
        title: data['title']?.toString(),
        description: data['description']?.toString(),
        date: data['date']?.toString(),
        time: data['time']?.toString(),
        created_at: created,
      );
    }).toList();
  }

  /// Remove a reminder from Firestore.
  static Future<bool> deleteReminder(String userId, String reminderId) async {
    await _firestore
        .collection(_usersCollection)
        .doc(userId)
        .collection(_remindersSubcollection)
        .doc(reminderId)
        .delete();
    return true;
  }

  /// Update a reminder in Firestore.
  static Future<void> updateReminder({
    required String userId,
    required String reminderId,
    required String title,
    required String description,
    required String date,
    required String time,
  }) async {
    await _firestore
        .collection(_usersCollection)
        .doc(userId)
        .collection(_remindersSubcollection)
        .doc(reminderId)
        .update({
      'title': title,
      'description': description,
      'date': date,
      'time': time,
    });
  }
}