import 'maps_data_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class LocationModel extends MapsDataModel {
  LatLng location;
  String name;

  LocationModel({
    required this.location,
    required this.name,
  });

  // factory keyword
  // https://stackoverflow.com/questions/52299304/dart-advantage-of-a-factory-constructor-identifier
  factory LocationModel.fromMap(Map<String, dynamic> map) {
    // Get route information
    final data = Map<String, dynamic>.from(map['candidates'][0] as Map<dynamic, dynamic>);

    LatLng location = data["geometry"]["location"];
    String name = data["geometry"]["name"];

    return LocationModel(
        location: location,
        name: name
    );
  }
}
