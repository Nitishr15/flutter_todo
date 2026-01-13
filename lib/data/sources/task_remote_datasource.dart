import '../models/task_model.dart';
import '../../core/network/api_client.dart';

abstract class TaskRemoteDataSource {
  Future<List<TaskModel>> fetchTasks();
  Future<TaskModel> addTask(String title);
  Future<TaskModel> updateTask(TaskModel task);
  Future<void> deleteTask(String id);
}

class TaskRemoteDataSourceImpl implements TaskRemoteDataSource {
  final ApiClient client;

  TaskRemoteDataSourceImpl(this.client);

  @override
  Future<List<TaskModel>> fetchTasks() async {
    final data = await client.get('/todos');
    return data.map<TaskModel>((e) => TaskModel.fromJson(e)).toList();
  }

  @override
  Future<TaskModel> addTask(String title) async {
    final data = await client.post('/todos', {
      'title': title,
      'completed': false,
    });
    return TaskModel.fromJson(data);
  }

  @override
  Future<TaskModel> updateTask(TaskModel task) async {
    final data = await client.patch('/todos/${task.id}', task.toJson());
    return TaskModel.fromJson(data);
  }

  @override
  Future<void> deleteTask(String id) async {
    await client.delete('/todos/$id');
  }
}
