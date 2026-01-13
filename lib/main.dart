import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_todo/data/models/task_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/network/api_client.dart';
import 'data/sources/task_local_datasource.dart';
import 'data/sources/task_remote_datasource.dart';
import 'data/models/task_model_adapter.dart';
import 'data/repo/task_repository_impl.dart';
import 'domain/repo/task_repository.dart';
import 'presentation/bloc/task_bloc.dart';
import 'presentation/pages/login_page.dart';
import 'presentation/bloc/task_event.dart';
import 'core/network/connectivity_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TaskModelAdapter());
  await Hive.openBox<TaskModel>('tasks');

  final repository = TaskRepositoryImpl(
    remote: TaskRemoteDataSourceImpl(ApiClient()),
    local: TaskLocalDataSourceImpl(),
    connectivity: Connectivity(),
  );

  runApp(MyApp(repository: repository));
}

class MyApp extends StatelessWidget {
  final TaskRepository repository;

  const MyApp({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: repository,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => TaskBloc(repository)..add(LoadTasks())),
          BlocProvider(create: (_) => ConnectivityCubit(Connectivity())),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: const LoginPage(),
        ),
      ),
    );
  }
}
