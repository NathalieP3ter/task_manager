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

setUp(() {
    service = TaskService();

    lowTask = makeTask(
      id: '1',
      title: 'Low Task',
      priority: Priority.low,
      dueDate: DateTime.now().add(const Duration(days: 3)),
    );
    
    mediumTask = makeTask(
      id: '2',
      title: 'Medium Task',
      priority: Priority.medium,
      dueDate: DateTime.now().add(const Duration(days: 2)),
    );

    highTask = makeTask(
      id: '3',
      title: 'High Task',
      priority: Priority.high,
      dueDate: DateTime.now().add(const Duration(days: 1)),
    );

     completedTask = makeTask(
      id: '4',
      title: 'Completed Task',
      dueDate: DateTime.now().subtract(const Duration(days: 1)),
      isCompleted: true,
    );

    overdueTask = makeTask(
      id: '5',
      title: 'Overdue Task',
      dueDate: DateTime.now().subtract(const Duration(days: 2)),
      isCompleted: false,
    );
  });

}
