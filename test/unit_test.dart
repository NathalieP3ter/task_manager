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

  group('Task Model — Constructor & Properties', () {
    test('stores required constructor values correctly', () {
      final dueDate = DateTime(2026, 3, 20);
      final task = Task(id: '101', title: 'Study', dueDate: dueDate);

      expect(task.id, equals('101'));
      expect(task.title, equals('Study'));
      expect(task.dueDate, equals(dueDate));
    });

    test('uses empty string as default description', () {
      final task = Task(id: '102', title: 'Buy groceries', dueDate: DateTime(2026, 3, 21));
      expect(task.description, equals(''));
    });

    test('uses medium as default priority', () {
      final task = Task(id: '103', title: 'Homework', dueDate: DateTime(2026, 3, 22));
      expect(task.priority, equals(Priority.medium));
    });

    test('uses false as default completion state', () {
      final task = Task(id: '104', title: 'Clean room', dueDate: DateTime(2026, 3, 23));
      expect(task.isCompleted, isFalse);
    });
  });

   group('Task Model — copyWith()', () {
    test('updates only provided fields during partial update', () {
      final original = makeTask(
        id: '201',
        title: 'Original',
        description: 'Desc',
        priority: Priority.low,
        dueDate: DateTime(2026, 4, 1),
      );

      final updated = original.copyWith(title: 'Updated');

      expect(updated.title, equals('Updated'));
      expect(updated.description, equals('Desc'));
      expect(updated.priority, equals(Priority.low));
    });

    test('updates all fields during full update', () {
      final original = makeTask(id: '202', title: 'Old');

      final updated = original.copyWith(
        id: '203',
        title: 'New',
        description: 'New Desc',
        priority: Priority.high,
        dueDate: DateTime(2026, 5, 2),
        isCompleted: true,
      );

      expect(updated.id, equals('203'));
      expect(updated.title, equals('New'));
      expect(updated.description, equals('New Desc'));
      expect(updated.priority, equals(Priority.high));
      expect(updated.dueDate, equals(DateTime(2026, 5, 2)));
      expect(updated.isCompleted, isTrue);
    });

    test('keeps original task unchanged after copyWith', () {
      final original = makeTask(id: '204', title: 'Immutable');
      final updated = original.copyWith(title: 'Changed');

      expect(original.title, equals('Immutable'));
      expect(updated.title, equals('Changed'));
    });
  }); 


}
