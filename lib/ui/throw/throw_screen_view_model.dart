import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:throw_your_phone/data/repositories/throw_repository.dart';
import 'package:throw_your_phone/models/throw_entry.dart';

class ThrowScreenViewModel extends ChangeNotifier {
  ThrowScreenViewModel({required ThrowRepository throwRepository})
      : _throwRepository = throwRepository;

  final ThrowRepository _throwRepository;
  ThrowEntry? throwEntry;
  Random random = Random();

  makeThrow() async {
    ThrowEntry throwEntry =
        ThrowEntry(random.nextDouble() * 128, random.nextDouble() * 64);
    var createdThrowEntry = await _throwRepository.addThrow(throwEntry);
    this.throwEntry = createdThrowEntry;
    notifyListeners();
  }
}
