import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/task_bloc.dart';
import '../bloc/task_event.dart';
import '../bloc/task_state.dart';
import '../../core/network/connectivity_cubit.dart';
import '../widgets/task_list_view.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/padding.dart';
import '../../core/constants/sizing.dart';
import '../widgets/add_task_bottom_sheet.dart';
import 'login_page.dart';
import '../../core/auth/auth_service.dart';

class TaskPage extends StatelessWidget {
  TaskPage({super.key});

  final _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);

    return BlocListener<ConnectivityCubit, bool>(
      listener: (context, isOnline) {
        if (isOnline) {
          context.read<TaskBloc>().add(SyncTasks());
        }
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text(AppStrings.appTitle),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                await _auth.logout();

                if (!context.mounted) return;

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(AppStrings.logoutSuccess),
                    duration: Duration(milliseconds: 200),
                  ),
                );

                await Future.delayed(const Duration(milliseconds: 300));

                navigator.pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(AppSizing.s24),
              ),
            ),
            builder: (_) => const AddTaskBottomSheet(),
          ),
          icon: const Icon(Icons.edit),
          label: const Text(AppStrings.addTask),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppPadding.p12),
              child: TextField(
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: AppStrings.searchHint,
                ),
                onChanged: (q) => context.read<TaskBloc>().add(SearchTasks(q)),
              ),
            ),
            Expanded(
              child: BlocListener<TaskBloc, TaskState>(
                listener: (context, state) {
                  if (state is TaskError) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(state.message)));
                  }
                },
                child: BlocBuilder<TaskBloc, TaskState>(
                  builder: (context, state) {
                    if (state is TaskLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is TaskError) {
                      return Center(child: Text(state.message));
                    }

                    if (state is TaskLoaded) {
                      return TaskListView(tasks: state.tasks);
                    }

                    return const SizedBox();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
