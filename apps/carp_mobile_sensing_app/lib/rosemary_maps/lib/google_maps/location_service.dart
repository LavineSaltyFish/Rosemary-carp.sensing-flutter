import './google_maps.dart';
import './maps_service.dart';
import 'location_model.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationService extends MapService<LocationModel> {
  // Singleton instance
  LocationService._() : super(_thisBaseUrl);
  static final LocationService _instance = LocationService._();
  factory LocationService() => _instance;

  static const String _thisBaseUrl =
    "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?";

  String locationInput = "";

  @override
  LocationModel? processResponseData(data) {
    return (data != null) ? LocationModel.fromMap(data as Map<String, dynamic>) : null;
  }

  @override
  void setQueryParams() {
    queryParameters = {
      'input': locationInput,
      'inputtype': 'textquery',
      'key': GoogleMaps.googleAPIKey,
    };
  }

}