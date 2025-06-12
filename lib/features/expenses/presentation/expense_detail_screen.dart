import 'package:flutter/material.dart';
import 'package:hey_champ_app/common/widgets/my_button.dart';
import 'package:hey_champ_app/common/widgets/my_textfield.dart';
import 'package:hey_champ_app/common/widgets/screen_name.dart';
import 'package:hey_champ_app/core/constants/color_constants.dart';
import 'package:hey_champ_app/features/expenses/application/expenses_controller.dart';
import 'package:hey_champ_app/features/expenses/application/expenses_model.dart';
import 'package:provider/provider.dart';

class ExpenseDetailScreen extends StatefulWidget {
  final ExpenseList? expenseList;
  final int? index;

  const ExpenseDetailScreen({super.key, this.expenseList, this.index});

  @override
  State<ExpenseDetailScreen> createState() => _ExpenseDetailScreenState();
}

class _ExpenseDetailScreenState extends State<ExpenseDetailScreen> {
  late TextEditingController _titleController;
  late TextEditingController _nameController;
  late TextEditingController _amountController;
  List<ExpenseItem> _items = [];

  @override
  void initState() {
    _titleController = TextEditingController(
      text: widget.expenseList?.title ?? "",
    );
    _nameController = TextEditingController();
    _amountController = TextEditingController();
    _items = widget.expenseList?.items ?? [];
    super.initState();
  }

  void _addItem() {
    if (_nameController.text.isEmpty || _amountController.text.isEmpty) return;
    final item = ExpenseItem(
      name: _nameController.text,
      amount: double.tryParse(_amountController.text) ?? 0,
    );
    setState(() {
      _items.add(item);
      _nameController.clear();
      _amountController.clear();
    });
  }

  void _saveList() {
    final controller = Provider.of<ExpenseController>(context, listen: false);
    final newList = ExpenseList(title: _titleController.text, items: _items);
    if (widget.index != null) {
      controller.updateExpenseList(widget.index!, newList);
    } else {
      controller.addExpenseList(newList);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final total = _items.fold(0.0, (sum, item) => sum + item.amount);
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Column(
          children: [
            ScreenName(name: "Expense Details"),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total: ₹${total.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryText,
                          ),
                        ),
                        const SizedBox(width: 15),
                        MyButton(
                          text: "Save",
                          onPressed: _saveList,
                          width: w * 0.3,
                          height: h * 0.05,
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    MyTextField(
                      controller: _titleController,
                      hintText: "Expense List Title",
                      height: h * 0.06,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: MyTextField(
                            controller: _nameController,
                            hintText: 'Item Name',
                            height: h * 0.06,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: MyTextField(
                            controller: _amountController,
                            keyboardType: TextInputType.number,
                            hintText: "Amount",
                          ),
                        ),
                        IconButton(
                          color: AppColors.primaryText,
                          icon: const Icon(
                            Icons.add,
                            // color: AppColors.background,
                          ),
                          onPressed: _addItem,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _items.length,
                        itemBuilder: (context, index) {
                          final item = _items[index];
                          return ListTile(
                            title: Text(
                              item.name,
                              style: const TextStyle(
                                color: AppColors.primaryText,
                                fontSize: 18,
                              ),
                            ),
                            trailing: Text(
                              '₹${item.amount.toStringAsFixed(2)}',
                              style: const TextStyle(
                                color: AppColors.primaryText,
                                fontSize: 16,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
