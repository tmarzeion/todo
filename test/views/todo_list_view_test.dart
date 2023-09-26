import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo/src/presentation/cubits/todos_cubit.dart';
import 'package:todo/src/presentation/views/todos_list_view.dart';
import 'package:todo/src/presentation/widgets/todo_widget.dart';
import 'package:todo/src/domain/models/todo.dart';

class MockTodoCubit extends MockCubit<TodoState> implements TodoCubit {}

void main() {
  final mockTodo = Todo(id: 1, title: 'Test Todo');

  testWidgets('Renders TodosListView with mock data', (WidgetTester tester) async {
    final mockCubit = MockTodoCubit();

    whenListen<TodoState>(
      mockCubit,
      Stream.fromIterable([
        TodosLoading(),
        TodosSuccess(todos: [mockTodo])
      ]),
      initialState: TodosLoading(),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<TodoCubit>(
          create: (context) => mockCubit,
          child: TodosListView(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(TodoWidget), findsNWidgets(2)); // +1 for the draft todo
  });
}
