import 'package:get_it/get_it.dart';
import 'package:todo/src/utils/constants.dart';

import 'data/app_database.dart';
import 'data/repositories/database_repository_impl.dart';
import 'domain/repositories/database_repository.dart';

final locator = GetIt.instance;

Future<void> initializeDependencies() async {
  final db = await $FloorAppDatabase.databaseBuilder(databaseName).build();
  locator.registerSingleton<AppDatabase>(db);
  locator.registerSingleton<DatabaseRepository>(
    DatabaseRepositoryImpl(locator<AppDatabase>()),
  );
}
