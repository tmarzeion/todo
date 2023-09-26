import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/models/todo.dart';
import '../cubits/todos_cubit.dart';
import '../widgets/todo_widget.dart';

class TodosListView extends StatelessWidget {
  const TodosListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ToDo',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: BlocBuilder<TodoCubit, TodoState>(
        builder: (_, state) {
          switch (state.runtimeType) {
            case TodosLoading:
              return const Center(child: CupertinoActivityIndicator());
            case TodosSuccess:
              return GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: Container(
                  constraints: BoxConstraints.expand(),
                  child: _TodosListContent(
                    todos: state.todos,
                  ),
                ),
              );
            default:
              return const SizedBox();
          }
        },
      ),
    );
  }
}

class _TodosListContent extends StatelessWidget {
  _TodosListContent({
    Key? key,
    required this.todos,
  }) : super(key: key);

  final List<Todo> todos;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: todos.length + 1,
      itemBuilder: (context, index) {
        if (index == todos.length) {
          return TodoWidget(
            key: const Key('new_todo'),
            onCreated: (title) {
              context.read<TodoCubit>().createTodo(text: title);
            },
          );
        } else {
          return TodoWidget(
            key: Key(todos[index].id.toString()),
            todo: todos[index],
            onRemove: (todo) => BlocProvider.of<TodoCubit>(context).removeTodo(todo: todo),
            onChanged: (todo) => BlocProvider.of<TodoCubit>(context).updateTodo(todo: todo),
          );
        }
      },
      separatorBuilder: (context, index) => Divider(
        height: 2,
      ),
    );
  }
}
