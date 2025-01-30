import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:throw_your_phone/data/repositories/throw_repository.dart';
import 'package:throw_your_phone/ui/history/history_screen.dart';
import 'package:throw_your_phone/ui/history/history_screen_view_model.dart';

void main() {
  group('History screen tests', () {
    late ThrowRepository throwRepository;

    setUp(() {
      throwRepository = InMemoryThrowRepository();
    });

    testWidgets('Should display list', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: HistoryScreen(
            viewModel:
                HistoryScreenViewModel(throwRepository: throwRepository)),
      ));
      await tester.pumpAndSettle();

      debugDumpApp();
      final tileFinder = find.textContaining(RegExp('Throw #.*'));

      expect(tileFinder, findsWidgets);
    });
  });
}
