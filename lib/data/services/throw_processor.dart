import 'dart:math';

import 'package:throw_your_phone/data/services/acceleration.dart';

abstract class ThrowProcessor {
  double calculateDistance(
      List<Acceleration> data, int start, int end, int? releaseTimestamp);
}

class VerticalThrowProcessor implements ThrowProcessor {
  @override
  double calculateDistance(
      List<Acceleration> data, int start, int end, int? releaseTimestamp) {
    var startEvent = data[start];
    var endEvent = data[end];
    var startTimestamp = releaseTimestamp != null
        ? max(startEvent.timestamp, releaseTimestamp)
        : startEvent.timestamp;
    var flightTimeSeconds = (endEvent.timestamp - startTimestamp) / 1000;
    return 1 / 8 * 9.81 * flightTimeSeconds * flightTimeSeconds;
  }
}

class HorizontalThrowProcessor implements ThrowProcessor {
  int findAccelStartIndex(List<Acceleration> data, int startTimestamp,
      {int delta = 1000}) {
    return data.indexed
        .skipWhile((indexed) => indexed.$2.timestamp < startTimestamp - delta)
        .first
        .$1;
  }

  List<double> integrate(List<double> x, List<double> t) {
    if (x.isEmpty) {
      return [];
    }
    List<double> result = [];
    result.add(x[0] * t[0]);
    for (int i = 1; i < x.length; i++) {
      result.add(result[i - 1] + x[i] * t[i]);
    }
    return result;
  }

  @override
  double calculateDistance(
      List<Acceleration> data, int start, int end, int? releaseTimestamp) {
    if (end > 0) {
      end = end - 1;
    }
    var startEvent = data[start];
    var startTimestamp = releaseTimestamp != null
        ? max(startEvent.timestamp, releaseTimestamp)
        : startEvent.timestamp;
    final int accelStartIndex = findAccelStartIndex(data, startTimestamp);

    List<double> dt = [];
    var tPrev = data[accelStartIndex].timestamp;
    for (int i = accelStartIndex; i <= end; i++) {
      var di = data[i];
      dt.add((di.timestamp - tPrev) / 1000);
      tPrev = di.timestamp;
    }
    List<Acceleration> validAcceleration =
        data.sublist(accelStartIndex, end + 1);
    var vx = integrate(validAcceleration.map((e) => e.x).toList(), dt);
    var vy = integrate(validAcceleration.map((e) => e.y).toList(), dt);
    var vz = integrate(validAcceleration.map((e) => e.z).toList(), dt);

    var sx = integrate(vx, dt);
    var sy = integrate(vy, dt);
    var sz = integrate(vz, dt);

    double distance = sqrt(pow(sx.last, 2) + pow(sy.last, 2) + pow(sz.last, 2));
    return distance;
  }
}
