/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of esense;

/// This is the base class for this eSense sampling package.
///
/// To use this package, register it in the [carp_mobile_sensing] package using
///
/// ```
///   SamplingPackageRegistry.register(ESenseSamplingPackage());
/// ```
class ESenseSamplingPackage implements SamplingPackage {
  static const String ESENSE_BUTTON = "esense_button";
  static const String ESENSE_SENSOR = "esense_sensor";

  List<String> get dataTypes => [ESENSE_BUTTON, ESENSE_SENSOR];

  Probe create(String type) {
    switch (type) {
      case ESENSE_BUTTON:
        return ESenseButtonProbe();
      case ESENSE_SENSOR:
        return ESenseSensorProbe();
      default:
        return null;
    }
  }

  void onRegister() {
    FromJsonFactory.registerFromJsonFunction("ESenseMeasure", ESenseMeasure.fromJsonFunction);
  }

  SamplingSchema get common => SamplingSchema()
    ..type = SamplingSchemaType.COMMON
    ..name = 'Common (default) eSense sampling schema'
    ..powerAware = true
    ..measures.addEntries([
      MapEntry(
          ESENSE_BUTTON,
          ESenseMeasure(MeasureType(NameSpace.CARP, ESENSE_BUTTON),
              name: 'eSense - Button', enabled: true, deviceName: '', samplingRate: 10)),
      MapEntry(
          ESENSE_SENSOR,
          ESenseMeasure(MeasureType(NameSpace.CARP, ESENSE_SENSOR),
              name: 'eSense - Sensors', enabled: true, deviceName: '', samplingRate: 10)),
    ]);

  SamplingSchema get light => common
    ..type = SamplingSchemaType.LIGHT
    ..name = 'Light eSense sampling';

  SamplingSchema get minimum => light
    ..type = SamplingSchemaType.MINIMUM
    ..name = 'Minimum eSense sampling'
    ..measures[ESENSE_BUTTON].enabled = false
    ..measures[ESENSE_SENSOR].enabled = false;

  SamplingSchema get normal => common;

  SamplingSchema get debug => SamplingSchema()
    ..type = SamplingSchemaType.DEBUG
    ..name = 'Debugging eSense sampling schema'
    ..powerAware = false
    ..measures.addEntries([
      MapEntry(
          ESENSE_BUTTON,
          ESenseMeasure(MeasureType(NameSpace.CARP, ESENSE_BUTTON),
              name: 'eSense - Button', enabled: true, deviceName: 'eSense-0332')),
      MapEntry(
          ESENSE_SENSOR,
          ESenseMeasure(MeasureType(NameSpace.CARP, ESENSE_SENSOR),
              name: 'eSense - Sensors', enabled: true, deviceName: 'eSense-0332', samplingRate: 10)),
    ]);
}
