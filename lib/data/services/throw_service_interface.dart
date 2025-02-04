import 'package:throw_your_phone/models/throw_entry.dart';

abstract class IThrowService {
  Future<ThrowEntry> beginThrow();
  void setReleaseTimestamp();
  Future<void> reset();
}
