import 'package:flutter/material.dart';
import 'package:todo/src/presentation/widgets/todo_checkbox.dart';

import '../../domain/models/todo.dart';

class TodoWidget extends StatefulWidget {
  final Todo? todo;
  final void Function(Todo todo)? onRemove;
  final void Function(Todo todo)? onChanged;
  final void Function(String title)? onCreated;

  const TodoWidget({
    Key? key,
    this.todo,
    this.onCreated,
    this.onChanged,
    this.onRemove,
  }) : super(key: key);

  @override
  _TodoWidgetState createState() => _TodoWidgetState();
}

class _TodoWidgetState extends State<TodoWidget> {
  FocusNode? _focusNode;

  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller..text = widget.todo?.title ?? '';
    _focusNode = FocusNode();
    _focusNode!.addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    setState(() {
      if (!_focusNode!.hasFocus) {
        if (widget.todo == null && _controller.text.isNotEmpty) {
          widget.onCreated?.call(_controller.text);
        } else {
          widget.onChanged?.call(widget.todo!.copyWith(title: _controller.text));
        }
      }
    });
  }

  @override
  void dispose() {
    _focusNode!.removeListener(_handleFocusChange);
    _focusNode!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.todo == null) {
      return _buildDraftTodo();
    } else {
      return _buildTodo();
    }
  }

  Widget _buildDraftTodo() {
    return Row(
      children: [
        TodoCheckbox(
          isDraft: true,
        ),
        Expanded(
          child: TextField(
            focusNode: _focusNode,
            onSubmitted: (_) {
              _focusNode!.unfocus();
            },
            controller: _controller,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'What needs to be done?',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTodo() {
    return Dismissible(
      key: ValueKey(widget.todo!.id),
      direction: DismissDirection.horizontal,
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          widget.onRemove?.call(widget.todo!);
        }
      },
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          widget.onChanged?.call(
            widget.todo!.copyWith(completed: !widget.todo!.completed),
          );
          return false;
        }
        return true;
      },
      background: Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.symmetric(horizontal: 20),
        color: Colors.blue,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              widget.todo!.completed ? Icons.close : Icons.check,
              color: Colors.white,
              size: 16,
            ),
            SizedBox(width: 4),
            Text(
              widget.todo!.completed ? 'Not done' : 'Done',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      secondaryBackground: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.symmetric(horizontal: 20),
        color: Colors.red,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 2.0),
              child: Text(
                'Delete',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(width: 4),
            Icon(
              Icons.delete,
              color: Colors.white,
              size: 16,
            ),
          ],
        ),
      ),
      child: Row(
        children: [
          TodoCheckbox(
            value: widget.todo!.completed,
            onChanged: (value) => widget.onChanged?.call(
              widget.todo!.copyWith(completed: value),
            ),
          ),
          Expanded(
            child: TextField(
              focusNode: _focusNode,
              onSubmitted: (_) {
                _focusNode!.unfocus();
              },
              controller: _controller,
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
