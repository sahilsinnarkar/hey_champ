import 'package:flutter/material.dart';
import 'package:hey_champ_app/features/todo/application/todo_model.dart';
import 'package:hive/hive.dart';

class TodoController with ChangeNotifier {
  late Box<Todo> _todoBox;

  TodoController() {
    _todoBox = Hive.box<Todo>('todos');
  }

  List<Todo> get todos => _todoBox.values.toList();

  void addTodo(String title) {
    final newTodo = Todo(id: UniqueKey().toString(), title: title);
    _todoBox.put(newTodo.id, newTodo);
    notifyListeners();
  }

  void toggleTodoStatus(String id) {
    final todo = _todoBox.get(id);
    if (todo != null) {
      todo.isDone = !todo.isDone;
      todo.save();
      notifyListeners();
    }
  }

  void deleteTodo(String id) {
    _todoBox.delete(id);
    notifyListeners();
  }
}
