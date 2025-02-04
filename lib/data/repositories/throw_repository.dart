import 'package:throw_your_phone/models/throw_entry.dart';

abstract class ThrowRepository {
  Future<ThrowEntry> get(id);

  Future<List<ThrowEntry>> getThrows();

  Future<List<ThrowEntry>> getVerticalThrows();

  Future<List<ThrowEntry>> getHorizontalThrows();

  Future<ThrowEntry> addThrow(ThrowEntry throwEntry);

  Future remove(ThrowEntry throwEntry);
}

class InMemoryThrowRepository extends ThrowRepository {
  final _throws =
      List.generate(3, (i) => ThrowEntry(i.toDouble(), i.toDouble(), ThrowType.vertical));

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

  @override
  Future<List<ThrowEntry>> getHorizontalThrows() {
    return Future.value(_throws.where((t) => t.throwType == ThrowType.horizontal).toList());
  }

  @override
  Future<List<ThrowEntry>> getVerticalThrows() {
    return Future.value(_throws.where((t) => t.throwType == ThrowType.vertical).toList());
  }
}
