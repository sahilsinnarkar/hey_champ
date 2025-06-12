import 'package:flutter/material.dart';
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Detail'),
        actions: [
          IconButton(icon: const Icon(Icons.check), onPressed: _saveList),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total: ₹${total.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Expense List Title',
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Item Name'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Amount'),
                  ),
                ),
                IconButton(icon: const Icon(Icons.add), onPressed: _addItem),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  final item = _items[index];
                  return ListTile(
                    title: Text(item.name),
                    trailing: Text('₹${item.amount.toStringAsFixed(2)}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
