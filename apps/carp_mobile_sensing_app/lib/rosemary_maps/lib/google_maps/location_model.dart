import 'maps_data_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class FindPlaceModel extends MapsDataModel {
  String fields;
  LatLng location;
  String name;

  FindPlaceModel({
    required this.fields,
    required this.location,
    required this.name,
  });

  // factory keyword
  // https://stackoverflow.com/questions/52299304/dart-advantage-of-a-factory-constructor-identifier
  factory FindPlaceModel.fromMap(Map<String, dynamic> map) {
    // Get route information
    print(map['candidates']);

    final data = Map<String, dynamic>.from(
        map['candidates'][0] as Map<dynamic, dynamic>);

    LatLng location = new LatLng(data["geometry"]["location"]["lat"], data["geometry"]["location"]["lng"]);
    String name = data["name"];

    return FindPlaceModel(
        fields: "formatted_address,name,geometry",
        location: location,
        name: name
    );
  }
}
