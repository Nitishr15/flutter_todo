import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_todo/data/models/task_model.dart';

void main() {
  test('parses todo json correctly', () {
    final json = {'id': 1, 'title': 'Test', 'completed': false};

    final task = TaskModel.fromJson(json);

    expect(task.id, '1');
    expect(task.title, 'Test');
    expect(task.completed, false);
  });
}
