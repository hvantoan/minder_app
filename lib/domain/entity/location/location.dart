import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:minder/data/model/personal/location_model.dart';

class Location {
  String? description;
  LatLng? latLng;

  Location(this.description, this.latLng);

  Location.fromModel(LocationModel locationModel) {
    description = locationModel.description;
    latLng = locationModel.latLng;
  }
}
