import 'package:flutter/cupertino.dart';
import 'package:throw_your_phone/data/repositories/throw_ranking_repository.dart';
import 'package:throw_your_phone/data/services/supabase_service.dart';
import 'package:throw_your_phone/models/throw_entry.dart';

class RankingScreenViewModel extends ChangeNotifier {
  RankingScreenViewModel(
      {required ThrowRankingRepository repository,
      required SupabaseService supabaseService})
      : _repository = repository {
    _load();
  }

  final ThrowRankingRepository _repository;

  bool loading = true;
  SortOption sortOption = SortOption.distance;

  List<ThrowEntry> allTimeRanking = [];
  List<ThrowEntry> monthlyRanking = [];
  List<ThrowEntry> todayRanking = [];

  reloadRankings(SortOption sortOption) async {
    this.sortOption = sortOption;
    await _reloadRankings(sortOption);
    notifyListeners();
  }

  _reloadRankings(SortOption sortOption) async {
    allTimeRanking = await _repository.getThrows(sortOption, ascending: false);

    monthlyRanking = await _repository.getThrows(sortOption, ascending: false);
    todayRanking = await _repository.getThrows(sortOption, ascending: false);
    loading = false;
    notifyListeners();
  }

  Future _load() async {
    await _reloadRankings(sortOption);
    loading = false;
    notifyListeners();
  }
}
