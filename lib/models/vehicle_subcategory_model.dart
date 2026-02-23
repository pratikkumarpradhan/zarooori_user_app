
import 'package:zarooori_user/models/driver_model.dart';

class VehicleSubcategory {
  final String name;
  final double fareEstimate;
  final DriverModel driver;

  VehicleSubcategory({
    required this.name,
    required this.fareEstimate,
    required this.driver,
  });
}