import 'package:throw_your_phone/models/throw_entry.dart';

abstract class ThrowRankingRepository {
  Future<List<ThrowEntry>> getThrows(SortOption sortOption, {bool ascending});
  Future<ThrowEntry> insertThrow(ThrowEntry throwEntry);
}

class InMemoryThrowRankingRepository extends ThrowRankingRepository {
  final List<ThrowEntry> _throwEntries = [
    ThrowEntry(distance: 100, height: 10, dateTime: DateTime.now()),
    ThrowEntry(distance: 999, height: 50, dateTime: DateTime.now()),
    ThrowEntry(distance: 19, height: 990, dateTime: DateTime.now())
  ];

  @override
  Future<List<ThrowEntry>> getThrows(SortOption sortOption,
      {bool ascending = false}) async {
    List<ThrowEntry> result = List.from(_throwEntries);
    result.sort((a, b) {
      if (sortOption == SortOption.distance) {
        int comparison = a.distance.compareTo(b.distance);
        return ascending ? comparison : -1 * comparison;
      } else {
        int comparison = a.height.compareTo(b.height);
        return ascending ? comparison : -1 * comparison;
      }
    });
    return result;
  }

  @override
  Future<ThrowEntry> insertThrow(ThrowEntry throwEntry) {
    _throwEntries.add(throwEntry);
    return Future.value(throwEntry);
  }
}

enum SortOption { distance, height }
