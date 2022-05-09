/*
 * Copyright 2018-2022 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of context;

/// Collects location information from the underlying OS's location API.
/// Is a [DatumProbe] that collects a [LocationDatum].
/// Takes a [LocationMeasure] as configuration.
class LocationProbe extends DatumProbe {
  Future<void> onResume() async {
    await LocationManager()
        .configure(samplingConfiguration as LocationSamplingConfiguration);
    super.onResume();
  }

  Future<Datum> getDatum() async => LocationManager()
      .getLocation()
      .then((location) => LocationDatum.fromLocation(location));
}

/// Collects geolocation information from the underlying OS's location API.
/// Is a [StreamProbe] that generates a [LocationDatum] every time location is changed.
///
/// Note that in order for location tracking to work with this probe, the
/// phone must be online on the internet, since Google APIs are used.
class GeoLocationProbe extends StreamProbe {
  Future<void> onResume() async {
    await LocationManager()
        .configure(samplingConfiguration as LocationSamplingConfiguration);
    super.onResume();
  }

  Stream<LocationDatum> get stream => LocationManager()
      .onLocationChanged
      .map((location) => LocationDatum.fromLocation(location));
}
