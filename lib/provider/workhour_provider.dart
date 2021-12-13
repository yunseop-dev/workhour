import 'package:flutter/material.dart';
import 'package:flutter_workhour/models/workhour.dart';
import 'package:provider/provider.dart';
import 'package:time/time.dart';

class WorkhourProvider extends ChangeNotifier {
  final Workhour _workhour =
      Workhour(id: -1, dayOfWeek: 0, startedAt: 0.hours, endedAt: 0.hours);
  Workhour get workhour => _workhour;

  set id(int id) {
    _workhour.id = id;
    notifyListeners();
  }

  set dayOfWeek(int dayOfWeek) {
    _workhour.dayOfWeek = dayOfWeek;
    notifyListeners();
  }

  set startedAt(Duration startedAt) {
    _workhour.startedAt = startedAt;
    notifyListeners();
  }

  set endedAt(Duration endedAt) {
    _workhour.endedAt = endedAt;
    notifyListeners();
  }
}
