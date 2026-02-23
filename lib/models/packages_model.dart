// ignore_for_file: non_constant_identifier_names
// Models for purchased packages (matches backend PackageData).

class PackageData {
  final String? id;
  final String? title;
  final String? tilte;
  final String? currency_id;
  final String? package_image;
  final String? price;
  final String? description;
  final String? post;
  final String? duration;
  final String? start_date;
  final String? end_date;
  final String? paid_amount;
  final String? package_status;

  PackageData({
    this.id,
    this.title,
    this.tilte,
    this.currency_id,
    this.package_image,
    this.price,
    this.description,
    this.post,
    this.duration,
    this.start_date,
    this.end_date,
    this.paid_amount,
    this.package_status,
  });

  factory PackageData.fromJson(Map<String, dynamic> json) {
    return PackageData(
      id: json['id']?.toString(),
      title: json['title']?.toString() ?? json['tilte']?.toString(),
      tilte: json['tilte']?.toString(),
      currency_id: json['currency_id']?.toString(),
      package_image: json['package_image']?.toString(),
      price: json['price']?.toString(),
      description: json['description']?.toString(),
      post: json['post']?.toString(),
      duration: json['duration']?.toString(),
      start_date: json['start_date']?.toString(),
      end_date: json['end_date']?.toString(),
      paid_amount: json['paid_amount']?.toString(),
      package_status: json['package_status']?.toString(),
    );
  }

  String get displayTitle => title ?? tilte ?? 'Package';
  bool get isRunning => package_status == '2';
}