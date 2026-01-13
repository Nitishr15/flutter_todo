import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/task.dart';
import '../bloc/task_bloc.dart';
import '../bloc/task_event.dart';

class TaskListView extends StatelessWidget {
  final List<Task> tasks;

  const TaskListView({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => context.read<TaskBloc>().add(LoadTasks()),
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 100, top: 8),
        itemCount: tasks.length,
        itemBuilder: (_, i) {
          final task = tasks[i];
          final initial = task.title.isNotEmpty
              ? task.title[0].toUpperCase()
              : '?';

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Dismissible(
              key: Key(task.id),
              onDismissed: (_) =>
                  context.read<TaskBloc>().add(DeleteTask(task.id)),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blueGrey,
                    child: Text(initial),
                  ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (task.pendingSync)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 242, 194, 122),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'Pending sync',
                              style: TextStyle(
                                color: Colors.orange,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  onTap: () => context.read<TaskBloc>().add(
                    UpdateTask(task.copyWith(completed: !task.completed)),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
