import 'dart:async';
import 'dart:math';

import 'package:sensors_plus/sensors_plus.dart';
import 'package:throw_your_phone/data/services/acceleration.dart';
import 'package:throw_your_phone/data/services/throw_processor.dart';
import 'package:throw_your_phone/data/services/throw_service_interface.dart';

import '../../models/throw_entry.dart';
import 'start_end_detector.dart';

class ThrowService implements IThrowService {
  var verticalThrowProcessor = VerticalThrowProcessor();
  var horizontalThrowProcessor = HorizontalThrowProcessor();

  Completer<ThrowEntry> _completer = Completer();
  final _stream = userAccelerometerEventStream(
      samplingPeriod: const Duration(milliseconds: 1));
  StreamSubscription<UserAccelerometerEvent>? _subscription;
  StartEndDetector startEndDetector =
      StartEndDetector(threshold: 0.5, endThreshold: 10);
  List<Acceleration> _accelerationData = [];
  int? _releaseTimestamp;
  bool _done = false;
  bool _firstEventSkipped = false;

  void _stopCollectingData() async {
    _done = true;
    _subscription?.cancel();
    _subscription = null;
  }

  bool shouldProcessData() {
    return !_done;
  }

  @override
  Future<void> reset() async {
    await _subscription?.cancel();
    _subscription = null;
    startEndDetector = StartEndDetector(threshold: 0.5, endThreshold: 10);
    _accelerationData = [];
    _releaseTimestamp = null;
    _done = false;
    _firstEventSkipped = false;
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
      var start = startEndDetector.start!;
      var end = startEndDetector.end!;
      processStartStopEvents(start, end);
    } else if (startEndDetector.earlyEnd != null && _releaseTimestamp != null) {
      var start = posOfFirstEventAfterTimestamp(_releaseTimestamp!);
      var end = startEndDetector.earlyEnd!;
      var endEvent = _accelerationData[end];
      if (endEvent.timestamp - _releaseTimestamp! > 100) {
        processStartStopEvents(start, end);
      }
    }
  }

  int posOfFirstEventAfterTimestamp(int timestamp) {
    for (var (i, event) in _accelerationData.indexed) {
      if (event.timestamp >= timestamp) {
        return i;
      }
    }
    return 0;
  }

  void processStartStopEvents(int start, int end) {
    _stopCollectingData();
    var height = verticalThrowProcessor.calculateDistance(
        _accelerationData, start, end, _releaseTimestamp);
    var distance = horizontalThrowProcessor.calculateDistance(
        _accelerationData, start, end, _releaseTimestamp);
    _completer.complete(ThrowEntry(
        distance: distance, height: height, dateTime: DateTime.now()));
  }

  void processData(UserAccelerometerEvent event) {
    if (!shouldProcessData()) {
      return;
    }
    if (!_firstEventSkipped) {
      _firstEventSkipped = true;
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

  @override
  Future<ThrowEntry> beginThrow() {
    _beginThrow();
    _completer = Completer();
    return _completer.future;
  }

  @override
  void setReleaseTimestamp() {
    _releaseTimestamp = DateTime.now().millisecondsSinceEpoch;
  }
}
