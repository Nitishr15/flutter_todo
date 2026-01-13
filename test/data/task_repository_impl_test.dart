import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_todo/data/repo/task_repository_impl.dart';
import 'package:flutter_todo/data/sources/task_remote_datasource.dart';
import 'package:flutter_todo/data/sources/task_local_datasource.dart';
import 'package:flutter_todo/data/models/task_model.dart';

class MockRemote extends Mock implements TaskRemoteDataSource {}

class MockLocal extends Mock implements TaskLocalDataSource {}

class MockConnectivity extends Mock implements Connectivity {}

void main() {
  late MockRemote remote;
  late MockLocal local;
  late MockConnectivity connectivity;
  late TaskRepositoryImpl repo;

  final task = TaskModel(id: '1', title: 'Test', completed: false);

  setUp(() {
    remote = MockRemote();
    local = MockLocal();
    connectivity = MockConnectivity();

    repo = TaskRepositoryImpl(
      remote: remote,
      local: local,
      connectivity: connectivity,
    );

    when(() => local.saveTasks(any())).thenAnswer((_) async {});
  });

  test('returns remote when online', () async {
    when(
      () => connectivity.checkConnectivity(),
    ).thenAnswer((_) async => [ConnectivityResult.wifi]);
    when(() => remote.fetchTasks()).thenAnswer((_) async => [task]);
    when(() => local.getTasks()).thenAnswer((_) async => []);

    final result = await repo.getTasks();

    expect(result, [task]);
    verify(() => local.saveTasks([task])).called(1);
  });

  test('returns local when offline', () async {
    when(
      () => connectivity.checkConnectivity(),
    ).thenAnswer((_) async => [ConnectivityResult.none]);
    when(() => local.getTasks()).thenAnswer((_) async => [task]);

    final result = await repo.getTasks();

    expect(result, [task]);
  });
}
