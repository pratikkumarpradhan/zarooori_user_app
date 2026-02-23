import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationService {
  static Future<String> getLocationUrl() async {
    await Permission.location.request();

    Position pos = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );

    return "https://www.google.com/maps?q=${pos.latitude},${pos.longitude}";
  }
}