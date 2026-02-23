import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zarooori_user/models/product_model.dart';


const String _usersCollection = 'newusers';
const String _ordersSubcollection = 'orders';

class OrdersFirestore {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Save an order to the user's Firestore subcollection.
  static Future<void> saveOrder({
    required String userId,
    required String orderCode,
    String? quotationId,
    String? invoiceId,
    String? invoiceCode,
    String? sellerId,
    String? sellerName,
    String? sellerCompanyId,
    String? sellerCompanyName,
    String? userName,
    String? txnDate,
    String? txnId,
    String? paymentStatus,
    String? paidAmount,
    String? remark,
    String? status,
  }) async {
    final ref = _firestore
        .collection(_usersCollection)
        .doc(userId)
        .collection(_ordersSubcollection)
        .doc();
    await ref.set({
      'order_code': orderCode,
      'quotation_id': quotationId,
      'invoice_id': invoiceId,
      'invoice_code': invoiceCode,
      'seller_id': sellerId,
      'seller_name': sellerName,
      'seller_company_id': sellerCompanyId,
      'seller_company_name': sellerCompanyName,
      'user_name': userName,
      'txn_date': txnDate,
      'txn_id': txnId,
      'payment_status': paymentStatus ?? 'pending',
      'paid_amount': paidAmount,
      'remark': remark,
      'status': status ?? 'pending',
      'created_at': FieldValue.serverTimestamp(),
    });
  }

  /// Fetch all orders for the given user, newest first.
  static Future<List<OrderItem>> getMyOrders(String userId) async {
    final snapshot = await _firestore
        .collection(_usersCollection)
        .doc(userId)
        .collection(_ordersSubcollection)
        .orderBy('created_at', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      final created = data['created_at'] is Timestamp
          ? (data['created_at'] as Timestamp).toDate()
          : null;
      return OrderItem(
        id: doc.id,
        order_code: data['order_code']?.toString(),
        quotation_id: data['quotation_id']?.toString(),
        invoice_id: data['invoice_id']?.toString(),
        invoice_code: data['invoice_code']?.toString(),
        seller_id: data['seller_id']?.toString(),
        seller_name: data['seller_name']?.toString(),
        seller_company_id: data['seller_company_id']?.toString(),
        seller_company_name: data['seller_company_name']?.toString(),
        user_name: data['user_name']?.toString(),
        txn_date: data['txn_date']?.toString(),
        txn_id: data['txn_id']?.toString(),
        payment_status: data['payment_status']?.toString(),
        paid_amount: data['paid_amount']?.toString(),
        remark: data['remark']?.toString(),
        status: data['status']?.toString(),
        created_at: created,
      );
    }).toList();
  }

  /// Update order status.
  static Future<void> updateOrderStatus({
    required String userId,
    required String orderId,
    String? status,
    String? paymentStatus,
  }) async {
    final updates = <String, dynamic>{};
    if (status != null) updates['status'] = status;
    if (paymentStatus != null) updates['payment_status'] = paymentStatus;
    await _firestore
        .collection(_usersCollection)
        .doc(userId)
        .collection(_ordersSubcollection)
        .doc(orderId)
        .update(updates);
  }
}