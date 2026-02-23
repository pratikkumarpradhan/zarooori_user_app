// ignore_for_file: non_constant_identifier_names
// Matches backend Offer model.

class OfferItem {
  final String? id;
  final String? title;
  final String? name;
  final String? seller_id;
  final String? seller_name;
  final String? seller_company_id;
  final String? seller_company_name;
  final String? company_seller_id;
  final String? seller_category_id;
  final String? master_category_id;
  final String? package_purchased_id;
  final String? offer_id;
  final String? offer_code;
  final String? code;
  final String? product_id;
  final String? product_name;
  final String? offer_price;
  final String? original_price;
  final String? start_date;
  final String? end_date;
  final String? description;
  final String? image_1;
  final String? image_2;
  final String? image_3;
  final String? image_4;
  final String? image_5;
  final String? image_6;
  final String? image_7;
  final String? created_id;
  final String? created_datetime;
  final String? updated_id;
  final String? updated_datetime;

  OfferItem({
    this.id,
    this.title,
    this.name,
    this.seller_id,
    this.seller_name,
    this.seller_company_id,
    this.seller_company_name,
    this.company_seller_id,
    this.seller_category_id,
    this.master_category_id,
    this.package_purchased_id,
    this.offer_id,
    this.offer_code,
    this.code,
    this.product_id,
    this.product_name,
    this.offer_price,
    this.original_price,
    this.start_date,
    this.end_date,
    this.description,
    this.image_1,
    this.image_2,
    this.image_3,
    this.image_4,
    this.image_5,
    this.image_6,
    this.image_7,
    this.created_id,
    this.created_datetime,
    this.updated_id,
    this.updated_datetime,
  });

  factory OfferItem.fromJson(Map<String, dynamic> json) {
    return OfferItem(
      id: json['id']?.toString(),
      title: json['title']?.toString(),
      name: json['name']?.toString(),
      seller_id: json['seller_id']?.toString(),
      seller_name: json['seller_name']?.toString(),
      seller_company_id: json['seller_company_id']?.toString(),
      seller_company_name: json['seller_company_name']?.toString(),
      company_seller_id: json['company_seller_id']?.toString(),
      seller_category_id: json['seller_category_id']?.toString(),
      master_category_id: json['master_category_id']?.toString(),
      package_purchased_id: json['package_purchased_id']?.toString(),
      offer_id: json['offer_id']?.toString(),
      offer_code: json['offer_code']?.toString(),
      code: json['code']?.toString(),
      product_id: json['product_id']?.toString(),
      product_name: json['product_name']?.toString(),
      offer_price: json['offer_price']?.toString(),
      original_price: json['original_price']?.toString(),
      start_date: json['start_date']?.toString(),
      end_date: json['end_date']?.toString(),
      description: json['description']?.toString(),
      image_1: json['image_1']?.toString(),
      image_2: json['image_2']?.toString(),
      image_3: json['image_3']?.toString(),
      image_4: json['image_4']?.toString(),
      image_5: json['image_5']?.toString(),
      image_6: json['image_6']?.toString(),
      image_7: json['image_7']?.toString(),
      created_id: json['created_id']?.toString(),
      created_datetime: json['created_datetime']?.toString(),
      updated_id: json['updated_id']?.toString(),
      updated_datetime: json['updated_datetime']?.toString(),
    );
  }

  String get displayName => name ?? title ?? 'Offer';
  List<String> get imageUrls {
    final list = <String>[];
    for (final url in [image_1, image_2, image_3, image_4, image_5, image_6, image_7]) {
      if (url != null && url.isNotEmpty) list.add(url);
    }
    return list;
  }
}