abstract class IThrowService {
  Future<double> beginVerticalThrow();
  void beginHorizontalThrow();
  void setReleaseTimestamp();
  Future<void> reset();
}
