import 'package:hive/hive.dart';

part 'expenses_model.g.dart';

@HiveType(typeId: 6)
class ExpenseItem {
  @HiveField(0)
  String name;

  @HiveField(1)
  double amount;

  ExpenseItem({required this.name, required this.amount});
}

@HiveType(typeId: 7)
class ExpenseList extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  List<ExpenseItem> items;

  ExpenseList({required this.title, this.items = const []});

  double get totalAmount => items.fold(0, (sum, item) => sum + item.amount);
}
