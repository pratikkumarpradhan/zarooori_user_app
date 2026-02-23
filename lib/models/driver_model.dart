class DriverModel {
  final String id;
  final String name;
  final double rating;
  final String vehicleDetails;
  final String imageUrl;
  final double fare;
  final String? phoneNumber;

  DriverModel({
    required this.id,
    required this.name,
    required this.rating,
    required this.vehicleDetails,
    required this.imageUrl,
    required this.fare,
    this.phoneNumber,
  });

  factory DriverModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return DriverModel(
        id: 'unknown',
        name: 'Unknown',
        rating: 0.0,
        vehicleDetails: 'N/A',
        imageUrl: '',
        fare: 0.0,
      );
    }
    return DriverModel(
      id: json['id'] ?? 'unknown',
      name: json['name'] ?? 'Unknown',
      rating:
          (json['rating'] is num) ? (json['rating'] as num).toDouble() : 0.0,
      vehicleDetails: json['vehicleDetails'] ?? 'N/A',
      imageUrl: json['imageUrl'] ?? '',
      fare: (json['fare'] is num) ? (json['fare'] as num).toDouble() : 0.0,
      phoneNumber: json['phoneNumber'],
    );
  }
}