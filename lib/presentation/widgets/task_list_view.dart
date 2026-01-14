import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/task.dart';
import '../bloc/task_bloc.dart';
import '../bloc/task_event.dart';

import '../../core/constants/app_strings.dart';
import '../../core/constants/padding.dart';
import '../../core/constants/sizing.dart';

class TaskListView extends StatelessWidget {
  final List<Task> tasks;

  const TaskListView({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => context.read<TaskBloc>().add(LoadTasks()),
      child: ListView.builder(
        padding: const EdgeInsets.only(
          bottom: AppPadding.p100,
          top: AppPadding.p08,
        ),
        itemCount: tasks.length,
        itemBuilder: (_, i) {
          final task = tasks[i];
          final initial = task.title.isNotEmpty
              ? task.title[0].toUpperCase()
              : '?';

          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppPadding.p12,
              vertical: AppPadding.p06,
            ),
            child: Dismissible(
              key: Key(task.id),
              onDismissed: (_) =>
                  context.read<TaskBloc>().add(DeleteTask(task.id)),
              child: Stack(
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSizing.s16),
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
                              fontSize: AppSizing.s16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (task.pendingSync)
                            Padding(
                              padding: const EdgeInsets.only(
                                top: AppPadding.p04,
                              ),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppPadding.p12,
                                  vertical: AppPadding.p04,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.orange.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(
                                    AppSizing.s20,
                                  ),
                                ),
                                child: const Text(
                                  AppStrings.pendingSync,
                                  style: TextStyle(
                                    color: Colors.orange,
                                    fontSize: AppSizing.s12,
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

                  // Top-right status badge
                  Positioned(
                    top: AppPadding.p08,
                    right: AppPadding.p12,
                    child: Container(
                      width: AppSizing.s10,
                      height: AppSizing.s10,
                      decoration: BoxDecoration(
                        color: task.completed ? Colors.green : Colors.orange,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
