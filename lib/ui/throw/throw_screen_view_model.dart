import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:throw_your_phone/data/repositories/throw_repository.dart';
import 'package:throw_your_phone/data/services/throw_service_interface.dart';
import 'package:throw_your_phone/models/throw_entry.dart';

class ThrowScreenViewModel extends ChangeNotifier {
  ThrowScreenViewModel(
      {required ThrowRepository throwRepository,
      required IThrowService throwService})
      : _throwRepository = throwRepository,
        _throwService = throwService;

  final IThrowService _throwService;
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
    _throwService.beginVerticalThrow().then(
      (value) async {
        throwEntry = await _throwRepository.addThrow(ThrowEntry(0, value));
        throwInProgress = false;
        notifyListeners();
      },
    );
  }

  beginHorizontalThrow() {
    throwInProgress = true;
    notifyListeners();
    _throwService.beginHorizontalThrow().then(
          (value) async {
        throwEntry = await _throwRepository.addThrow(ThrowEntry(0, value));
        throwInProgress = false;
        notifyListeners();
      },
    );
  }

  Future reset() async {
    await _throwService.reset();
    throwInProgress = false;
    throwEntry = null;
    notifyListeners();
  }

  void setReleaseTimestamp() {
    _throwService.setReleaseTimestamp();
  }
}
