import 'package:hive/hive.dart';

part 'focus_session_model.g.dart';
@HiveType(typeId: 2)
class FocusSession extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String subjectId;

  @HiveField(2)
  DateTime startTime;

  @HiveField(3)
  DateTime endTime;

  FocusSession({
    required this.id,
    required this.subjectId,
    required this.startTime,
    required this.endTime,
  });

  Duration get duration => endTime.difference(startTime);
}