part of audio;

// TODO - PERMISSIONS
// This probe needs PERMISSIONS to use
//    - audio recording / microphone
//    - file access / storage
//
// If these permissions are not set, the app crashes....
// See issue on github.

/// A listening probe collecting noise data from the microphone.
///
/// See [NoiseMeasure] on how to configure this probe, including setting the
/// frequency, duration and sampling rate of the sampling rate.
///
/// Does not record sound, and instead reports the audio level with a specified frequency,
/// in a given sampling window.
class NoiseProbe extends BufferingPeriodicStreamProbe {
  static Noise _noise = Noise(400);
  DateTime _startRecordingTime;
  DateTime _endRecordingTime;
  int samplingRate;
  List<num> _noiseReadings = new List();

  Stream<Datum> get events => controller.stream;

  NoiseProbe(NoiseMeasure measure) : super(measure, _noise.noiseStream);

  void onRestart() {
    samplingRate = (measure as NoiseMeasure).samplingRate;
    _noise = Noise(samplingRate);
  }

  void onStop() {
    super.onStop();
    _noise = null;
  }

  void onSamplingEnd() {
    _endRecordingTime = DateTime.now();
  }

  void onSamplingStart() {
    // Do nothing
  }

  void onData(dynamic event) {
    _noiseReadings.add(event.decibel);
  }

  Future<Datum> getDatum() async {
    if (_noiseReadings.length > 0) {
      Stats stats = Stats.fromData(_noiseReadings);
      num mean = stats.mean;
      num std = stats.standardDeviation;
      num min = stats.min;
      num max = stats.max;
      return NoiseDatum(meanDecibel: mean, stdDecibel: std, minDecibel: min, maxDecibel: max);
    } else {
      return null;
    }
  }
}
