import 'package:flutter/material.dart';
import 'package:hey_champ_app/common/widgets/my_textfield.dart';
import 'package:hey_champ_app/common/widgets/screen_name.dart';
import 'package:hey_champ_app/core/constants/color_constants.dart';
import 'package:provider/provider.dart';
import '../application/todo_controller.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;

    return Consumer<TodoController>(
      builder: (context, controller, child) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: AppColors.background,
            body: Column(
              children: [
                ScreenName(name: "To-Do List"),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    bottom: 8,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: MyTextField(
                          controller: _controller,
                          hintText: "Enter a new task",
                          height: h * 0.06,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.add,
                          size: 30,
                          color: AppColors.primaryText,
                        ),
                        onPressed: () {
                          if (_controller.text.trim().isNotEmpty) {
                            controller.addTodo(_controller.text.trim());
                            _controller.clear();
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.builder(
                    itemCount: controller.todos.length,
                    itemBuilder: (context, index) {
                      final todo = controller.todos[index];
                      return Container(
                        margin: const EdgeInsets.only(
                          top: 8,
                          left: 20,
                          right: 20,
                          bottom: 8,
                        ),
                        decoration: BoxDecoration(
                          color: todo.isDone
                              ? AppColors.secondaryText
                              : AppColors.primaryText,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: ListTile(
                          title: Text(
                            todo.title,
                            style: TextStyle(
                              decoration: todo.isDone
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),
                          leading: Checkbox(
                            activeColor: AppColors.background,
                            value: todo.isDone,
                            onChanged: (_) {
                              controller.toggleTodoStatus(todo.id);
                            },
                          ),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: AppColors.background,
                            ),
                            onPressed: () {
                              controller.deleteTodo(todo.id);
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
