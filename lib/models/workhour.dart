class Workhour {
  int id;
  int dayOfWeek;
  Duration startedAt;
  Duration endedAt;

  Workhour(
      {required this.id,
      required this.dayOfWeek,
      required this.startedAt,
      required this.endedAt});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'dayOfWeek': dayOfWeek,
      'startedAt': startedAt,
      'endedAt': endedAt,
    };
  }

  @override
  String toString() {
    return '{id: $id, dayOfWeek: $dayOfWeek, startedAt: $startedAt, endedAt: $endedAt}';
  }
}
