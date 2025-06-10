import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'subject_model.g.dart';

@HiveType(typeId: 1)
class Subject extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  int colorValue;

  @HiveField(3)
  int? iconCodePoint;

  // Hive uses this one automatically
  Subject({
    required this.id,
    required this.name,
    required this.colorValue,
    this.iconCodePoint,
  });

  // For convenience when creating from Flutter types
  factory Subject.withUI({
    required String id,
    required String name,
    required Color color,
    IconData? icon,
  }) {
    return Subject(
      id: id,
      name: name,
      colorValue: color.value,
      iconCodePoint: icon?.codePoint,
    );
  }

  Color get color => Color(colorValue);

  IconData? get icon => iconCodePoint != null
      ? IconData(iconCodePoint!, fontFamily: 'MaterialIcons')
      : null;
}
