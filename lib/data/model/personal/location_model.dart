import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationModel {
  String? description;
  LatLng? latLng;

  LocationModel(this.description, this.latLng);

  LocationModel.fromJson(Map<String, dynamic> json) {
    description = json["description"];
  }
}
