import 'package:flutter_bloc/flutter_bloc.dart';
import 'task_event.dart';
import 'task_state.dart';
import '../../domain/repo/task_repository.dart';
import '../../domain/entities/task.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskRepository repository;
  List<Task> _allTasks = [];

  TaskBloc(this.repository) : super(TaskInitial()) {
    on<LoadTasks>(_onLoadTasks);
    on<AddTask>(_onAddTask);
    on<UpdateTask>(_onUpdateTask);
    on<DeleteTask>(_onDeleteTask);
    on<SearchTasks>(_onSearchTasks);
    on<SyncTasks>(_onSyncTasks);
  }

  Future<void> _onLoadTasks(LoadTasks event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      _allTasks = await repository.getTasks();
      emit(TaskLoaded(_allTasks));
    } catch (e) {
      emit(TaskError('Failed to load tasks'));
    }
  }

  Future<void> _onAddTask(AddTask event, Emitter<TaskState> emit) async {
    try {
      final task = await repository.addTask(event.title);
      _allTasks = List.from(_allTasks)..add(task);
      emit(TaskLoaded(_allTasks));
    } catch (e) {
      emit(TaskError('Failed to add task'));
    }
  }

  Future<void> _onUpdateTask(UpdateTask event, Emitter<TaskState> emit) async {
    try {
      final updated = await repository.updateTask(event.task);
      _allTasks = _allTasks
          .map((t) => t.id == updated.id ? updated : t)
          .toList();
      emit(TaskLoaded(_allTasks));
    } catch (e) {
      emit(TaskError('Failed to update task'));
    }
  }

  Future<void> _onDeleteTask(DeleteTask event, Emitter<TaskState> emit) async {
    try {
      await repository.deleteTask(event.id);
      _allTasks = _allTasks.where((t) => t.id != event.id).toList();
      emit(TaskLoaded(_allTasks));
    } catch (e) {
      emit(TaskError('Failed to delete task'));
    }
  }

  void _onSearchTasks(SearchTasks event, Emitter<TaskState> emit) {
    final filtered = _allTasks
        .where((t) => t.title.toLowerCase().contains(event.query.toLowerCase()))
        .toList();
    emit(TaskLoaded(filtered));
  }

  Future<void> _onSyncTasks(SyncTasks event, Emitter<TaskState> emit) async {
    try {
      await repository.syncPendingTasks();
      _allTasks = await repository.getTasks();
      emit(TaskLoaded(_allTasks));
    } catch (e) {
      emit(TaskError('Sync failed'));
    }
  }
}
