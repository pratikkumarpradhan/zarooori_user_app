import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:zarooori_user/models/offers_model.dart';


const String _baseUrl = 'https://admin.aswack.com/api/';

class OffersApi {
  /// Fetches offer list for the given master category id.
  static Future<List<OfferItem>> getOfferList(String masterCategoryId) async {
    final res = await http.post(
      Uri.parse('${_baseUrl}user/get_offer_detail.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'master_category_id': masterCategoryId}),
    );
    if (res.statusCode != 200) {
      throw Exception('Failed to load offers');
    }
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    if (data['status'] != true) {
      throw Exception(data['message']?.toString() ?? 'Failed to load offers');
    }
    final list = data['data'];
    if (list == null) return [];
    if (list is! List) return [];
    return list
        .map((e) => OfferItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}






// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:zarooori_user/models/offers_model.dart';
// import 'package:zarooori_user/others/app_http.dart';


// const String _baseUrl = 'https://admin.aswack.com/api/';

// http.Client get _client => appHttpClient;

// class OffersApi {
//   /// Fetches offer list for the given master category id.
//   static Future<List<OfferItem>> getOfferList(String masterCategoryId) async {
//     final res = await _client.post(
//       Uri.parse('${_baseUrl}user/get_offer_detail.php'),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({'master_category_id': masterCategoryId}),
//     );
//     if (res.statusCode != 200) {
//       throw Exception('Failed to load offers');
//     }
//     final data = jsonDecode(res.body) as Map<String, dynamic>;
//     if (data['status'] != true) {
//       throw Exception(data['message']?.toString() ?? 'Failed to load offers');
//     }
//     final list = data['data'];
//     if (list == null) return [];
//     if (list is! List) return [];
//     return list
//         .map((e) => OfferItem.fromJson(e as Map<String, dynamic>))
//         .toList();
//   }
// }
