import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/models/todo.dart';
import '../../domain/repositories/database_repository.dart';

part 'todos_state.dart';

class TodoCubit extends Cubit<TodoState> {
  final DatabaseRepository _databaseRepository;

  TodoCubit(this._databaseRepository) : super(const TodosLoading());

  Future<void> getAllSavedTodos() async {
    emit(await _getAllSavedTodos());
  }

  Future<void> removeTodo({required Todo todo}) async {
    await _databaseRepository.removeTodo(todo);
    emit(await _getAllSavedTodos());
  }

  Future<void> updateTodo({required Todo todo}) async {
    if (todo.title.isEmpty) {
      _databaseRepository.removeTodo(todo);
    } else {
      await _databaseRepository.saveTodo(todo);
    }
    emit(await _getAllSavedTodos());
  }

  Future<void> createTodo({required String text}) async {
    await _databaseRepository.saveTodo(
      Todo(
        id: DateTime.now().millisecondsSinceEpoch,
        title: text,
      ),
    );
    emit(await _getAllSavedTodos());
  }

  Future<TodoState> _getAllSavedTodos() async {
    final todos = await _databaseRepository.getAllTodos();
    return TodosSuccess(todos: todos);
  }
}
