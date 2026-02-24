import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:zarooori_user/models/product_model.dart';

const String _baseUrl = 'https://admin.aswack.com/api/';

class CourierApi {
  static const String masterCategoryId = '12';

  /// Fetch courier/delivery companies list (master_category_id = 12)
  static Future<List<CompanyDetails>> getCompanyList(ProductRequest request) async {
    final req = ProductRequest(
      master_category_id: masterCategoryId,
      city_id: request.city_id,
    );
    final res = await http.post(
      Uri.parse('${_baseUrl}user/list_product.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(req.toJson()),
    );
    if (res.statusCode != 200) throw Exception('Failed to load companies');
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    if (data['status'] != true) throw Exception(data['message']?.toString() ?? 'Error');
    final list = data['data'];
    if (list == null) return [];
    return (list as List)
        .map((e) => CompanyDetails.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Submit courier request
  static Future<Map<String, dynamic>?> addCourierDetails(CourierDetails details) async {
    final uri = Uri.parse('${_baseUrl}user/insert_courier.php');
    final request = http.MultipartRequest('POST', uri);

    void addPart(String name, String? value) {
      request.fields[name] = value ?? '';
    }

    addPart('seller_id', details.seller_id);
    addPart('seller_company_id', details.seller_company_id);
    addPart('user_id', details.user_id);
    addPart('item_name', details.item_name);
    addPart('weight', details.weight);
    addPart('dimensions', details.dimensions);
    addPart('description', details.description);
    addPart('from_person_name', details.from_person_name);
    addPart('from_mobile', details.from_mobile);
    addPart('from_country_id', details.from_country_id ?? '');
    addPart('from_state_id', details.from_state_id ?? '');
    addPart('from_city_id', details.from_city_id ?? '');
    addPart('from_house_no', details.from_house_no ?? '');
    addPart('from_street_name', details.from_street_name ?? '');
    addPart('from_pincode', details.from_pincode ?? '');
    addPart('to_person_name', details.to_person_name);
    addPart('to_mobile', details.to_mobile);
    addPart('to_country_id', details.to_country_id ?? '');
    addPart('to_state_id', details.to_state_id ?? '');
    addPart('to_city_id', details.to_city_id ?? '');
    addPart('to_house_no', details.to_house_no ?? '');
    addPart('to_street_name', details.to_street_name ?? '');
    addPart('to_pincode', details.to_pincode ?? '');

    for (var i = 0; i < details.imageList.length && i < 6; i++) {
      final path = details.imageList[i];
      final file = File(path);
      if (file.existsSync()) {
        request.files.add(await http.MultipartFile.fromPath('image${i + 1}', path));
      }
    }

    final streamed = await request.send();
    final res = await http.Response.fromStream(streamed);
    if (res.statusCode != 200) return null;
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    if (data['status'] != true) return null;
    return data['data'] is Map ? Map<String, dynamic>.from(data['data']) : null;
  }
}









// import 'dart:convert';
// import 'dart:io';
// import 'package:http/http.dart' as http;
// import 'package:zarooori_user/models/product_model.dart';
// import 'package:zarooori_user/others/app_http.dart';


// const String _baseUrl = 'https://admin.aswack.com/api/';

// http.Client get _client => appHttpClient;

// class CourierApi {
//   static const String masterCategoryId = '12';

//   /// Fetch courier/delivery companies list (master_category_id = 12)
//   static Future<List<CompanyDetails>> getCompanyList(ProductRequest request) async {
//     final req = ProductRequest(
//       master_category_id: masterCategoryId,
//       city_id: request.city_id,
//     );
//     final res = await _client.post(
//       Uri.parse('${_baseUrl}user/list_product.php'),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode(req.toJson()),
//     );
//     if (res.statusCode != 200) throw Exception('Failed to load companies');
//     final data = jsonDecode(res.body) as Map<String, dynamic>;
//     if (data['status'] != true) throw Exception(data['message']?.toString() ?? 'Error');
//     final list = data['data'];
//     if (list == null) return [];
//     return (list as List)
//         .map((e) => CompanyDetails.fromJson(e as Map<String, dynamic>))
//         .toList();
//   }

//   /// Submit courier request
//   static Future<Map<String, dynamic>?> addCourierDetails(CourierDetails details) async {
//     final uri = Uri.parse('${_baseUrl}user/insert_courier.php');
//     final request = http.MultipartRequest('POST', uri);

//     void addPart(String name, String? value) {
//       request.fields[name] = value ?? '';
//     }

//     addPart('seller_id', details.seller_id);
//     addPart('seller_company_id', details.seller_company_id);
//     addPart('user_id', details.user_id);
//     addPart('item_name', details.item_name);
//     addPart('weight', details.weight);
//     addPart('dimensions', details.dimensions);
//     addPart('description', details.description);
//     addPart('from_person_name', details.from_person_name);
//     addPart('from_mobile', details.from_mobile);
//     addPart('from_country_id', details.from_country_id ?? '');
//     addPart('from_state_id', details.from_state_id ?? '');
//     addPart('from_city_id', details.from_city_id ?? '');
//     addPart('from_house_no', details.from_house_no ?? '');
//     addPart('from_street_name', details.from_street_name ?? '');
//     addPart('from_pincode', details.from_pincode ?? '');
//     addPart('to_person_name', details.to_person_name);
//     addPart('to_mobile', details.to_mobile);
//     addPart('to_country_id', details.to_country_id ?? '');
//     addPart('to_state_id', details.to_state_id ?? '');
//     addPart('to_city_id', details.to_city_id ?? '');
//     addPart('to_house_no', details.to_house_no ?? '');
//     addPart('to_street_name', details.to_street_name ?? '');
//     addPart('to_pincode', details.to_pincode ?? '');

//     for (var i = 0; i < details.imageList.length && i < 6; i++) {
//       final path = details.imageList[i];
//       final file = File(path);
//       if (file.existsSync()) {
//         request.files.add(await http.MultipartFile.fromPath('image${i + 1}', path));
//       }
//     }

//     final streamed = await _client.send(request);
//     final res = await http.Response.fromStream(streamed);
//     if (res.statusCode != 200) return null;
//     final data = jsonDecode(res.body) as Map<String, dynamic>;
//     if (data['status'] != true) return null;
//     return data['data'] is Map ? Map<String, dynamic>.from(data['data']) : null;
//   }
// }
