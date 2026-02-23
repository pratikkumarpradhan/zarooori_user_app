// ignore_for_file: non_constant_identifier_names
// API uses snake_case for JSON keys

const String _imageBaseUrl = 'https://admin.aswack.com';

String resolveImageUrl(String? url) {
  if (url == null || url.isEmpty) return '';
  if (url.startsWith('http://') || url.startsWith('https://')) return url;
  return url.startsWith('/') ? '$_imageBaseUrl$url' : '$_imageBaseUrl/$url';
}

class BuyVehicle {
  String? category;
  String? user_id;
  String? user_type;
  String? vehicle_cat;
  List<String> vehicle_brand;
  List<String> vehicle_type;
  List<String> vehicle_model;
  List<String> vehicle_year;
  List<String> vehicle_fuel;
  String? transmission;
  String? city_id;

  BuyVehicle({
    this.category,
    this.user_id,
    this.user_type = '0',
    this.vehicle_cat,
    List<String>? vehicle_brand,
    List<String>? vehicle_type,
    List<String>? vehicle_model,
    List<String>? vehicle_year,
    List<String>? vehicle_fuel,
    this.transmission,
    this.city_id = '0',
  })  : vehicle_brand = vehicle_brand ?? [],
        vehicle_type = vehicle_type ?? [],
        vehicle_model = vehicle_model ?? [],
        vehicle_year = vehicle_year ?? [],
        vehicle_fuel = vehicle_fuel ?? [];

  Map<String, dynamic> toJson() => {
        'category': category,
        'user_id': user_id,
        'user_type': user_type,
        'vehicle_cat': vehicle_cat,
        'vehicle_brand': vehicle_brand,
        'vehicle_type': vehicle_type,
        'vehicle_model': vehicle_model,
        'vehicle_year': vehicle_year,
        'vehicle_fuel': vehicle_fuel,
        'transmission': transmission,
        'city_id': city_id ?? '0',
      };
}

class SellVehicle {
  String? id;
  String? category;
  String? advertisement_code;
  String? seller_company_id;
  String? seller_company_name;
  String? user_id;
  String? seller_name;
  String? user_type;
  String? package_purchased_id;
  String? vehicle_brand_name;
  String? vehicle_type_name;
  String? vehicle_model_name;
  String? vehicle_year_name;
  String? vehicle_fuel_name;
  String? transmission;
  String? title;
  String? price;
  String? description;
  String? contact_number;
  String? image1;
  String? image2;
  String? image3;
  String? created_datetime;

  SellVehicle({
    this.id,
    this.category,
    this.advertisement_code,
    this.seller_company_id,
    this.seller_company_name,
    this.user_id,
    this.seller_name,
    this.user_type,
    this.package_purchased_id,
    this.vehicle_brand_name,
    this.vehicle_type_name,
    this.vehicle_model_name,
    this.vehicle_year_name,
    this.vehicle_fuel_name,
    this.transmission,
    this.title,
    this.price,
    this.description,
    this.contact_number,
    this.image1,
    this.image2,
    this.image3,
    this.created_datetime,
  });

  factory SellVehicle.fromJson(Map<String, dynamic> json) => SellVehicle(
        id: json['id']?.toString(),
        category: json['category']?.toString(),
        advertisement_code: json['advertisement_code']?.toString(),
        seller_company_id: json['seller_company_id']?.toString(),
        seller_company_name: json['seller_company_name']?.toString(),
        user_id: json['user_id']?.toString(),
        seller_name: json['seller_name']?.toString(),
        user_type: json['user_type']?.toString(),
        package_purchased_id: json['package_purchased_id']?.toString(),
        vehicle_brand_name: json['vehicle_brand_name']?.toString(),
        vehicle_type_name: json['vehicle_type_name']?.toString(),
        vehicle_model_name: json['vehicle_model_name']?.toString(),
        vehicle_year_name: json['vehicle_year_name']?.toString(),
        vehicle_fuel_name: json['vehicle_fuel_name']?.toString(),
        transmission: json['transmission']?.toString(),
        title: json['title']?.toString(),
        price: json['price']?.toString(),
        description: json['description']?.toString(),
        contact_number: json['contact_number']?.toString(),
        image1: json['image_1']?.toString() ?? json['image1']?.toString(),
        image2: json['image_2']?.toString() ?? json['image2']?.toString(),
        image3: json['image_3']?.toString() ?? json['image3']?.toString(),
        created_datetime: json['created_datetime']?.toString(),
      );
}

class BrandsTypesModels {
  String? vehicle_brand_name;
  String? vehicle_brand_id;
  List<BrandType> type_list;

  BrandsTypesModels({
    this.vehicle_brand_name,
    this.vehicle_brand_id,
    List<BrandType>? type_list,
  }) : type_list = type_list ?? [];

  factory BrandsTypesModels.fromJson(Map<String, dynamic> json) => BrandsTypesModels(
        vehicle_brand_name: json['vehicle_company_name']?.toString() ?? json['vehicle_brand_name']?.toString(),
        vehicle_brand_id: json['vehicle_company_id']?.toString() ?? json['vehicle_brand_id']?.toString(),
        type_list: (json['type_list'] as List<dynamic>?)
                ?.map((e) => BrandType.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
      );
}

class BrandType {
  String? vehicle_type_name;
  String? vehicle_type_id;
  List<BrandTypeModel> model_list;

  BrandType({
    this.vehicle_type_name,
    this.vehicle_type_id,
    List<BrandTypeModel>? model_list,
  }) : model_list = model_list ?? [];

  factory BrandType.fromJson(Map<String, dynamic> json) => BrandType(
        vehicle_type_name: json['vehicle_type_name']?.toString(),
        vehicle_type_id: json['vehicle_type_id']?.toString(),
        model_list: (json['model_list'] as List<dynamic>?)
                ?.map((e) => BrandTypeModel.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
      );
}

class BrandTypeModel {
  String? vehicle_model_name;
  String? vehicle_model_id;

  BrandTypeModel({this.vehicle_model_name, this.vehicle_model_id});

  factory BrandTypeModel.fromJson(Map<String, dynamic> json) => BrandTypeModel(
        vehicle_model_name: json['vehicle_model_name']?.toString(),
        vehicle_model_id: json['vehicle_model_id']?.toString(),
      );
}

class YearItem {
  String? id;
  String? year;

  YearItem({this.id, this.year});

  factory YearItem.fromJson(Map<String, dynamic> json) => YearItem(
        id: json['id']?.toString(),
        year: json['year']?.toString(),
      );
}

class FuelItem {
  String? id;
  String? fuel;

  FuelItem({this.id, this.fuel});

  factory FuelItem.fromJson(Map<String, dynamic> json) => FuelItem(
        id: json['id']?.toString(),
        fuel: json['fuel']?.toString(),
      );
}

class StateItem {
  String? id;
  String? name;

  StateItem({this.id, this.name});

  factory StateItem.fromJson(Map<String, dynamic> json) => StateItem(
        id: json['id']?.toString(),
        name: json['state_name']?.toString() ?? json['name']?.toString(),
      );
}

class CityItem {
  String? id;
  String? name;

  CityItem({this.id, this.name});

  factory CityItem.fromJson(Map<String, dynamic> json) => CityItem(
        id: json['id']?.toString(),
        name: json['city_name']?.toString() ?? json['name']?.toString(),
      );
}