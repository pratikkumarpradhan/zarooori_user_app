
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:zarooori_user/authentication/local/local_user_service.dart';
import 'package:zarooori_user/sos/location_service.dart';

class SosService {
  static Future<void> sendSOS({
    required String userId,
    required String locationUrl,
  }) async {
    await sendSOSToTrustedContacts();
  }

  static Future<void> sendSOSToTrustedContacts() async {
    final userId = await LocalUserService.getUserId();
    if (userId == null || userId.isEmpty) {
      throw Exception('Please register before using SOS');
    }

    final locationUrl = await LocationService.getLocationUrl();
    const message = 'EMERGENCY! I need help.\nMy location: ';
    final fullMessage = '$message$locationUrl';

    final snapshot = await FirebaseFirestore.instance
        .collection('trustedContacts')
        .doc(userId)
        .collection('contacts')
        .get();

    final phones = <String>[];
    for (final doc in snapshot.docs) {
      final data = doc.data();
      final phone = data['phone']?.toString().trim();
      if (phone != null && phone.isNotEmpty) {
        phones.add(phone.replaceAll(RegExp(r'[^\d+]'), ''));
      }
    }

    if (phones.isEmpty) {
      throw Exception('Add trusted contacts first');
    }

    final uri = Uri.parse(
      'sms:${phones.join(",")}?body=${Uri.encodeComponent(fullMessage)}',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw Exception('Cannot open SMS');
    }
  }
}