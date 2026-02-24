import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:zarooori_user/models/packages_model.dart';


const String _baseUrl = 'https://admin.aswack.com/api/';

class PackagesApi {
  /// Fetches purchased package list for the given user id.
  /// [userId] should be the backend user id (from getLoginData['id']) or Firebase UID.
  static Future<List<PackageData>> getPackageList(String userId) async {
    final res = await http.post(
      Uri.parse('${_baseUrl}user/package_list.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'user_id': userId}),
    );
    if (res.statusCode != 200) {
      throw Exception('Failed to load packages');
    }
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    if (data['status'] != true) {
      throw Exception(data['message']?.toString() ?? 'Failed to load packages');
    }
    final list = data['data'];
    if (list == null) return [];
    if (list is! List) return [];
    return list
        .map((e) => PackageData.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}






// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:zarooori_user/models/packages_model.dart';
// import 'package:zarooori_user/others/app_http.dart';


// const String _baseUrl = 'https://admin.aswack.com/api/';

// http.Client get _client => appHttpClient;

// class PackagesApi {
//   /// Fetches purchased package list for the given user id.
//   /// [userId] should be the backend user id (from getLoginData['id']) or Firebase UID.
//   static Future<List<PackageData>> getPackageList(String userId) async {
//     final res = await _client.post(
//       Uri.parse('${_baseUrl}user/package_list.php'),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({'user_id': userId}),
//     );
//     if (res.statusCode != 200) {
//       throw Exception('Failed to load packages');
//     }
//     final data = jsonDecode(res.body) as Map<String, dynamic>;
//     if (data['status'] != true) {
//       throw Exception(data['message']?.toString() ?? 'Failed to load packages');
//     }
//     final list = data['data'];
//     if (list == null) return [];
//     if (list is! List) return [];
//     return list
//         .map((e) => PackageData.fromJson(e as Map<String, dynamic>))
//         .toList();
//   }
// }
