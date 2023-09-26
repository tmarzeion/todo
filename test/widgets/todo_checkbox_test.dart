import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:todo/src/presentation/widgets/todo_checkbox.dart';

void main() {
  testWidgets('Should display a DottedBorder when isDraft is true', (tester) async {
    await tester.pumpWidget(MaterialApp(home: TodoCheckbox(isDraft: true)));

    // Find DottedBorder
    expect(find.byType(DottedBorder), findsOneWidget);
  });

  testWidgets('Should display a Checkbox when isDraft is false', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Material(
          child: TodoCheckbox(isDraft: false),
        ),
      ),
    );

    // Find Checkbox
    expect(find.byType(Checkbox), findsOneWidget);
  });

  testWidgets('Should trigger onChanged callback when Checkbox is toggled', (tester) async {
    bool checkboxValue = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Material(
          child: TodoCheckbox(
            isDraft: false,
            value: checkboxValue,
            onChanged: (value) {
              checkboxValue = value;
            },
          ),
        ),
      ),
    );

    // Tap the Checkbox to change its state
    await tester.tap(find.byType(Checkbox));
    await tester.pump();

    // Expect the checkboxValue to be updated by the callback
    expect(checkboxValue, true);
  });
}
