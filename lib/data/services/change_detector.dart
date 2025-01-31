class StartEndDetector {
  final double threshold;
  final double endThreshold;

  int _noFluctuationsCounter = 0;
  int? _firstFluctuationTimestamp;
  int? _noFluctuationsStartTimestamp;
  int? _noFluctuationsStartI;
  int _i = 1;
  int? start;
  int? end;
  int? earlyEnd;

  StartEndDetector({required this.threshold, this.endThreshold = 5.0});

  processNext(double x, int t) {
    if (end != null) return (start, end);

    if (x > threshold) {
      _handleFluctuation(x, t);
    } else {
      _handleNoFluctuation(t);
    }
    _i++;
  }

  void _handleFluctuation(double x, int t) {
    _firstFluctuationTimestamp ??= t;
    _noFluctuationsStartTimestamp = null;
    _noFluctuationsCounter = 0;
    if (start != null && x > endThreshold) {
      end = _i;
      print("end: $_i");
    }
    if (start == null && x > endThreshold) {
      earlyEnd = _i;
      print("early end: $_i");
    }
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
