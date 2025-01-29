
import 'package:flutter_test/flutter_test.dart';
import 'package:throw_your_phone/data/repositories/throw_repository.dart';
import 'package:throw_your_phone/ui/history/history_screen_view_model.dart';

void main() {
  group('History screen test', () {
    test('load throws', () async {
      final viewModel = HistoryScreenViewModel(throwRepository: InMemoryThrowRepository());
      
      await Future.delayed(const Duration(milliseconds: 1000));
      expect(viewModel.throwEntries.isNotEmpty, true);
    });
  });
}