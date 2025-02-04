import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:throw_your_phone/data/repositories/throw_repository.dart';
import 'package:throw_your_phone/ui/throw/throw_instructions_dialog.dart';
import 'package:throw_your_phone/ui/throw/throw_screen.dart';
import 'package:throw_your_phone/ui/throw/throw_screen_view_model.dart';

import '../../mocks/mock_throw_service.dart';

void main() {
  group('Throw screen tests', () {
    late ThrowRepository throwRepository;
    late MockThrowService throwService;
    late ThrowScreenViewModel viewModel;

    setUp(() {
      throwRepository = InMemoryThrowRepository();
      throwService = MockThrowService();
      viewModel = ThrowScreenViewModel(
          throwRepository: throwRepository, throwService: throwService);
    });

    testWidgets(
      'Should show Instructions dialog',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: ThrowScreen(viewModel: viewModel),
          ),
        );

        final instructionsButton = find.ancestor(
            of: find.byIcon(Icons.info_outline),
            matching: find.byWidgetPredicate(
              (widget) => widget is TextButton,
            ));

        expect(instructionsButton, findsOneWidget);

        await tester.tap(instructionsButton);
        await tester.pumpAndSettle(); // Ensures dialog is fully shown

        expect(find.byType(ThrowInstructionsDialog), findsOneWidget);
      },
    );
  });
}
