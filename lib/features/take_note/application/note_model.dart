import 'package:hive/hive.dart';
part 'note_model.g.dart';

@HiveType(typeId: 5)
class Note extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  String content;

  @HiveField(2)
  String fontFamily;

  @HiveField(3)
  double fontSize;

  @HiveField(4)
  bool isBold;

  @HiveField(5)
  bool isItalic;

  @HiveField(6)
  String textAlign;

  @HiveField(7)
  int colorValue;

  Note({
    required this.title,
    required this.content,
    this.fontFamily = 'Roboto',
    this.fontSize = 16,
    this.isBold = false,
    this.isItalic = false,
    this.textAlign = 'left',
    this.colorValue = 0xFF000000,
  });
}
