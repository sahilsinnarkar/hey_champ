import 'package:flutter/material.dart';
import 'package:hey_champ_app/features/expenses/application/expenses_controller.dart';
import 'package:hey_champ_app/features/expenses/presentation/expense_detail_screen.dart';
import 'package:provider/provider.dart';

class ExpensesListScreen extends StatefulWidget {
  const ExpensesListScreen({super.key});

  @override
  State<ExpensesListScreen> createState() => _ExpensesListScreenState();
}

class _ExpensesListScreenState extends State<ExpensesListScreen> {
  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<ExpenseController>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expenses List'),
      ),
      body: ListView.builder(
        itemCount: controller.expenses.length,
        itemBuilder: (context, index) {
          final list = controller.expenses[index];
          return ListTile(
            title: Text(list.title),
            subtitle: Text("Total: ₹${list.totalAmount.toStringAsFixed(2)}"),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ExpenseDetailScreen(
                  expenseList: list,
                  index: index,
                ),
              ),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => controller.deleteExpenseList(index),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ExpenseDetailScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}