import 'package:flutter/cupertino.dart';
import 'package:throw_your_phone/models/throw_entry.dart';

import '../../data/repositories/throw_repository.dart';

class HistoryScreenViewModel extends ChangeNotifier {
  HistoryScreenViewModel({required ThrowRepository throwRepository})
      : _throwRepository = throwRepository {
    load = _load();
  }

  final ThrowRepository _throwRepository;

  List<ThrowEntry> verticalThrows = [];
  List<ThrowEntry> horizontalThrows = [];

  Future? load;

  Future _load() async {
    await Future.delayed(const Duration(milliseconds: 300));
    verticalThrows = await _throwRepository.getThrows();
    horizontalThrows = await _throwRepository.getThrows();
    notifyListeners();
  }
}
