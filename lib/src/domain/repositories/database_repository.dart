import '../models/todo.dart';

abstract class DatabaseRepository {
  Future<List<Todo>> getAllTodos();

  Future<void> saveTodo(Todo todo);

  Future<void> removeTodo(Todo todo);
}
