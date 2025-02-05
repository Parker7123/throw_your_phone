import 'package:throw_your_phone/data/services/throw_service_interface.dart';
import 'package:throw_your_phone/models/throw_entry.dart';

class MockThrowService implements IThrowService {
  double _heightToReturn = 1.5; // Default mock height
  final double _distanceToRetuen = 2.5; // Default mock height
  bool _isCollectingData = false;

  void setMockHeight(double height) {
    _heightToReturn = height;
  }

  @override
  Future<ThrowEntry> beginThrow() async {
    if (_isCollectingData) {
      throw Exception("Already collecting data.");
    }
    _isCollectingData = true;
    return ThrowEntry(
        id: 0,
        distance: _distanceToRetuen,
        height: _heightToReturn,
        dateTime: DateTime.now());
  }

  @override
  Future<void> reset() async {
    _isCollectingData = false;
  }

  @override
  void setReleaseTimestamp() {
    // Mock implementation - no need to do anything
  }
}
