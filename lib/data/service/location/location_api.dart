import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:minder/data/model/personal/location_model.dart';

import '../../../core/exception/exception.dart';

class LocationAPi {
  Future<List<LocationModel>> getLocationData(String text) async {
    try {
      http.Response response = await http.get(
        Uri.parse(
            "http://mvs.bslmeiyu.com/api/v1/config/place-api-autocomplete?search_text=$text"),
        headers: {"Content-Type": "application/json"},
      );
      final Map<String, dynamic> result =
          jsonDecode(utf8.decode(response.bodyBytes));
      final List<LocationModel> locationModels = List.empty(growable: true);
      for (var element in (result["predictions"] as List)) {
        final LocationModel locationModel = LocationModel.fromJson(element);
        final position = await locationFromAddress(locationModel.description!);
        locationModel.latLng =
            LatLng(position.first.latitude, position.first.longitude);
        locationModels.add(locationModel);
      }
      return locationModels;
    } catch (e) {
      if (e is ResponseException) {
        rethrow;
      } else {
        throw ServerException();
      }
    }
  }
}
