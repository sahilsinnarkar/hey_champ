import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'expenses_model.dart';

class ExpenseController with ChangeNotifier {
  final Box<ExpenseList> expenseBox = Hive.box<ExpenseList>('expenses');

  List<ExpenseList> get expenses => expenseBox.values.toList();

  void addExpenseList(ExpenseList list) {
    expenseBox.add(list);
    notifyListeners();
  }

  void updateExpenseList(int index, ExpenseList list) {
    expenseBox.putAt(index, list);
    notifyListeners();
  }

  void deleteExpenseList(int index) {
    expenseBox.deleteAt(index);
    notifyListeners();
  }
}
