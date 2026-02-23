import 'package:cloud_firestore/cloud_firestore.dart';

class Usermodel {
  final String id;
  final String name;
  final String email;
  final String phoneNumber;
  final String imageUrl;
  final String? homeAddress;
  final String? workAddress;
  final String? currentLocation; // For storing last known location
  final String? fcmToken; // For push notifications
  final bool isActive; // For soft-deactivation
  final DateTime createdAt;

  Usermodel({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.imageUrl,
    this.homeAddress,
    this.workAddress,
    this.currentLocation,
    this.fcmToken,
    this.isActive = true,
    required this.createdAt,
  });

  // For saving to Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'imageUrl': imageUrl,
      'homeAddress': homeAddress,
      'workAddress': workAddress,
      'currentLocation': currentLocation,
      'fcmToken': fcmToken,
      'isActive': isActive,
      'createdAt': createdAt,
    };
  }

  // For loading from Firestore
  factory Usermodel.fromMap(Map<String, dynamic> map) {
    return Usermodel(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      phoneNumber: map['phoneNumber'],
      imageUrl: map['imageUrl'],
      homeAddress: map['homeAddress'],
      workAddress: map['workAddress'],
      currentLocation: map['currentLocation'],
      fcmToken: map['fcmToken'],
      isActive: map['isActive'] ?? true,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }
}