import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:todo/src/domain/models/todo.dart';
import 'package:todo/src/domain/repositories/database_repository.dart';
import 'package:todo/src/presentation/cubits/todos_cubit.dart';

import 'todo_cubit_test.mocks.dart';

@GenerateMocks([DatabaseRepository])
void main() {
  late MockDatabaseRepository mockDatabaseRepository;
  late TodoCubit cubit;

  setUp(() {
    mockDatabaseRepository = MockDatabaseRepository();
    cubit = TodoCubit(mockDatabaseRepository);
  });

  tearDown(() {
    cubit.close();
  });

  test('should call the removeTodo method from the repository when a todo is removed', () async {
    // Arrange
    final todoToRemove = Todo(id: 1, title: 'test');
    when(mockDatabaseRepository.getAllTodos()).thenAnswer((_) async => []);

    // Act
    cubit.removeTodo(todo: todoToRemove);

    // Assert
    verify(mockDatabaseRepository.removeTodo(todoToRemove)).called(1);
    await expectLater(cubit.stream, emitsInOrder([TodosSuccess(todos: [])]));
  });

  test('should call the removeTodo method from the repository when the updated title is empty', () async {
    // Arrange
    final todoToUpdate = Todo(id: 1, title: '');
    when(mockDatabaseRepository.getAllTodos()).thenAnswer((_) async => []);

    // Act
    cubit.updateTodo(todo: todoToUpdate);

    // Assert
    verify(mockDatabaseRepository.removeTodo(todoToUpdate)).called(1);
    await expectLater(cubit.stream, emitsInOrder([TodosSuccess(todos: [])]));
  });

  test('should not call the removeTodo method from the repository if the updated title is not empty', () async {
    // Arrange
    final todoToUpdate = Todo(id: 1, title: 'test');
    when(mockDatabaseRepository.getAllTodos()).thenAnswer((_) async => [todoToUpdate]);

    // Act
    cubit.updateTodo(todo: todoToUpdate);

    // Assert
    verifyNever(mockDatabaseRepository.removeTodo(todoToUpdate));
    await expectLater(
        cubit.stream,
        emitsInOrder([
          TodosSuccess(todos: [todoToUpdate])
        ]));
  });

  test('should call the saveTodo method from the repository when creating a new todo', () async {
    // Arrange
    final text = 'new todo';
    final createdTodo = Todo(id: DateTime.now().millisecondsSinceEpoch, title: text);
    final mockTodos = [createdTodo];
    when(mockDatabaseRepository.getAllTodos()).thenAnswer((_) async => mockTodos);

    // Act
    cubit.createTodo(text: text);

    // Assert
    verify(mockDatabaseRepository.saveTodo(any)).called(1);
    await expectLater(cubit.stream, emitsInOrder([TodosSuccess(todos: mockTodos)]));
  });
}
