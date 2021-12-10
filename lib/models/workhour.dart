class Workhour {
  final int id;
  final int dayOfWeek;
  final Duration startedAt;
  final Duration endedAt;

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
}
