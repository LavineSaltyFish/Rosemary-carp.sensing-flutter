// part of rosemary_maps;

import 'maps_data_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class DirectionModel extends MapsDataModel {
  LatLngBounds bounds;
  List<PointLatLng> polylinePoints;
  String? totalDistance;
  String? totalDuration;

  DirectionModel({
    required this.bounds,
    required this.polylinePoints,
    this.totalDistance,
    this.totalDuration,
  });

  // factory keyword
  // https://stackoverflow.com/questions/52299304/dart-advantage-of-a-factory-constructor-identifier
  factory DirectionModel.fromMap(Map<String, dynamic> map) {
    // // Check if route is not available
    // if ((map['routes'] as List).isEmpty)
    //   return null;

    // Get route information
    final data = Map<String, dynamic>.from(map['routes'][0] as Map<dynamic, dynamic>);

    // Bounds
    final northeast = data['bounds']['northeast'];
    final southwest = data['bounds']['southwest'];
    final bounds = LatLngBounds(
      northeast: LatLng(northeast['lat'] as double, northeast['lng'] as double),
      southwest: LatLng(southwest['lat'] as double, southwest['lng'] as double),
    );

    // Distance & Duration
    String distance = '';
    String duration = '';
    if ((data['legs'] as List).isNotEmpty) {
      final leg = data['legs'][0];
      distance = leg['distance']['text'].toString();
      duration = leg['duration']['text'].toString();
    }

    return DirectionModel(
      bounds: bounds,
      polylinePoints:
        PolylinePoints().decodePolyline(data['overview_polyline']['points'].toString()),
      totalDistance: distance,
      totalDuration: duration,
    );
  }

  // factory DirectionModel.createDefault() {
  //   return DirectionModel(
  //   bounds: new LatLngBounds(),
  //   polylinePoints:
  //   PolylinePoints().decodePolyline(data['overview_polyline']['points'].toString()),
  //   totalDistance: distance,
  //   totalDuration: duration,
  //   );
  // }
}