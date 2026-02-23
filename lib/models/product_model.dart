// ignore_for_file: non_constant_identifier_names

class ProductRequest {
  String? id;
  String? user_id;
  String city_id;
  List<String> state;
  List<String> city;
  String? vehicle_category_id;
  String? master_category_id;
  String? master_subcategory_id;
  String? vehicle_company;
  String? vehicle_type;
  String? vehicle_model;
  String? vehicle_year;

  ProductRequest({
    this.id,
    this.user_id,
    this.city_id = '0',
    List<String>? state,
    List<String>? city,
    this.vehicle_category_id,
    this.master_category_id,
    this.master_subcategory_id,
    this.vehicle_company,
    this.vehicle_type,
    this.vehicle_model,
    this.vehicle_year,
  })  : state = state ?? [],
        city = city ?? [];

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': user_id,
        'city_id': city_id,
        'state': state,
        'city': city,
        'vehicle_category_id': vehicle_category_id,
        'master_category_id': master_category_id,
        'master_subcategory_id': master_subcategory_id,
        'vehicle_company': vehicle_company,
        'vehicle_type': vehicle_type,
        'vehicle_model': vehicle_model,
        'vehicle_year': vehicle_year,
      };
}

class ProductList {
  String? id;
  String? product_code;
  String? seller_id;
  String? seller_name;
  String? seller_company_id;
  String? seller_company_name;
  String? vehicle_company_name;
  String? vehicle_type_name;
  String? vehicle_model_name;
  String? vehicle_year_name;
  String? product_name;
  String? price;
  String? description;
  String? image1;
  String? image2;
  String? image3;
  String? image4;
  String? image5;
  String? image6;
  String? image7;
  String? created_datetime;
  String? master_category_id;
  String? vehicle_cat_id;

  ProductList({
    this.id,
    this.product_code,
    this.seller_id,
    this.seller_name,
    this.seller_company_id,
    this.seller_company_name,
    this.vehicle_company_name,
    this.vehicle_type_name,
    this.vehicle_model_name,
    this.vehicle_year_name,
    this.product_name,
    this.price,
    this.description,
    this.image1,
    this.image2,
    this.image3,
    this.image4,
    this.image5,
    this.image6,
    this.image7,
    this.created_datetime,
    this.master_category_id,
    this.vehicle_cat_id,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'product_code': product_code,
        'seller_id': seller_id,
        'seller_company_id': seller_company_id,
        'vehicle_company_name': vehicle_company_name,
        'vehicle_type_name': vehicle_type_name,
        'vehicle_model_name': vehicle_model_name,
        'product_name': product_name,
        'price': price,
        'description': description,
        'image_1': image1,
        'image_2': image2,
        'image_3': image3,
      };

  factory ProductList.fromJson(Map<String, dynamic> json) => ProductList(
        id: json['id']?.toString(),
        product_code: json['product_code']?.toString(),
        seller_id: json['seller_id']?.toString(),
        seller_name: json['seller_name']?.toString(),
        seller_company_id: json['seller_company_id']?.toString(),
        seller_company_name: json['seller_company_name']?.toString(),
        vehicle_company_name: json['vehicle_company_name']?.toString(),
        vehicle_type_name: json['vehicle_type_name']?.toString(),
        vehicle_model_name: json['vehicle_model_name']?.toString(),
        vehicle_year_name: json['vehicle_year_name']?.toString(),
        product_name: json['product_name']?.toString(),
        price: json['price']?.toString(),
        description: json['description']?.toString(),
        image1: json['image_1']?.toString() ?? json['image1']?.toString(),
        image2: json['image_2']?.toString() ?? json['image2']?.toString(),
        image3: json['image_3']?.toString() ?? json['image3']?.toString(),
        image4: json['image_4']?.toString() ?? json['image4']?.toString(),
        image5: json['image_5']?.toString() ?? json['image5']?.toString(),
        image6: json['image_6']?.toString() ?? json['image6']?.toString(),
        image7: json['image_7']?.toString() ?? json['image7']?.toString(),
        created_datetime: json['created_datetime']?.toString(),
        master_category_id: json['master_category_id']?.toString(),
        vehicle_cat_id: json['vehicle_cat_id']?.toString(),
      );
}

class CompanyDetails {
  String? id;
  String? seller_id;
  String? company_name;
  String? owner_name;
  String? company_phone;
  String? company_mobile;
  String? company_alt_mobile;
  String? company_email_id;
  String? company_website;
  String? image;
  String? company_address;
  String? desciption;
  String? specialize_in;
  String? building_number;
  String? street_number;
  String? landmark;
  String? city_id;
  String? pincode;
  String? company_type; // 0=Company, 1=Freelancer

  CompanyDetails({
    this.id,
    this.seller_id,
    this.company_name,
    this.owner_name,
    this.company_phone,
    this.company_mobile,
    this.company_alt_mobile,
    this.company_email_id,
    this.company_website,
    this.image,
    this.company_address,
    this.desciption,
    this.specialize_in,
    this.building_number,
    this.street_number,
    this.landmark,
    this.city_id,
    this.pincode,
    this.company_type,
  });

  factory CompanyDetails.fromJson(Map<String, dynamic> json) => CompanyDetails(
        id: json['id']?.toString(),
        seller_id: json['seller_id']?.toString(),
        company_name: json['company_name']?.toString(),
        owner_name: json['owner_name']?.toString(),
        company_phone: json['company_phone']?.toString(),
        company_mobile: json['company_mobile']?.toString(),
        company_alt_mobile: json['company_alt_mobile']?.toString(),
        company_email_id: json['company_email_id']?.toString(),
        company_website: json['company_website']?.toString(),
        image: json['image']?.toString(),
        company_address: json['company_address']?.toString(),
        desciption: json['desciption']?.toString(),
        specialize_in: json['specialize_in']?.toString(),
        building_number: json['building_number']?.toString(),
        street_number: json['street_number']?.toString(),
        landmark: json['landmark']?.toString(),
        city_id: json['city_id']?.toString(),
        pincode: json['pincode']?.toString(),
        company_type: json['company_type']?.toString(),
      );

  String get fullAddress {
    var addr = <String>[];
    if (building_number?.isNotEmpty == true) addr.add(building_number!);
    if (street_number?.isNotEmpty == true) addr.add(street_number!);
    if (landmark?.isNotEmpty == true) addr.add(landmark!);
    final cityPart = <String>[];
    if (city_id?.isNotEmpty == true) cityPart.add(city_id!);
    if (pincode?.isNotEmpty == true) cityPart.add(pincode!);
    if (cityPart.isNotEmpty) addr.add(cityPart.join(' - '));
    return addr.join(', ');
  }

  String? get contactNumber =>
      (company_mobile?.isNotEmpty == true)
          ? company_mobile
          : (company_alt_mobile?.isNotEmpty == true)
              ? company_alt_mobile
              : company_phone;
}

class CourierDetails {
  String? id;
  String? user_id;
  String? seller_id;
  String? seller_name;
  String? seller_company_id;
  String? seller_company_name;
  String? item_name;
  String? weight;
  String? dimensions;
  String? description;
  String? from_person_name;
  String? from_mobile;
  String? from_country_id;
  String? from_state_id;
  String? from_city_id;
  String? from_house_no;
  String? from_street_name;
  String? from_pincode;
  String? to_person_name;
  String? to_mobile;
  String? to_country_id;
  String? to_state_id;
  String? to_city_id;
  String? to_house_no;
  String? to_street_name;
  String? to_pincode;
  List<String> imageList;

  CourierDetails({
    this.id,
    this.user_id,
    this.seller_id,
    this.seller_name,
    this.seller_company_id,
    this.seller_company_name,
    this.item_name,
    this.weight,
    this.dimensions,
    this.description,
    this.from_person_name,
    this.from_mobile,
    this.from_country_id,
    this.from_state_id,
    this.from_city_id,
    this.from_house_no,
    this.from_street_name,
    this.from_pincode,
    this.to_person_name,
    this.to_mobile,
    this.to_country_id,
    this.to_state_id,
    this.to_city_id,
    this.to_house_no,
    this.to_street_name,
    this.to_pincode,
    List<String>? imageList,
  }) : imageList = imageList ?? [];
}

class BookAppointmentRequest {
  String? user_id;
  String? seller_id;
  String? seller_company_id;
  String? vehicle_category;
  String? vehicle_company;
  String? vehicle_type;
  String? vehicle_model;
  String? vehicle_number;
  String? appointment_date;
  String? appointment_time;

  BookAppointmentRequest({
    this.user_id,
    this.seller_id,
    this.seller_company_id,
    this.vehicle_category,
    this.vehicle_company,
    this.vehicle_type,
    this.vehicle_model,
    this.vehicle_number,
    this.appointment_date,
    this.appointment_time,
  });

  Map<String, dynamic> toJson() => {
        'user_id': user_id,
        'seller_id': seller_id,
        'seller_company_id': seller_company_id,
        'vehicle_category': vehicle_category,
        'vehicle_company': vehicle_company,
        'vehicle_type': vehicle_type,
        'vehicle_model': vehicle_model,
        'vehicle_number': vehicle_number,
        'appointment_date': appointment_date,
        'appointment_time': appointment_time,
      };
}

class SubCategory {
  String? id;
  String? cat_id;
  String? sub_cat_name;
  String? sub_cat_image;

  SubCategory({this.id, this.cat_id, this.sub_cat_name, this.sub_cat_image});

  factory SubCategory.fromJson(Map<String, dynamic> json) => SubCategory(
        id: json['id']?.toString(),
        cat_id: json['cat_id']?.toString(),
        sub_cat_name: json['sub_cat_name']?.toString(),
        sub_cat_image: json['sub_cat_image']?.toString(),
      );
}

class WishListItem {
  String? id;
  String? user_id;
  String? user_type;
  String? master_category_id;
  String? master_category_name;
  String? vehicle_category;
  String? product_id;
  String? product_name;
  String? product_description;
  String? product_price;
  String? product_image;

  WishListItem({
    this.id,
    this.user_id,
    this.user_type,
    this.master_category_id,
    this.master_category_name,
    this.vehicle_category,
    this.product_id,
    this.product_name,
    this.product_description,
    this.product_price,
    this.product_image,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': user_id,
        'user_type': user_type,
        'master_category_id': master_category_id,
        'master_category_name': master_category_name,
        'vehicle_category': vehicle_category,
        'product_id': product_id,
        'product_name': product_name,
        'product_description': product_description,
        'product_price': product_price,
        'product_image': product_image,
        'operationtype': 'remove',
      };

  factory WishListItem.fromJson(Map<String, dynamic> json) => WishListItem(
        id: json['id']?.toString(),
        user_id: json['user_id']?.toString(),
        user_type: json['user_type']?.toString(),
        master_category_id: json['master_category_id']?.toString(),
        master_category_name: json['master_category_name']?.toString(),
        vehicle_category: json['vehicle_category']?.toString(),
        product_id: json['product_id']?.toString(),
        product_name: json['product_name']?.toString(),
        product_description: json['product_description']?.toString(),
        product_price: json['product_price']?.toString(),
        product_image: json['product_image']?.toString(),
      );
}

/// Represents a user booking/appointment (from Firestore or API).
class BookingItem {
  String? id;
  String? user_id;
  String? seller_company_id;
  String? seller_id;
  String? company_name;
  String? appointment_date;
  String? appointment_time;
  String? vehicle_number;
  String? status;
  DateTime? created_at;

  BookingItem({
    this.id,
    this.user_id,
    this.seller_company_id,
    this.seller_id,
    this.company_name,
    this.appointment_date,
    this.appointment_time,
    this.vehicle_number,
    this.status,
    this.created_at,
  });

  factory BookingItem.fromJson(Map<String, dynamic> json) => BookingItem(
        id: json['id']?.toString(),
        user_id: json['user_id']?.toString(),
        seller_company_id: json['seller_company_id']?.toString(),
        seller_id: json['seller_id']?.toString(),
        company_name: json['company_name']?.toString(),
        appointment_date: json['appointment_date']?.toString(),
        appointment_time: json['appointment_time']?.toString(),
        vehicle_number: json['vehicle_number']?.toString(),
        status: json['status']?.toString(),
        created_at: json['created_at'] != null
            ? (json['created_at'] is DateTime
                ? json['created_at'] as DateTime
                : DateTime.tryParse(json['created_at'].toString()))
            : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': user_id,
        'seller_company_id': seller_company_id,
        'seller_id': seller_id,
        'company_name': company_name,
        'appointment_date': appointment_date,
        'appointment_time': appointment_time,
        'vehicle_number': vehicle_number,
        'status': status ?? 'confirmed',
        'created_at': created_at?.toIso8601String(),
      };
}

/// Represents a user reminder (from Firestore or API).
class ReminderItem {
  String? id;
  String? user_id;
  String? title;
  String? description;
  String? date;
  String? time;
  DateTime? created_at;

  ReminderItem({
    this.id,
    this.user_id,
    this.title,
    this.description,
    this.date,
    this.time,
    this.created_at,
  });

  factory ReminderItem.fromJson(Map<String, dynamic> json) => ReminderItem(
        id: json['id']?.toString(),
        user_id: json['user_id']?.toString(),
        title: json['title']?.toString(),
        description: json['description']?.toString(),
        date: json['date']?.toString(),
        time: json['time']?.toString(),
        created_at: json['created_at'] != null
            ? (json['created_at'] is DateTime
                ? json['created_at'] as DateTime
                : DateTime.tryParse(json['created_at'].toString()))
            : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': user_id,
        'title': title,
        'description': description,
        'date': date,
        'time': time,
        'created_at': created_at?.toIso8601String(),
      };
}

/// Represents a user order (from Firestore or API).
class OrderItem {
  String? id;
  String? order_code;
  String? quotation_id;
  String? invoice_id;
  String? invoice_code;
  String? seller_id;
  String? seller_name;
  String? seller_company_id;
  String? seller_company_name;
  String? user_id;
  String? user_name;
  String? txn_date;
  String? txn_id;
  String? payment_status;
  String? paid_amount;
  String? remark;
  String? status;
  String? created_datetime;
  DateTime? created_at;

  OrderItem({
    this.id,
    this.order_code,
    this.quotation_id,
    this.invoice_id,
    this.invoice_code,
    this.seller_id,
    this.seller_name,
    this.seller_company_id,
    this.seller_company_name,
    this.user_id,
    this.user_name,
    this.txn_date,
    this.txn_id,
    this.payment_status,
    this.paid_amount,
    this.remark,
    this.status,
    this.created_datetime,
    this.created_at,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        id: json['id']?.toString(),
        order_code: json['order_code']?.toString(),
        quotation_id: json['quotation_id']?.toString(),
        invoice_id: json['invoice_id']?.toString(),
        invoice_code: json['invoice_code']?.toString(),
        seller_id: json['seller_id']?.toString(),
        seller_name: json['seller_name']?.toString(),
        seller_company_id: json['seller_company_id']?.toString(),
        seller_company_name: json['seller_company_name']?.toString(),
        user_id: json['user_id']?.toString(),
        user_name: json['user_name']?.toString(),
        txn_date: json['txn_date']?.toString(),
        txn_id: json['txn_id']?.toString(),
        payment_status: json['payment_status']?.toString(),
        paid_amount: json['paid_amount']?.toString(),
        remark: json['remark']?.toString(),
        status: json['status']?.toString(),
        created_datetime: json['created_datetime']?.toString(),
        created_at: json['created_at'] != null
            ? (json['created_at'] is DateTime
                ? json['created_at'] as DateTime
                : DateTime.tryParse(json['created_at'].toString()))
            : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'order_code': order_code,
        'quotation_id': quotation_id,
        'invoice_id': invoice_id,
        'invoice_code': invoice_code,
        'seller_id': seller_id,
        'seller_name': seller_name,
        'seller_company_id': seller_company_id,
        'seller_company_name': seller_company_name,
        'user_id': user_id,
        'user_name': user_name,
        'txn_date': txn_date,
        'txn_id': txn_id,
        'payment_status': payment_status,
        'paid_amount': paid_amount,
        'remark': remark,
        'status': status,
        'created_datetime': created_datetime,
        'created_at': created_at?.toIso8601String(),
      };
}