import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:zarooori_user/models/buy_vehicle_model.dart';


const String _baseUrl = 'https://admin.aswack.com/api/';

class VehicleCategoryItem {
  final String id;
  final String name;
  final String? imageUrl;

  VehicleCategoryItem({required this.id, required this.name, this.imageUrl});
}

class BuyVehicleApi {
  static Future<List<VehicleCategoryItem>> getVehicleCategories({String type = '0'}) async {
    final res = await http.post(
      Uri.parse('${_baseUrl}vehicle_category.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'type': type}),
    );
    if (res.statusCode != 200) return [];
    try {
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      if (data['status'] != true) return [];
      final list = data['data'];
      if (list == null || list is! List) return [];
      return list.map((e) {
        final m = e as Map<String, dynamic>;
        final id = m['id']?.toString() ?? '';
        final name = m['name']?.toString() ?? m['vehicle_cat_name']?.toString() ?? 'Unknown';
        final img = m['image']?.toString();
        return VehicleCategoryItem(id: id, name: name, imageUrl: img);
      }).where((v) => v.id.isNotEmpty).toList();
    } catch (_) {
      return [];
    }
  }

  static Future<List<BrandsTypesModels>> getBrandsTypesModels(String category) async {
    try {
      final res = await http.post(
        Uri.parse('${_baseUrl}vehicle_brand.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'category': category}),
      );
      if (res.statusCode != 200) return [];
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      if (data['status'] != true) return [];
      final list = data['data'];
      if (list == null || list is! List) return [];
      return list.map((e) => BrandsTypesModels.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return [];
    }
  }

  static Future<List<YearItem>> getYearList() async {
    final res = await http.get(Uri.parse('${_baseUrl}vehicle_year.php'));
    if (res.statusCode != 200) throw Exception('Failed to load years');
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    if (data['status'] != true) throw Exception(data['message']?.toString() ?? 'Error');
    final list = data['data'];
    if (list == null) return [];
    return (list as List).map((e) => YearItem.fromJson(e as Map<String, dynamic>)).toList();
  }

  static Future<List<FuelItem>> getFuelList() async {
    final res = await http.get(Uri.parse('${_baseUrl}vehicle_fuel.php'));
    if (res.statusCode != 200) throw Exception('Failed to load fuels');
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    if (data['status'] != true) throw Exception(data['message']?.toString() ?? 'Error');
    final list = data['data'];
    if (list == null) return [];
    return (list as List).map((e) => FuelItem.fromJson(e as Map<String, dynamic>)).toList();
  }

  static Future<List<StateItem>> getStateList(String countryId) async {
    final res = await http.post(
      Uri.parse('${_baseUrl}state_list.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'country': countryId}),
    );
    if (res.statusCode != 200) throw Exception('Failed to load states');
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    if (data['status'] != true) return [];
    final list = data['data'];
    if (list == null) return [];
    return (list as List).map((e) => StateItem.fromJson(e as Map<String, dynamic>)).toList();
  }

  static Future<List<CityItem>> getCityList(String stateId) async {
    final res = await http.post(
      Uri.parse('${_baseUrl}city_list.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'state': stateId}),
    );
    if (res.statusCode != 200) throw Exception('Failed to load cities');
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    if (data['status'] != true) return [];
    final list = data['data'];
    if (list == null) return [];
    return (list as List).map((e) => CityItem.fromJson(e as Map<String, dynamic>)).toList();
  }

  static Future<List<SellVehicle>> searchBuyVehicles(BuyVehicle filter) async {
    final res = await http.post(
      Uri.parse('${_baseUrl}user/vehicle_buy_list.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(filter.toJson()),
    );
    if (res.statusCode != 200) throw Exception('Failed to search vehicles');
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    if (data['status'] != true) throw Exception(data['message']?.toString() ?? 'Error');
    final list = data['data'];
    if (list == null) return [];
    return (list as List).map((e) => SellVehicle.fromJson(e as Map<String, dynamic>)).toList();
  }

  static Future<Object?> insertSellVehicle(Map<String, dynamic> payload) async {
    final res = await http.post(
      Uri.parse('${_baseUrl}user/insert_vehicle.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    if (res.statusCode != 200) {
      return data['message']?.toString() ?? 'Failed to submit';
    }
    if (data['status'] != true) {
      return data['message']?.toString() ?? 'Failed to submit';
    }
    return true;
  }
}






// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:zarooori_user/models/buy_vehicle_model.dart';
// import 'package:zarooori_user/others/app_http.dart';


// const String _baseUrl = 'https://admin.aswack.com/api/';

// http.Client get _client => appHttpClient;

// class VehicleCategoryItem {
//   final String id;
//   final String name;
//   final String? imageUrl;

//   VehicleCategoryItem({required this.id, required this.name, this.imageUrl});
// }

// class BuyVehicleApi {
//   static Future<List<VehicleCategoryItem>> getVehicleCategories({String type = '0'}) async {
//     final res = await _client.post(
//       Uri.parse('${_baseUrl}vehicle_category.php'),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({'type': type}),
//     );
//     if (res.statusCode != 200) return [];
//     try {
//       final data = jsonDecode(res.body) as Map<String, dynamic>;
//       if (data['status'] != true) return [];
//       final list = data['data'];
//       if (list == null || list is! List) return [];
//       return list.map((e) {
//         final m = e as Map<String, dynamic>;
//         final id = m['id']?.toString() ?? '';
//         final name = m['name']?.toString() ?? m['vehicle_cat_name']?.toString() ?? 'Unknown';
//         final img = m['image']?.toString();
//         return VehicleCategoryItem(id: id, name: name, imageUrl: img);
//       }).where((v) => v.id.isNotEmpty).toList();
//     } catch (_) {
//       return [];
//     }
//   }

//   static Future<List<BrandsTypesModels>> getBrandsTypesModels(String category) async {
//     try {
//       final res = await _client.post(
//         Uri.parse('${_baseUrl}vehicle_brand.php'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({'category': category}),
//       );
//       if (res.statusCode != 200) return [];
//       final data = jsonDecode(res.body) as Map<String, dynamic>;
//       if (data['status'] != true) return [];
//       final list = data['data'];
//       if (list == null || list is! List) return [];
//       return list.map((e) => BrandsTypesModels.fromJson(e as Map<String, dynamic>)).toList();
//     } catch (_) {
//       return [];
//     }
//   }

//   static Future<List<YearItem>> getYearList() async {
//     final res = await _client.get(Uri.parse('${_baseUrl}vehicle_year.php'));
//     if (res.statusCode != 200) throw Exception('Failed to load years');
//     final data = jsonDecode(res.body) as Map<String, dynamic>;
//     if (data['status'] != true) throw Exception(data['message']?.toString() ?? 'Error');
//     final list = data['data'];
//     if (list == null) return [];
//     return (list as List).map((e) => YearItem.fromJson(e as Map<String, dynamic>)).toList();
//   }

//   static Future<List<FuelItem>> getFuelList() async {
//     final res = await _client.get(Uri.parse('${_baseUrl}vehicle_fuel.php'));
//     if (res.statusCode != 200) throw Exception('Failed to load fuels');
//     final data = jsonDecode(res.body) as Map<String, dynamic>;
//     if (data['status'] != true) throw Exception(data['message']?.toString() ?? 'Error');
//     final list = data['data'];
//     if (list == null) return [];
//     return (list as List).map((e) => FuelItem.fromJson(e as Map<String, dynamic>)).toList();
//   }

//   static Future<List<StateItem>> getStateList(String countryId) async {
//     final res = await _client.post(
//       Uri.parse('${_baseUrl}state_list.php'),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({'country': countryId}),
//     );
//     if (res.statusCode != 200) throw Exception('Failed to load states');
//     final data = jsonDecode(res.body) as Map<String, dynamic>;
//     if (data['status'] != true) return [];
//     final list = data['data'];
//     if (list == null) return [];
//     return (list as List).map((e) => StateItem.fromJson(e as Map<String, dynamic>)).toList();
//   }

//   static Future<List<CityItem>> getCityList(String stateId) async {
//     final res = await _client.post(
//       Uri.parse('${_baseUrl}city_list.php'),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({'state': stateId}),
//     );
//     if (res.statusCode != 200) throw Exception('Failed to load cities');
//     final data = jsonDecode(res.body) as Map<String, dynamic>;
//     if (data['status'] != true) return [];
//     final list = data['data'];
//     if (list == null) return [];
//     return (list as List).map((e) => CityItem.fromJson(e as Map<String, dynamic>)).toList();
//   }

//   static Future<List<SellVehicle>> searchBuyVehicles(BuyVehicle filter) async {
//     final res = await _client.post(
//       Uri.parse('${_baseUrl}user/vehicle_buy_list.php'),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode(filter.toJson()),
//     );
//     if (res.statusCode != 200) throw Exception('Failed to search vehicles');
//     final data = jsonDecode(res.body) as Map<String, dynamic>;
//     if (data['status'] != true) throw Exception(data['message']?.toString() ?? 'Error');
//     final list = data['data'];
//     if (list == null) return [];
//     return (list as List).map((e) => SellVehicle.fromJson(e as Map<String, dynamic>)).toList();
//   }

//   static Future<Object?> insertSellVehicle(Map<String, dynamic> payload) async {
//     final res = await _client.post(
//       Uri.parse('${_baseUrl}user/insert_vehicle.php'),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode(payload),
//     );
//     final data = jsonDecode(res.body) as Map<String, dynamic>;
//     if (res.statusCode != 200) {
//       return data['message']?.toString() ?? 'Failed to submit';
//     }
//     if (data['status'] != true) {
//       return data['message']?.toString() ?? 'Failed to submit';
//     }
//     return true;
//   }
// }
