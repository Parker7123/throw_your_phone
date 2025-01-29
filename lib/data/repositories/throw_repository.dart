import 'dart:collection';

import 'package:throw_your_phone/models/throw_entry.dart';

abstract class ThrowRepository {
  Future<ThrowEntry> get(id);

  Future<List<ThrowEntry>> getThrows();

  Future<ThrowEntry> addThrow(ThrowEntry throwEntry);

  Future remove(ThrowEntry throwEntry);
}

class InMemoryThrowRepository extends ThrowRepository {
  final _throws =
      List.generate(3, (i) => ThrowEntry(i.toDouble(), i.toDouble()));

  @override
  Future<ThrowEntry> addThrow(ThrowEntry throwEntry) {
    _throws.add(throwEntry);
    return Future.value(throwEntry);
  }

  @override
  Future<ThrowEntry> get(id) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future<List<ThrowEntry>> getThrows() {
    return Future.value(_throws);
  }

  @override
  Future remove(ThrowEntry throwEntry) {
    _throws.remove(throwEntry);
    return Future.value();
  }
}
