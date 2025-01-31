import 'dart:async';
import 'dart:math';

import 'package:sensors_plus/sensors_plus.dart';
import 'package:throw_your_phone/data/services/acceleration.dart';

import 'change_detector.dart';

class ThrowService {
   Completer<double> _completer = new Completer();
  final _stream = userAccelerometerEventStream(
      samplingPeriod: const Duration(milliseconds: 1));
  StreamSubscription<UserAccelerometerEvent>? _subscription;
  StartEndDetector startEndDetector =
      StartEndDetector(threshold: 0.5, endThreshold: 5.0);
  List<Acceleration> _accelerationData = [];
  int? _releaseTimestamp;
  bool _done = false;

  void _stopCollectingData() async {
    _done = true;
    _subscription?.cancel();
    _subscription = null;
  }

  bool shouldProcessData() {
    return !_done;
  }

  Future reset() async {
    await _subscription?.cancel();
    _subscription = null;
    startEndDetector = StartEndDetector(threshold: 0.5, endThreshold: 5);
    _accelerationData = [];
    _releaseTimestamp = null;
    _done = false;
  }

  processNewEvent(
      Acceleration firstEvent, Acceleration lastEvent, Acceleration event) {
    var t = event.timestamp - firstEvent.timestamp;

    var aLast =
        sqrt(pow(lastEvent.x, 2) + pow(lastEvent.y, 2) + pow(lastEvent.z, 2));
    var a = sqrt(pow(event.x, 2) + pow(event.y, 2) + pow(event.z, 2));

    var da = (a - aLast).abs();
    startEndDetector.processNext(da, t);
    if (startEndDetector.start != null && startEndDetector.end != null) {
      _stopCollectingData();
      var start = startEndDetector.start!;
      var end = startEndDetector.end!;

      var endEvent = _accelerationData[start];
      var startEvent = _accelerationData[end];
      var startTimestamp = max(startEvent.timestamp, _releaseTimestamp!);
      var flightTimeSeconds = (endEvent.timestamp - startTimestamp) / 1000;

      var heightMeters = 1 / 8 * 9.81 * flightTimeSeconds * flightTimeSeconds;
      _completer.complete(heightMeters);
    }
  }

  void processData(UserAccelerometerEvent event) {
    if (!shouldProcessData()) {
      return;
    }
    var acceleration = Acceleration(
        x: event.x,
        y: event.y,
        z: event.z,
        timestamp: event.timestamp.millisecondsSinceEpoch);

    if (_accelerationData.isEmpty) {
      _accelerationData.add(acceleration);
      return;
    }

    var lastAcceleration = _accelerationData.last;
    var firstAcceleration = _accelerationData.first;

    _accelerationData.add(acceleration);
    processNewEvent(firstAcceleration, lastAcceleration, acceleration);
  }

   _beginThrow() {
    // stop collecting accelerometer events
    if (_subscription != null) {
      throw Exception("Already collecting data.");
    }
    // start collecting accelerometer events
    _subscription = _stream.listen(
      (UserAccelerometerEvent event) {
        // print(
        //     "${event.timestamp.millisecondsSinceEpoch},${event.x},${event.y},${event.z}");
        processData(event);
      },
      onError: (error) {
        throw Exception("Accelerometer not available.");
      },
      cancelOnError: true,
    );
  }

  void beginHorizontalThrow() {}

  Future<double> beginVerticalThrow() {
    _beginThrow();
    _completer = new Completer();
    return _completer.future;
  }

  void setReleaseTimestamp() {
    _releaseTimestamp = DateTime.now().millisecondsSinceEpoch;
  }
}
