import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:throw_your_phone/data/repositories/throw_repository.dart';
import 'package:throw_your_phone/data/services/throw_service.dart';
import 'package:throw_your_phone/models/throw_entry.dart';

class ThrowScreenViewModel extends ChangeNotifier {
  ThrowScreenViewModel({required ThrowRepository throwRepository})
      : _throwRepository = throwRepository;

  final ThrowService throwService = ThrowService();
  final ThrowRepository _throwRepository;
  ThrowEntry? throwEntry;
  bool throwInProgress = false;
  Random random = Random();

  makeThrow() async {
    ThrowEntry throwEntry =
        ThrowEntry(random.nextDouble() * 128, random.nextDouble() * 64);
    var createdThrowEntry = await _throwRepository.addThrow(throwEntry);
    this.throwEntry = createdThrowEntry;
    notifyListeners();
  }

  beginVerticalThrow() {
    throwInProgress = true;
    notifyListeners();
    throwService.beginVerticalThrow().then(
      (value) async {
        throwEntry = await _throwRepository.addThrow(ThrowEntry(0, value));
        throwInProgress = false;
        notifyListeners();
      },
    );
  }

  Future reset() async {
    await throwService.reset();
    throwInProgress = false;
    throwEntry = null;
    notifyListeners();
  }

  void setReleaseTimestamp() {
    throwService.setReleaseTimestamp();
  }
}
