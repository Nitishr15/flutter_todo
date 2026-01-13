import '../entities/task.dart';

abstract class TaskRepository {
  Future<List<Task>> getTasks();

  Future<Task> addTask(String title);

  Future<Task> updateTask(Task task);

  Future<void> deleteTask(String id);

  Future<void> syncPendingTasks();
}
