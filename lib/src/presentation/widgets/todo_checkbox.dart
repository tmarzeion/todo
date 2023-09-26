import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class TodoCheckbox extends StatelessWidget {
  final bool isDraft;
  final bool value;
  final void Function(bool)? onChanged;

  const TodoCheckbox({
    Key? key,
    this.isDraft = false,
    this.value = false,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isDraft) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: DottedBorder(
          color: Theme.of(context).disabledColor,
          borderType: BorderType.RRect,
          strokeWidth: 1.5,
          child: SizedBox(
            width: 12,
            height: 12,
          ),
        ),
      );
    } else {
      return Checkbox(value: value, onChanged: (value) => onChanged?.call(value ?? false));
    }
  }
}
