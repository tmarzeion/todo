part of 'todos_cubit.dart';


abstract class TodoState extends Equatable {
  final List<Todo> todos;

  const TodoState({
    this.todos = const [],
  });

  @override
  List<Object> get props => [todos];
}

class TodosLoading extends TodoState {
  const TodosLoading();
}

class TodosSuccess extends TodoState {
  const TodosSuccess({super.todos});
}
