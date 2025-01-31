import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:throw_your_phone/data/services/change_detector.dart';
import 'package:throw_your_phone/ui/throw/throw_instructions_dialog.dart';
import 'package:throw_your_phone/ui/throw/throw_screen_view_model.dart';
import 'package:sensors_plus/sensors_plus.dart';

class ThrowScreen extends StatefulWidget {
  const ThrowScreen({super.key, required this.viewModel});

  final ThrowScreenViewModel viewModel;

  @override
  State<ThrowScreen> createState() => _ThrowScreenState();
}

class _ThrowScreenState extends State<ThrowScreen> {
  var buttonColor = Colors.red;
  int? releaseTimestamp;
  double? lastThrowHeight;
  var stream =
      userAccelerometerEventStream(samplingPeriod: Duration(milliseconds: 1));
  StreamSubscription<UserAccelerometerEvent>? accelerometerSubscription;
  int counter = 0;
  int stopCounter = 0;
  List<UserAccelerometerEvent> events = [];
  StartEndDetector startEndDetector =
      StartEndDetector(threshold: 0.5, endThreshold: 5.0);

  void processData(UserAccelerometerEvent event) {
    if (events.isEmpty) {
      events.add(event);
      return;
    }
    var lastEvent = events.last;
    var firstEvent = events.first;
    events.add(event);
    var result = processNewEvent(firstEvent, lastEvent, event);
    if (result != null) {
      print("done");
      print(result);
      var endEvent = events[result.$2];
      var startEvent = events[result.$1];
      var startTimestamp = max(
          startEvent.timestamp.millisecondsSinceEpoch,
          releaseTimestamp!);

      var flightTimeSeconds =
          (endEvent.timestamp.millisecondsSinceEpoch - startTimestamp) / 1000;
      var heightMeters = 1/8 * 9.81 * flightTimeSeconds * flightTimeSeconds;
      setState(() {
        lastThrowHeight = heightMeters;
      });
      reset();
    }
  }

  (int, int)? processNewEvent(UserAccelerometerEvent firstEvent,
      UserAccelerometerEvent lastEvent, UserAccelerometerEvent event) {
    var t = event.timestamp.millisecondsSinceEpoch -
        firstEvent.timestamp.millisecondsSinceEpoch;
    var (x, y, z) = (event.x, event.y, event.z);

    var aLast =
        sqrt(pow(lastEvent.x, 2) + pow(lastEvent.y, 2) + pow(lastEvent.z, 2));
    var a = sqrt(pow(x, 2) + pow(y, 2) + pow(z, 2));

    var da = (a - aLast).abs();
    var (start, end) = startEndDetector.processNext(da, t);

    if (start != null && end != null) {
      return (start, end);
    }
    return null;
  }

  void reset() {
    accelerometerSubscription?.cancel();
    accelerometerSubscription = null;
  }

  void processThrowButtonTouch() {
    // stop collecting accelerometer events
    if (accelerometerSubscription != null) {
      print("stopping accelerometer");
      reset();
      return;
    }
    print("Starting accelerometer");
    // start collecting accelerometer events
    events = [];
    startEndDetector = StartEndDetector(threshold: 0.5, endThreshold: 5);
    accelerometerSubscription = stream.listen(
      (UserAccelerometerEvent event) {
        print(
            "${event.timestamp.millisecondsSinceEpoch},${event.x},${event.y},${event.z}");
        processData(event);
      },
      onError: (error) {
        print("Accelerometer error");
      },
      cancelOnError: true,
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    accelerometerSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Throw your phone"),
      ),
      body: Center(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                    label: const Text("Instructions"),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (builderContext) =>
                              const ThrowInstructionsDialog());
                    },
                    icon: const Icon(Icons.info_outline)),
              ],
            ),
            if (lastThrowHeight != null)
              Center(child: Text("Height: ${lastThrowHeight}m"),),
            Expanded(
              flex: 1,
              child: Center(
                  child: Listener(
                onPointerDown: (details) {
                  setState(() {
                    buttonColor = Colors.green;
                  });
                  if (!Platform.isAndroid) {
                    return;
                  }
                  processThrowButtonTouch();
                },
                onPointerUp: (details) {
                  releaseTimestamp = DateTime.now().millisecondsSinceEpoch;
                  setState(() {
                    buttonColor = Colors.red;
                  });
                },
                child: Container(
                  width: 200,
                  height: 200,
                  color: buttonColor,
                  child: Center(child: Text("Hold to throw")),
                ),
              )),
            ),
          ],
        ),
      ),
    );
  }
}
