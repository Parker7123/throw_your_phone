class ThrowEntry {
  final int? id; // will be assigned by the database on insert
  final double distance;
  final double height;
  final DateTime dateTime;

  ThrowEntry({this.id, required this.distance, required this.height, required this.dateTime});

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id, // include id only if it is not null
      'distance': distance,
      'height': height,
      'date_time': dateTime.toIso8601String(),
    };
  }

  factory ThrowEntry.fromMap(Map<String, dynamic> map) {
    return ThrowEntry(
      id: map['id'] as int?,
      distance: map['distance'] as double,
      height: map['height'] as double,
      dateTime: DateTime.parse(map['date_time'])
    );
  }

  ThrowEntry copyWith({int? id, double? distance, double? height, DateTime? dateTime}) {
    return ThrowEntry(
      id: id ?? this.id,
      distance: distance ?? this.distance,
      height: height ?? this.height,
      dateTime: dateTime ?? this.dateTime,
    );
  }
}
