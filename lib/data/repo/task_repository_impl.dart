import '../../domain/entities/task.dart';
import '../../domain/repo/task_repository.dart';
import '../sources/task_remote_datasource.dart';
import '../sources/task_local_datasource.dart';
import '../models/task_model.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskRemoteDataSource remote;
  final TaskLocalDataSource local;
  final Connectivity connectivity;

  TaskRepositoryImpl({
    required this.remote,
    required this.local,
    required this.connectivity,
  });

Future<bool> get _isOnline async {
  final results = await connectivity.checkConnectivity();
  return results.any((r) => r != ConnectivityResult.none);
}


  @override
  Future<List<Task>> getTasks() async {
    if (await _isOnline) {
      final tasks = await remote.fetchTasks();
      await local.saveTasks(tasks);
      return tasks;
    } else {
      return await local.getTasks();
    }
  }

  @override
  Future<Task> addTask(String title) async {
    if (await _isOnline) {
      final task = await remote.addTask(title);
      await local.upsertTask(task);
      return task;
    } else {
      final task = TaskModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        completed: false,
        pendingSync: true,
      );
      await local.upsertTask(task);
      return task;
    }
  }

  @override
  Future<Task> updateTask(Task task) async {
    final model = TaskModel(
      id: task.id,
      title: task.title,
      completed: task.completed,
      pendingSync: false,
    );

    if (await _isOnline) {
      final updated = await remote.updateTask(model);
      await local.upsertTask(updated);
      return updated;
    } else {
      final offline = TaskModel(
        id: model.id,
        title: model.title,
        completed: model.completed,
        pendingSync: true,
      );
      await local.upsertTask(offline);
      return offline;
    }
  }

  @override
  Future<void> deleteTask(String id) async {
    if (await _isOnline) {
      await remote.deleteTask(id);
    }
    await local.deleteTask(id);
  }

  @override
  Future<void> syncPendingTasks() async {
    if (!await _isOnline) return;

    final pending = await local.getPendingTasks();
    for (final task in pending) {
      final synced = await remote.updateTask(task);
      await local.upsertTask(synced);
    }
  }
}
