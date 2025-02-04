import 'package:throw_your_phone/data/services/throw_service_interface.dart';

class MockThrowService implements IThrowService {
  double _heightToReturn = 1.5; // Default mock height
  bool _isCollectingData = false;

  void setMockHeight(double height) {
    _heightToReturn = height;
  }

  @override
  Future<double> beginVerticalThrow() async {
    if (_isCollectingData) {
      throw Exception("Already collecting data.");
    }
    _isCollectingData = true;
    return _heightToReturn;
  }

  @override
  Future<double> beginHorizontalThrow() async {
    if (_isCollectingData) {
      throw Exception("Already collecting data.");
    }
    _isCollectingData = true;
    return _heightToReturn;
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
