import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/task_bloc.dart';
import '../bloc/task_event.dart';
import '../../core/constants/app_strings.dart';

class AddTaskDialog extends StatelessWidget {
  AddTaskDialog({super.key});

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(AppStrings.addTask),
      content: TextField(
        controller: _controller,
        decoration: const InputDecoration(hintText: AppStrings.addTask),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(AppStrings.cancel),
        ),
        ElevatedButton(
          onPressed: _controller.text.trim().isEmpty
              ? null
              : () {
                  context.read<TaskBloc>().add(
                    AddTask(_controller.text.trim()),
                  );
                  Navigator.pop(context);
                },
          child: const Text(AppStrings.add),
        ),
      ],
    );
  }
}
