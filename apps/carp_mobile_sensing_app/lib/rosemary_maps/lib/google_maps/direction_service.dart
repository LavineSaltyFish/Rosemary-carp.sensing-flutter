part of rosemary_maps;

class DirectionService extends MapService<DirectionModel> {
  // Singleton instance
  DirectionService._() : super(_thisBaseUrl);
  static final DirectionService _instance = DirectionService._();
  factory DirectionService() => _instance;

  static const String _thisBaseUrl =
      'https://maps.googleapis.com/maps/api/directions/json?';
  
  LatLng origin_latlng = new LatLng(0, 0);
  set origin(LatLng ll) => origin_latlng = ll;
  LatLng get origin => origin_latlng;

  LatLng destination_latlng = new LatLng(0, 0);
  set destination(LatLng ll) => destination_latlng = ll;
  LatLng get destination => destination_latlng;

  @override
  void setQueryParams() {
    queryParameters = {
      'origin': '${origin_latlng!.latitude},${origin_latlng!.longitude}',
      'destination': '${destination_latlng!.latitude},${destination_latlng!.longitude}',
      'key': GoogleMaps.googleAPIKey,
    };
  }

  @override
  DirectionModel? processResponseData(dynamic data) {
    return (data == null) ? null : DirectionModel.fromMap(data as Map<String, dynamic>);
  }
}