import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:throw_your_phone/data/repositories/throw_repository.dart';
import 'package:throw_your_phone/ui/throw/ThrowScreenViewModel.dart';

void main() {
  group('Throw screen view model test', () {
    test('Should make throw', () async {
      var throwRepository = InMemoryThrowRepository();
      var viewModel = ThrowScreenViewModel(throwRepository: throwRepository);

      await viewModel.makeThrow();

      expect(viewModel.throwEntry != null, true);
      var list = await throwRepository.getThrows();
      expect(list.isNotEmpty, true);
    });
  });
}
