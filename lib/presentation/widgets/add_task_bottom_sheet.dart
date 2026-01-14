import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/task_bloc.dart';
import '../bloc/task_event.dart';

import '../../core/constants/app_strings.dart';
import '../../core/constants/padding.dart';
import '../../core/constants/sizing.dart';

class AddTaskBottomSheet extends StatefulWidget {
  const AddTaskBottomSheet({super.key});

  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        padding: const EdgeInsets.all(AppPadding.p16),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppSizing.s24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              AppStrings.addTask,
              style: TextStyle(
                fontSize: AppSizing.s18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSizing.s12),
            TextField(
              controller: _controller,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: AppStrings.taskHint,
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: AppSizing.s12),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
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
            ),
          ],
        ),
      ),
    );
  }
}
