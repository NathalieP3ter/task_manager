import 'package:flutter_test/flutter_test.dart';
import 'package:task_manager/models/task.dart';
import 'package:task_manager/services/task_service.dart';

void main() {
  late TaskService service;
  late Task lowTask;
  late Task mediumTask;
  late Task highTask;
  late Task completedTask;
  late Task overdueTask;

  Task makeTask({
    required String id,
    required String title,
    String description = '',
    Priority priority = Priority.medium,
    DateTime? dueDate,
    bool isCompleted = false,
  }) {
    return Task(
      id: id,
      title: title,
      description: description,
      priority: priority,
      dueDate: dueDate ?? DateTime.now().add(const Duration(days: 1)),
      isCompleted: isCompleted,
    );
  }
}
