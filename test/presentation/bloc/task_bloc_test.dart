import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_todo/domain/entities/task.dart';
import 'package:flutter_todo/domain/repo/task_repository.dart';
import 'package:flutter_todo/presentation/bloc/task_bloc.dart';
import 'package:flutter_todo/presentation/bloc/task_event.dart';
import 'package:flutter_todo/presentation/bloc/task_state.dart';

class MockTaskRepository extends Mock implements TaskRepository {}

void main() {
  late MockTaskRepository repo;
  late TaskBloc bloc;

  final task = Task(id: '1', title: 'Test', completed: false);

  setUpAll(() {
    registerFallbackValue(
      const Task(id: 'fallback', title: 'fallback', completed: false),
    );
  });

  setUp(() {
    repo = MockTaskRepository();
    bloc = TaskBloc(repo);
  });

  blocTest<TaskBloc, TaskState>(
    'emits [Loading, Loaded] on LoadTasks',
    build: () {
      when(() => repo.getTasks()).thenAnswer((_) async => [task]);
      return bloc;
    },
    act: (bloc) => bloc.add(LoadTasks()),
    expect: () => [
      isA<TaskLoading>(),
      TaskLoaded([task]),
    ],
  );

  blocTest<TaskBloc, TaskState>(
    'adds task on AddTask',
    build: () {
      when(() => repo.addTask(any())).thenAnswer((_) async => task);
      return bloc;
    },
    act: (bloc) => bloc.add(AddTask('Test')),
    expect: () => [
      TaskLoaded([task]),
    ],
  );

  blocTest<TaskBloc, TaskState>(
    'updates task when UpdateTask is called',
    build: () {
      when(
        () => repo.updateTask(any()),
      ).thenAnswer((_) async => task.copyWith(completed: true));
      return bloc;
    },
    act: (bloc) => bloc.add(UpdateTask(task)),
    expect: () => [isA<TaskLoaded>()],
  );

  blocTest<TaskBloc, TaskState>(
    'deletes task when DeleteTask is called',
    build: () {
      when(() => repo.deleteTask(any())).thenAnswer((_) async {});
      return bloc;
    },
    act: (bloc) => bloc.add(DeleteTask(task.id)),
    expect: () => [isA<TaskLoaded>()],
  );

  blocTest<TaskBloc, TaskState>(
    'syncs and reloads tasks',
    build: () {
      when(() => repo.syncPendingTasks()).thenAnswer((_) async {});
      when(() => repo.getTasks()).thenAnswer((_) async => []);
      return bloc;
    },
    act: (bloc) => bloc.add(SyncTasks()),
    expect: () => [isA<TaskLoaded>()],
  );
}
