import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gm;

/// Real interactive Google Map focused on India.
class CourierMapWidget extends StatelessWidget {
  final double height;

  const CourierMapWidget({super.key, this.height = 200});

  static const gm.LatLng _indiaCenter = gm.LatLng(20.5937, 78.9629);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: gm.GoogleMap(
          initialCameraPosition: gm.CameraPosition(
            target: _indiaCenter,
            zoom: 5,
          ),
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          zoomControlsEnabled: false,
          mapToolbarEnabled: false,
        ),
      ),
    );
  }
}