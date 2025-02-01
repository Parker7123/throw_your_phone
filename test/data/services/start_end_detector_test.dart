import 'package:flutter_test/flutter_test.dart';
import 'package:throw_your_phone/data/services/start_end_detector.dart';

void main() {
  group('StartEndDetector tests', () {
    var points = [
      (3.0, 0),
      (0.0, 10),
      (2.5, 20),
      (2.5, 30),
      (1.0, 50),
      (0.0, 70),
      (3.0, 100),
      (0.5, 180),
      (3.0, 190),
      (2.3, 200),
      (10.1, 210),
      (0.3, 220),
      (0.5, 310),
      (0.0, 320),
      (0.3, 330),
      (0.1, 360),
      (0.3, 370),
      (0.5, 410),
      (0.0, 420),
      (0.3, 430),
      (0.1, 460),
      (0.3, 470),
      (0.5, 510),
      (0.0, 520),
      (0.3, 530),
      (0.1, 560),
      (8.3, 570),
    ];

    test('Should detect start', () {
      StartEndDetector detector = StartEndDetector(threshold: 0.5);
      for (var value in points) {
        detector.processNext(value.$1, value.$2);
      }

      expect(detector.start, 12);
    });

    test('Should detect end', () {
      StartEndDetector detector = StartEndDetector(threshold: 0.5);
      for (var value in points) {
        detector.processNext(value.$1, value.$2);
      }

      expect(detector.end, points.length);
    });

    test('Should detect early end', () {
      StartEndDetector detector = StartEndDetector(threshold: 0.5);
      for (var value in points) {
        detector.processNext(value.$1, value.$2);
      }

      expect(detector.earlyEnd, 11);
    });
  });
}
