
class ThrowService {

  int? releaseTimestamp;

  void beginHorizontalThrow() {

  }

  void beginVerticalThrow() {

  }

  void setReleaseTimestamp(DateTime timestamp) {
    releaseTimestamp = timestamp.millisecondsSinceEpoch;
  }

}