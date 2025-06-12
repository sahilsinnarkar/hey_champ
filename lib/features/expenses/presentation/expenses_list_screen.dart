import 'package:flutter/material.dart';
import 'package:hey_champ_app/common/widgets/screen_name.dart';
import 'package:hey_champ_app/core/constants/color_constants.dart';
import 'package:hey_champ_app/features/expenses/application/expenses_controller.dart';
import 'package:hey_champ_app/features/expenses/presentation/expense_detail_screen.dart';
import 'package:hey_champ_app/routes/app_routes.dart';
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

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Column(
          children: [
            ScreenName(name: "Expenses"),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                  bottom: 8,
                  left: 16.0,
                  right: 16.0,
                ),
                child: ListView.builder(
                  itemCount: controller.expenses.length,
                  itemBuilder: (context, index) {
                    final list = controller.expenses[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ListTile(
                        title: Text(
                          list.title,
                          style: const TextStyle(
                            color: AppColors.primaryText,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          "Total: ₹${list.totalAmount.toStringAsFixed(2)}",
                          style: const TextStyle(
                            color: AppColors.secondaryText,
                            fontSize: 16,
                          ),
                        ),
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
                          icon: const Icon(
                            Icons.delete,
                            color: AppColors.secondaryText,
                          ),
                          onPressed: () => controller.deleteExpenseList(index),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.primaryText,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          onPressed: () {
            router.push('/expense-detail-screen', extra: context);
          },
          child: Icon(Icons.add, color: AppColors.background, size: 30),
        ),
      ),
    );
  }
}
