import 'package:floor/floor.dart';

import '../../domain/models/todo.dart';
import '../../utils/constants.dart';

@dao
abstract class TodoDao {
  @Query('SELECT * FROM $todoTableName')
  Future<List<Todo>> getAllTodos();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertTodo(Todo todo);

  @delete
  Future<void> deleteTodo(Todo todo);
}
