import 'package:flutter_test/flutter_test.dart';
import 'package:throw_your_phone/data/repositories/throw_repository.dart';
import 'package:throw_your_phone/ui/throw/throw_screen_view_model.dart';

import '../../mocks/mock_throw_service.dart';

void main() {
  group('Throw screen view model test', () {
    late ThrowRepository throwRepository;
    late MockThrowService throwService;
    late ThrowScreenViewModel viewModel;

    setUp(() {
      throwRepository = InMemoryThrowRepository();
      throwService = MockThrowService();
      viewModel = ThrowScreenViewModel(
          throwRepository: throwRepository, throwService: throwService);
    });

    test('Should make throw', () async {
      await viewModel.makeThrow();

      expect(viewModel.throwEntry != null, true);
      var list = await throwRepository.getThrows();
      expect(list.isNotEmpty, true);
    });

    test('Should begin vertical throw', () async {
      throwService.setMockHeight(10);

      await viewModel.beginVerticalThrow();
      await Future.delayed(const Duration(seconds: 1));

      expect(viewModel.throwEntry != null, true);
      expect(viewModel.throwEntry?.height, 10);
      var list = await throwRepository.getThrows();
      expect(list.isNotEmpty, true);
    });
  });
}
