abstract class IThrowService {
  Future<double> beginVerticalThrow();
  Future<double> beginHorizontalThrow();
  void setReleaseTimestamp();
  Future<void> reset();
}
