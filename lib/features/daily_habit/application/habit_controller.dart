import 'package:flutter/material.dart';
import 'package:hey_champ_app/features/daily_habit/application/habit_model.dart';
import 'package:hive/hive.dart';

class HabitController with ChangeNotifier {
  late Box<Habit> _habitBox;
  bool _initialized = false;

  HabitController() {
    _init();
  }

  Future<void> _init() async {
    await Future.delayed(Duration.zero); // Wait until Hive is ready
    _habitBox = Hive.box<Habit>('daily-habits');
    _initialized = true;
    notifyListeners();
  }

  List<Habit> get habits => _initialized ? _habitBox.values.toList() : [];

  void addHabit(Habit habit) {
    if (!_initialized) return;
    _habitBox.put(habit.id, habit);
    notifyListeners();
  }

  void updateHabit(Habit habit) {
    if (!_initialized) return;
    habit.save();
    notifyListeners();
  }

  void deleteHabit(String id) {
    if (!_initialized) return;
    _habitBox.delete(id);
    notifyListeners();
  }

  void toggleTaskStatus(String habitId, String date, String task) {
    if (!_initialized) return;
    final habit = _habitBox.get(habitId);
    if (habit != null) {
      habit.dailyStatus[date]?[task] = !(habit.dailyStatus[date]?[task] ?? false);
      habit.save();
      notifyListeners();
    }
  }
}