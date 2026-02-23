
import 'package:zarooori_user/models/vehicle_subcategory_model.dart';

class RideType {
  final String title;
  final List<VehicleSubcategory> subcategories;

  RideType({
    required this.title,
    required this.subcategories,
  });
}