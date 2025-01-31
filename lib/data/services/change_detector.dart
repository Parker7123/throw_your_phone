class StartEndDetector {
  final double threshold;
  final double endThreshold;

  int _fluctuationsCounter = 0;
  int _noFluctuationsCounter = 0;
  int? _firstFluctuationTimestamp;
  int? _noFluctuationsStartTimestamp;
  int? _noFluctuationsStartI;
  int _i = 0;
  int? start;
  int? end;

  StartEndDetector({required this.threshold, this.endThreshold = 5.0});

  (int?, int?) processNext(double x, int t) {
    if (end != null) return (start, end);

    if (x > threshold) {
      _handleFluctuation(t);
      if (_checkEndCondition(x)) {
        return (start, end);
      }
    } else {
      _handleNoFluctuation(t);
    }

    _i++;
    return (null, null);
  }

  void _handleFluctuation(int t) {
    _firstFluctuationTimestamp ??= t;
    _fluctuationsCounter++;
    _noFluctuationsStartTimestamp = null;
    _noFluctuationsCounter = 0;
  }

  bool _checkEndCondition(double x) {
    if (start != null && x > endThreshold) {
      end = _i;
      print("end: $_i");
      return true;
    }
    return false;
  }

  void _handleNoFluctuation(int t) {
    if (start != null || _firstFluctuationTimestamp == null) return;

    _noFluctuationsCounter++;
    if (_noFluctuationsStartTimestamp == null) {
      _noFluctuationsStartTimestamp = t;
      _noFluctuationsStartI = _i;
    }

    if (_shouldSetStart(t)) {
      start = _noFluctuationsStartI;
      print("start: $start");
    }
  }

  bool _shouldSetStart(int t) {
    return _noFluctuationsCounter > 10 &&
        (t - _noFluctuationsStartTimestamp!) > 200 &&
        (_noFluctuationsStartTimestamp! - _firstFluctuationTimestamp!) > 200;
  }
}