part of context;

/// Collects local weather information using the [WeatherFactory] API.
class WeatherProbe extends DatumProbe {
  late WeatherFactory _wf;

  void onInitialize() {
    _wf = WeatherFactory(
        (samplingConfiguration as WeatherSamplingConfiguration).apiKey);
  }

  Future<void> onResume() async {
    await LocationManager().configure();
    super.onResume();
  }

  /// Returns the [WeatherDatum] for this location.
  Future<Datum> getDatum() async {
    try {
      final loc = await LocationManager().getLastKnownLocation();
      final Weather weather = await _wf.currentWeatherByLocation(
        loc.latitude!,
        loc.longitude!,
      );

      return WeatherDatum()
        ..country = weather.country
        ..areaName = weather.areaName
        ..weatherMain = weather.weatherMain
        ..weatherDescription = weather.weatherDescription
        ..date = weather.date
        ..sunrise = weather.sunrise
        ..sunset = weather.sunset
        ..latitude = weather.latitude
        ..longitude = weather.longitude
        ..pressure = weather.pressure
        ..windSpeed = weather.windSpeed
        ..windDegree = weather.windDegree
        ..humidity = weather.humidity
        ..cloudiness = weather.cloudiness
        ..rainLastHour = weather.rainLastHour
        ..rainLast3Hours = weather.rainLast3Hours
        ..snowLastHour = weather.snowLastHour
        ..snowLast3Hours = weather.snowLast3Hours
        ..temperature = weather.temperature!.celsius
        ..tempMin = weather.tempMin!.celsius
        ..tempMax = weather.tempMax!.celsius;
    } catch (err) {
      warning('$runtimeType - Error getting weather - $err');
      return ErrorDatum('WeatherProbe Exception: $err');
    }
  }
}
