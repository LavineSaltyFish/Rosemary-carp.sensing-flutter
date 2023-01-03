part of rosemary_maps;

class FindPlaceService extends MapService<FindPlaceModel> {
  // Singleton instance
  FindPlaceService._() : super(_thisBaseUrl);
  static final FindPlaceService _instance = FindPlaceService._();
  factory FindPlaceService() => _instance;

  static const String _thisBaseUrl =
    "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?";

  String locationInput = "";
  String fields = "formatted_address,name,geometry";

  @override
  FindPlaceModel? processResponseData(data) {
    return (data != null) ? FindPlaceModel.fromMap(data as Map<String, dynamic>) : null;
  }

  @override
  void setQueryParams() {
    queryParameters = {
      'fields': fields,
      'input': locationInput,
      'inputtype': 'textquery',
      'key': GoogleMaps.googleAPIKey,
    };
  }

}