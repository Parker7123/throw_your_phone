import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:throw_your_phone/data/repositories/throw_ranking_repository.dart';
import 'package:throw_your_phone/data/services/supabase_service.dart';
import 'package:throw_your_phone/models/throw_entry.dart';

class SupabaseThrowRankingRepository extends ThrowRankingRepository {
  final SupabaseService _supabaseService;
  final _supabase = Supabase.instance.client;

  SupabaseThrowRankingRepository({required SupabaseService supabaseService})
      : _supabaseService = supabaseService;

  @override
  Future<List<ThrowEntry>> getThrows(SortOption sortOption,
      {bool ascending = false}) {
    return _supabase.from('throw_entries').select().then(
        (value) => value.map((item) => ThrowEntry.fromMap(item)).toList());
  }

  @override
  Future<ThrowEntry> insertThrow(ThrowEntry throwEntry) async {
    if (_supabaseService.loggedIn() != true) {
      throw Exception("User not logged in");
    }
    var data = await _supabase
        .from('throw_entries')
        .insert(throwEntry.toMap())
        .select();
    return Future.value(ThrowEntry.fromMap(data[0]));
  }
}
