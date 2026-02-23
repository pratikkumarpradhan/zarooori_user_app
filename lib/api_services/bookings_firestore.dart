import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zarooori_user/models/product_model.dart';


const String _usersCollection = 'newusers';
const String _bookingsSubcollection = 'bookings';

class BookingsFirestore {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Save a booking to the user's Firestore subcollection (call after API book success).
  static Future<void> saveBooking({
    required String userId,
    required String sellerCompanyId,
    required String sellerId,
    required String companyName,
    required String appointmentDate,
    required String appointmentTime,
    required String vehicleNumber,
  }) async {
    final ref = _firestore
        .collection(_usersCollection)
        .doc(userId)
        .collection(_bookingsSubcollection)
        .doc();
    await ref.set({
      'seller_company_id': sellerCompanyId,
      'seller_id': sellerId,
      'company_name': companyName,
      'appointment_date': appointmentDate,
      'appointment_time': appointmentTime,
      'vehicle_number': vehicleNumber,
      'status': 'confirmed',
      'created_at': FieldValue.serverTimestamp(),
    });
  }

  /// Fetch all bookings for the given user, newest first.
  static Future<List<BookingItem>> getMyBookings(String userId) async {
    final snapshot = await _firestore
        .collection(_usersCollection)
        .doc(userId)
        .collection(_bookingsSubcollection)
        .orderBy('created_at', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      final created = data['created_at'] is Timestamp
          ? (data['created_at'] as Timestamp).toDate()
          : null;
      return BookingItem(
        id: doc.id,
        seller_company_id: data['seller_company_id']?.toString(),
        seller_id: data['seller_id']?.toString(),
        company_name: data['company_name']?.toString(),
        appointment_date: data['appointment_date']?.toString(),
        appointment_time: data['appointment_time']?.toString(),
        vehicle_number: data['vehicle_number']?.toString(),
        status: data['status']?.toString() ?? 'confirmed',
        created_at: created,
      );
    }).toList();
  }

  /// Remove a booking (cancel) from Firestore.
  static Future<bool> cancelBooking(String userId, String bookingId) async {
    await _firestore
        .collection(_usersCollection)
        .doc(userId)
        .collection(_bookingsSubcollection)
        .doc(bookingId)
        .delete();
    return true;
  }
}