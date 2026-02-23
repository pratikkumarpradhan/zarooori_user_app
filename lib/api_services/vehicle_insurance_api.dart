import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:zarooori_user/models/product_model.dart';


const String _baseUrl = 'https://admin.aswack.com/api/';

class VehicleInsuranceApi {
  static Future<List<ProductList>> getProductList(ProductRequest request) async {
    final res = await http.post(
      Uri.parse('${_baseUrl}user/list_product.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );
    if (res.statusCode != 200) throw Exception('Failed to load products');
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    if (data['status'] != true) throw Exception(data['message']?.toString() ?? 'Error');
    final list = data['data'];
    if (list == null) return [];
    return (list as List).map((e) => ProductList.fromJson(e as Map<String, dynamic>)).toList();
  }

  static Future<CompanyDetails?> getCompanyDetail(ProductList product) async {
    final res = await http.post(
      Uri.parse('${_baseUrl}user/get_company_detail.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(product.toJson()),
    );
    if (res.statusCode != 200) return null;
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    if (data['status'] != true) return null;
    final list = data['data'];
    if (list == null || list is! List || list.isEmpty) return null;
    return CompanyDetails.fromJson(list[0] as Map<String, dynamic>);
  }

  static Future<CompanyDetails?> getCompanyDetailByCompanyId(String companyId) async {
    final product = ProductList(seller_company_id: companyId);
    return getCompanyDetail(product);
  }

  static Future<List<SubCategory>> getInsuranceSubCategories() async {
    return getSubCategories('4');
  }

  /// Fetch company list (for Garage, Courier, etc.) - list_product returns CompanyDetails
  static Future<List<CompanyDetails>> getCompanyList(ProductRequest request) async {
    final res = await http.post(
      Uri.parse('${_baseUrl}user/list_product.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );
    if (res.statusCode != 200) throw Exception('Failed to load companies');
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    if (data['status'] != true) throw Exception(data['message']?.toString() ?? 'Error');
    final list = data['data'];
    if (list == null) return [];
    return (list as List).map((e) => CompanyDetails.fromJson(e as Map<String, dynamic>)).toList();
  }

  static Future<bool> bookAppointment(BookAppointmentRequest request) async {
    final res = await http.post(
      Uri.parse('${_baseUrl}user/book_appointment.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );
    if (res.statusCode != 200) throw Exception('Failed to book appointment');
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    return data['status'] == true;
  }

  static Future<List<SubCategory>> getSubCategories(String categoryId) async {
    final res = await http.post(
      Uri.parse('${_baseUrl}sub_category.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'category': categoryId}),
    );
    if (res.statusCode != 200) return [];
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    if (data['status'] != true) return [];
    final list = data['data'];
    if (list == null) return [];
    return (list as List).map((e) => SubCategory.fromJson(e as Map<String, dynamic>)).toList();
  }

  static Future<List<WishListItem>> getWishList(String userId, String userType) async {
    final res = await http.post(
      Uri.parse('${_baseUrl}user/list_wishlist.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'user_id': userId,
        'user_type': userType,
      }),
    );
    if (res.statusCode != 200) throw Exception('Failed to load wishlist');
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    if (data['status'] != true) throw Exception(data['message']?.toString() ?? 'Error');
    final list = data['data'];
    if (list == null) return [];
    return (list as List).map((e) => WishListItem.fromJson(e as Map<String, dynamic>)).toList();
  }

  static Future<bool> removeFromWishList(WishListItem item) async {
    final res = await http.post(
      Uri.parse('${_baseUrl}user/vehicle_whishlist.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(item.toJson()),
    );
    if (res.statusCode != 200) throw Exception('Failed to remove from wishlist');
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    return data['status'] == true;
  }
}