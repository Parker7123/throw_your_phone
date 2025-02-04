import 'package:flutter/cupertino.dart';
import 'package:throw_your_phone/models/throw_entry.dart';

import '../../data/repositories/throw_repository.dart';
import 'history_screen.dart';

class HistoryScreenViewModel extends ChangeNotifier {
  HistoryScreenViewModel({required ThrowRepository throwRepository})
      : _throwRepository = throwRepository {
    load = _load();
  }

  SortCriteria currentSort = SortCriteria.date;
  bool ascending = true;
  final ThrowRepository _throwRepository;

  List<ThrowEntry> throwEntries = [];

  Future? load;

  Future _load() async {
    await Future.delayed(const Duration(milliseconds: 300));
    throwEntries = await _throwRepository.getThrows();
    sortBy(currentSort);
    notifyListeners();
  }

  void sortBy(SortCriteria criteria) {
    if (currentSort == criteria) {
      ascending = !ascending;
    } else {
      currentSort = criteria;
      ascending = true;
    }

    switch (criteria) {
      case SortCriteria.distance:
        throwEntries.sort((a, b) => ascending
            ? a.distance.compareTo(b.distance)
            : b.distance.compareTo(a.distance));
        break;
      case SortCriteria.height:
        throwEntries.sort((a, b) => ascending
            ? a.height.compareTo(b.height)
            : b.height.compareTo(a.height));
        break;
      case SortCriteria.date:
        throwEntries.sort((a, b) => ascending
            ? a.dateTime.millisecondsSinceEpoch.compareTo(b.dateTime.millisecondsSinceEpoch)
            : b.dateTime.millisecondsSinceEpoch.compareTo(a.dateTime.millisecondsSinceEpoch));
        break;
    }
    notifyListeners();
  }

  void delete(ThrowEntry throwEntry) async {
    await _throwRepository.remove(throwEntry);
    throwEntries.remove(throwEntry);
    notifyListeners();
  }
}
