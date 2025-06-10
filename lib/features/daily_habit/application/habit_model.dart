import 'package:hive/hive.dart';

part 'habit_model.g.dart';

@HiveType(typeId: 4)
class Habit extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  List<String> tasks;

  @HiveField(3)
  DateTime startDate;

  @HiveField(4)
  int durationDays;

  @HiveField(5)
  Map<String, Map<String, bool>> dailyStatus;

  Habit({
    required this.id,
    required this.title,
    required this.tasks,
    required this.startDate,
    required this.durationDays,
    required this.dailyStatus,
  });
}
