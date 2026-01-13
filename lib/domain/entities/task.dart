import 'package:equatable/equatable.dart';

class Task extends Equatable {
  final String id;
  final String title;
  final bool completed;
  final bool pendingSync;

  const Task({
    required this.id,
    required this.title,
    required this.completed,
    this.pendingSync = false,
  });

  Task copyWith({
    String? id,
    String? title,
    bool? completed,
    bool? pendingSync,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      completed: completed ?? this.completed,
      pendingSync: pendingSync ?? this.pendingSync,
    );
  }

  @override
  List<Object?> get props => [id, title, completed, pendingSync];
}
