// Sample User Data
import 'package:zarooori_user/models/driver_model.dart';
import 'package:zarooori_user/models/rider_model.dart';
import 'package:zarooori_user/models/user_model.dart';
import 'package:zarooori_user/models/vehicle_subcategory_model.dart';

final Usermodel sampleUser = Usermodel(
  id: 'u001',
  name: 'Junaid Mehmood',
  email: 'junaid.mehmood@example.com',
  imageUrl: 'https://randomuser.me/api/portraits/men/32.jpg',
  phoneNumber: '',
  createdAt: DateTime.now(),
);

// Sample Driver Data (part of VehicleSubcategory)
final DriverModel aliKhanDriver = DriverModel(
  id: 'd001',
  name: 'Ali Khan',
  rating: 4.8,
  vehicleDetails: 'Toyota Corolla - White',
  imageUrl: 'https://randomuser.me/api/portraits/men/11.jpg',
  fare: 5.0,
);

// Sample VehicleSubcategories for Economy Ride
final List<VehicleSubcategory> economySubcategories = [
  VehicleSubcategory(
    name: 'Toyota Corolla',
    fareEstimate: 5.0,
    driver: aliKhanDriver,
  ),
  VehicleSubcategory(
    name: 'Honda Civic',
    fareEstimate: 5.5,
    driver: DriverModel(
      id: 'd002',
      name: 'Sara Ahmed',
      rating: 4.7,
      vehicleDetails: 'Honda Civic - Black',
      imageUrl: 'https://randomuser.me/api/portraits/women/21.jpg',
      fare: 5.5,
    ),
  ),
  VehicleSubcategory(
    name: 'Ford Focus',
    fareEstimate: 6.0,
    driver: DriverModel(
      id: 'd003',
      name: 'Usman Malik',
      rating: 4.9,
      vehicleDetails: 'Ford Focus - Blue',
      imageUrl: 'https://randomuser.me/api/portraits/men/31.jpg',
      fare: 6.0,
    ),
  ),
];

// Sample RideTypes list
final List<RideType> rideTypes = [
  RideType(title: 'Economy Ride', subcategories: economySubcategories),
  RideType(
    title: 'Premium Ride',
    subcategories: [
      VehicleSubcategory(
        name: 'BMW 5 Series',
        fareEstimate: 10.0,
        driver: DriverModel(
          id: 'd004',
          name: 'Ayesha Noor',
          rating: 4.9,
          vehicleDetails: 'BMW 5 Series - Black',
          imageUrl: 'https://randomuser.me/api/portraits/women/11.jpg',
          fare: 10.0,
        ),
      ),
      VehicleSubcategory(
        name: 'Audi A6',
        fareEstimate: 11.0,
        driver: DriverModel(
          id: 'd005',
          name: 'Hamza Ali',
          rating: 4.8,
          vehicleDetails: 'Audi A6 - Grey',
          imageUrl: 'https://randomuser.me/api/portraits/men/12.jpg',
          fare: 11.0,
        ),
      ),
      VehicleSubcategory(
        name: 'Mercedes E-Class',
        fareEstimate: 12.0,
        driver: DriverModel(
          id: 'd006',
          name: 'Nadia Raza',
          rating: 5.0,
          vehicleDetails: 'Mercedes E-Class - Silver',
          imageUrl: 'https://randomuser.me/api/portraits/women/13.jpg',
          fare: 12.0,
        ),
      ),
    ],
  ),
  RideType(
    title: 'XL Ride',
    subcategories: [
      VehicleSubcategory(
        name: 'Toyota Innova',
        fareEstimate: 8.0,
        driver: DriverModel(
          id: 'd007',
          name: 'Zain Qureshi',
          rating: 4.6,
          vehicleDetails: 'Toyota Innova - White',
          imageUrl: 'https://randomuser.me/api/portraits/men/14.jpg',
          fare: 8.0,
        ),
      ),
      VehicleSubcategory(
        name: 'Honda Odyssey',
        fareEstimate: 9.0,
        driver: DriverModel(
          id: 'd008',
          name: 'Fatima Khan',
          rating: 4.7,
          vehicleDetails: 'Honda Odyssey - Grey',
          imageUrl: 'https://randomuser.me/api/portraits/women/15.jpg',
          fare: 9.0,
        ),
      ),
      VehicleSubcategory(
        name: 'Ford Expedition',
        fareEstimate: 9.5,
        driver: DriverModel(
          id: 'd009',
          name: 'Imran Shah',
          rating: 4.8,
          vehicleDetails: 'Ford Expedition - Black',
          imageUrl: 'https://randomuser.me/api/portraits/men/16.jpg',
          fare: 9.5,
        ),
      ),
    ],
  ),
];