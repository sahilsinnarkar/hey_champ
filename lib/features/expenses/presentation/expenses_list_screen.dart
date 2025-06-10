import 'package:flutter/material.dart';

class ExpensesListScreen extends StatefulWidget {
  const ExpensesListScreen({super.key});

  @override
  State<ExpensesListScreen> createState() => _ExpenseListsScreenState();
}

class _ExpenseListsScreenState extends State<ExpensesListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("Expenses Screen")),
    );
  }
}