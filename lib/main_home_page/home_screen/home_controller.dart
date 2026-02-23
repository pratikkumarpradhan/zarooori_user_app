
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zarooori_user/cab_service/sample_data.dart' as sample;
import 'package:zarooori_user/models/driver_model.dart';
import 'package:zarooori_user/models/rider_model.dart';
import 'package:zarooori_user/models/vehicle_subcategory_model.dart'; // Import for Marker

class HomeController extends GetxController {
  var pickupController = TextEditingController();
  var dropoffController = TextEditingController();

  var pickup = ''.obs;
  var dropoff = ''.obs;
  var rideTypes = sample.rideTypes.obs;

  @override
  void onInit() {
    super.onInit();
    pickupController.addListener(_syncPickup);
    dropoffController.addListener(_syncDropoff);
  }

  void _syncPickup() {
    pickup.value = pickupController.text.trim();
  }

  void _syncDropoff() {
    dropoff.value = dropoffController.text.trim();
  }

  @override
  void onClose() {
    pickupController.removeListener(_syncPickup);
    dropoffController.removeListener(_syncDropoff);
    pickupController.dispose();
    dropoffController.dispose();
    super.onClose();
  }

  var isSelectingRide = false.obs;
  var selectedRideType = Rxn<RideType>();
  var selectedSubcategory = Rxn<VehicleSubcategory>();

  final RxSet<Marker> _markers = <Marker>{}.obs;
  Set<Marker> get markers => _markers.toSet();

  bool get isFormValid => pickup.value.isNotEmpty && dropoff.value.isNotEmpty;
  bool get isSubcategorySelected => selectedSubcategory.value != null;

  bool get areDriversAvailable {
    final subcat = selectedSubcategory.value;
    return subcat != null;
  }

  List<DriverModel> driverMatches() {
    if (selectedSubcategory.value == null) return [];
    return [selectedSubcategory.value!.driver];
  }

  void addMarker(LatLng position, String id, String title) {
    _markers.add(
      Marker(
        markerId: MarkerId(id),
        position: position,
        infoWindow: InfoWindow(title: title),
      ),
    );
    update(); // Notify listeners to update UI
  }

  // Handle selection of pickup and dropoff location and update text fields
  void onLocationSelected(LatLng position, String type) {
    if (type == 'pickup') {
      // Update pickup location
      pickup.value = "Lat: ${position.latitude}, Lng: ${position.longitude}";
      pickupController.text = pickup.value;
      addMarker(position, 'pickup', 'Pickup Location');
    } else if (type == 'dropoff') {
      // Update dropoff location
      dropoff.value = "Lat: ${position.latitude}, Lng: ${position.longitude}";
      dropoffController.text = dropoff.value;
      addMarker(position, 'dropoff', 'Drop-off Location');
    }
    update(); // Update UI
  }

  void resetSelection() {
    selectedRideType.value = null;
    selectedSubcategory.value = null;
    isSelectingRide.value = false;
    pickup.value = '';
    dropoff.value = '';
    pickupController.clear();
    dropoffController.clear();
  }
}