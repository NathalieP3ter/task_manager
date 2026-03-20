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
  group('Task Model — isOverdue getter', () {
    test('returns true when task is incomplete and due date is in the past', () {
      final task = makeTask(
        id: '301',
        title: 'Late',
        dueDate: DateTime.now().subtract(const Duration(days: 1)),
      );

      expect(task.isOverdue, isTrue);
    });

    test('returns false when due date is in the future', () {
      final task = makeTask(
        id: '302',
        title: 'Upcoming',
        dueDate: DateTime.now().add(const Duration(days: 1)),
      );

      expect(task.isOverdue, isFalse);
    });

    test('returns false when task is completed even if past due', () {
      final task = makeTask(
        id: '303',
        title: 'Finished',
        dueDate: DateTime.now().subtract(const Duration(days: 1)),
        isCompleted: true,
      );

      expect(task.isOverdue, isFalse);
    });
  });

   group('Task Model — toJson() / fromJson()', () {
    test('preserves values in serialization round-trip', () {
      final original = makeTask(
        id: '401',
        title: 'Serialize',
        description: 'Round trip',
        priority: Priority.high,
        dueDate: DateTime(2026, 6, 10),
        isCompleted: true,
      );

      final restored = Task.fromJson(original.toJson());

      expect(restored.id, equals(original.id));
      expect(restored.title, equals(original.title));
      expect(restored.priority, equals(original.priority));
      expect(restored.isCompleted, equals(original.isCompleted));
    });

    test('produces expected json field types', () {
      final json = makeTask(id: '402', title: 'Field Types').toJson();

      expect(json['id'], isA<String>());
      expect(json['priority'], isA<int>());
      expect(json['dueDate'], isA<String>());
    });

    test('stores and restores priority using enum index', () {
      final task = makeTask(id: '403', title: 'Priority', priority: Priority.high);
      final json = task.toJson();

      expect(json['priority'], equals(Priority.high.index));
      expect(Task.fromJson(json).priority, equals(Priority.high));
    });
  });

   group('TaskService — deleteTask()', () {
    test('deletes an existing task', () {
      service.addTask(lowTask);
      service.deleteTask(lowTask.id);

      expect(service.allTasks.any((t) => t.id == lowTask.id), isFalse);
    });

    test('does nothing when deleting a non-existent id', () {
      service.addTask(lowTask);
      service.deleteTask('missing');

      expect(service.allTasks.length, equals(1));
    });
  });

  group('TaskService — toggleComplete()', () {
    test('changes completion from false to true', () {
      service.addTask(lowTask);
      service.toggleComplete(lowTask.id);

      expect(service.allTasks.first.isCompleted, isTrue);
    });

    test('changes completion from true to false', () {
      service.addTask(completedTask);
      service.toggleComplete(completedTask.id);

      expect(service.allTasks.first.isCompleted, isFalse);
    });

    test('throws StateError for unknown id', () {
      expect(() => service.toggleComplete('unknown'), throwsA(isA<StateError>()));
    });
  });

  group('TaskService — getByStatus()', () {
    test('returns only active tasks', () {
      service.addTask(lowTask);
      service.addTask(completedTask);

      expect(service.getByStatus(completed: false).length, equals(1));
    });

    test('returns only completed tasks', () {
      service.addTask(lowTask);
      service.addTask(completedTask);

      expect(service.getByStatus(completed: true).length, equals(1));
    });
  });



  
}
