import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:todo/src/domain/models/todo.dart';
import 'package:todo/src/presentation/widgets/todo_checkbox.dart';
import 'package:todo/src/presentation/widgets/todo_widget.dart';

void main() {
  final testTodo = Todo(id: 1, title: 'Test todo', completed: false);

  testWidgets('Displays draft todo when todo is null', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Material(
          child: TodoWidget(),
        ),
      ),
    );

    expect(find.text('What needs to be done?'), findsOneWidget);
  });

  testWidgets('Displays a todo widget when provided with a todo', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Material(
          child: TodoWidget(todo: testTodo),
        ),
      ),
    );

    expect(find.byWidgetPredicate((widget) => widget is TextField && widget.controller!.text == 'Test todo'),
        findsOneWidget);
  });

  testWidgets('onChanged callback for TodoCheckbox', (tester) async {
    bool onChangedCalled = false;
    Todo? changedTodo;

    await tester.pumpWidget(
      MaterialApp(
        home: Material(
          child: TodoWidget(
            todo: testTodo,
            onChanged: (todo) {
              onChangedCalled = true;
              changedTodo = todo;
            },
          ),
        ),
      ),
    );

    await tester.tap(find.byType(TodoCheckbox));
    await tester.pumpAndSettle();

    expect(onChangedCalled, isTrue);
    expect(changedTodo!.completed, isTrue);
  });
}
