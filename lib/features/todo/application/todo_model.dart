import 'package:hive/hive.dart';

part 'todo_model.g.dart';

@HiveType(typeId: 3)
class Todo extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  bool isDone;

  Todo({
    required this.id,
    required this.title,
    this.isDone = false,
  });
}
