import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:throw_your_phone/data/repositories/throw_repository.dart';
import 'package:throw_your_phone/data/services/throw_service_interface.dart';
import 'package:throw_your_phone/models/throw_entry.dart';

enum ThrowState {
  init, inProgress, done, saved
}

class ThrowScreenViewModel extends ChangeNotifier {
  ThrowScreenViewModel(
      {required ThrowRepository throwRepository,
      required IThrowService throwService})
      : _throwRepository = throwRepository,
        _throwService = throwService;

  final IThrowService _throwService;
  final ThrowRepository _throwRepository;
  ThrowEntry? throwEntry;
  ThrowState throwState = ThrowState.init;
  Random random = Random();

  beginThrow() {
    throwState = ThrowState.inProgress;
    notifyListeners();
    _throwService.beginThrow().then(
      (value) async {
        throwEntry = value;
        throwState = ThrowState.done;
        notifyListeners();
      },
    );
  }

  Future reset() async {
    await _throwService.reset();
    throwState = ThrowState.init;
    throwEntry = null;
    notifyListeners();
  }

  Future<void> saveThrow() async {
    if (throwEntry != null) {
      await _throwRepository.addThrow(throwEntry!);
      throwState = ThrowState.saved;
      notifyListeners();
    }
  }

  void setReleaseTimestamp() {
    _throwService.setReleaseTimestamp();
  }
}
