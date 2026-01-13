import 'package:hive/hive.dart';
import '../models/task_model.dart';

abstract class TaskLocalDataSource {
  Future<List<TaskModel>> getTasks();
  Future<void> saveTasks(List<TaskModel> tasks);
  Future<void> upsertTask(TaskModel task);
  Future<void> deleteTask(String id);
  Future<List<TaskModel>> getPendingTasks();
}

class TaskLocalDataSourceImpl implements TaskLocalDataSource {
  static const String boxName = 'tasks';

  Future<Box<TaskModel>> _box() async => await Hive.openBox<TaskModel>(boxName);

  @override
  Future<List<TaskModel>> getTasks() async {
    final box = await _box();
    return box.values.toList();
  }

  @override
  Future<void> saveTasks(List<TaskModel> tasks) async {
    final box = await _box();
    await box.clear();
    for (final task in tasks) {
      await box.put(task.id, task);
    }
  }

  @override
  Future<void> upsertTask(TaskModel task) async {
    final box = await _box();
    await box.put(task.id, task);
  }

  @override
  Future<void> deleteTask(String id) async {
    final box = await _box();
    await box.delete(id);
  }

  @override
  Future<List<TaskModel>> getPendingTasks() async {
    final box = await _box();
    return box.values.where((t) => t.pendingSync).toList();
  }
}
