import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:flutter_todo/data/sources/task_local_datasource.dart';
import 'package:flutter_todo/data/models/task_model.dart';
import 'package:flutter_todo/data/models/task_model_adapter.dart';

void main() {
  late Directory tempDir;
  late TaskLocalDataSourceImpl local;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    tempDir = await Directory.systemTemp.createTemp();
    Hive.init(tempDir.path);
    Hive.registerAdapter(TaskModelAdapter());
    await Hive.openBox<TaskModel>('tasks');
    local = TaskLocalDataSourceImpl();
  });

  tearDownAll(() async {
    await Hive.deleteBoxFromDisk('tasks');
    await tempDir.delete(recursive: true);
  });

  final task = TaskModel(id: '1', title: 'Test', completed: false);

  test('saves and retrieves tasks', () async {
    await local.saveTasks([task]);
    final tasks = await local.getTasks();

    expect(tasks.length, 1);
    expect(tasks.first.title, 'Test');
  });
}
