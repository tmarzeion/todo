import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../../presentation/views/todos_list_view.dart';

part 'app_router.gr.dart';

@AdaptiveAutoRouter(
  routes: [
    AutoRoute(page: TodosListView, initial: true),
  ],
)
class AppRouter extends _$AppRouter {}

final appRouter = AppRouter();
