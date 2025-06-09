import 'package:hive/hive.dart';

part 'reminder_model.g.dart'; // Hive generates this file

@HiveType(typeId: 0)
class Reminder extends HiveObject {

  @HiveField(0)
  String title;

  @HiveField(1)
  DateTime dateTime;

  @HiveField(2)
  String repeat;

  Reminder({required this.title, required this.dateTime, required this.repeat});
}
