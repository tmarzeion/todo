import '../../domain/models/todo.dart';
import '../../domain/repositories/database_repository.dart';
import '../app_database.dart';

class DatabaseRepositoryImpl implements DatabaseRepository {
  final AppDatabase _appDatabase;

  DatabaseRepositoryImpl(this._appDatabase);

  @override
  Future<List<Todo>> getAllTodos() async {
    return _appDatabase.todoDao.getAllTodos();
  }

  @override
  Future<void> removeTodo(Todo todo) async {
    return _appDatabase.todoDao.deleteTodo(todo);
  }

  @override
  Future<void> saveTodo(Todo todo) async {
    return _appDatabase.todoDao.insertTodo(todo);
  }
}
