import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationHelper {
  static double distance(LatLng startLatLng, LatLng endLatLng) {
    final distance = Geolocator.distanceBetween(startLatLng.latitude,
            startLatLng.longitude, endLatLng.latitude, endLatLng.longitude) /
        1000;

    return distance;
  }

  static Future<String> address(LatLng latLng) async {
    List<Placemark> placeMarks =
        await placemarkFromCoordinates(latLng.latitude, latLng.longitude);
    final placeMark = placeMarks.first;
    final address =
        "${placeMark.street}, ${placeMark.subAdministrativeArea}, ${placeMark.administrativeArea}";
    return address;
  }
}
