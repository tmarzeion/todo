import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:todo/main.dart';
import 'package:todo/src/locator.dart';  // Import your main app here

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Todo integration test', (WidgetTester tester) async {
    await initializeDependencies();

    await tester.pumpWidget(MyApp());
    await tester.pumpAndSettle();

    // Verify if the app starts with a draft todo widget.
    expect(find.byKey(Key('new_todo')), findsOneWidget);

    // Simulate entering text in the draft todo widget.
    await tester.enterText(find.byKey(Key('new_todo')), 'Test Todo Item');
    await tester.pumpAndSettle();

    // Tap the center to lose focus and create the todo.
    await tester.tapAt(Offset(0, 0));
    await tester.pumpAndSettle();

    // Verify if the todo item is added to the list.
    expect(find.text('Test Todo Item'), findsOneWidget);

  });
}
