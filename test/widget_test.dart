import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';


import 'package:task_manager/providers/task_provider.dart';
import 'package:task_manager/screens/task_list_screen.dart';

void main() {

  // 🔹 Helper to wrap app with provider
  Widget createTestApp() {
    return ChangeNotifierProvider(
      create: (_) => TaskProvider(),
      child: const MaterialApp(
        home: TaskListScreen(),
      ),
    );
  }

  testWidgets('shows empty state when no tasks exist', (WidgetTester tester) async {
    await tester.pumpWidget(createTestApp());

    expect(find.text('No tasks yet. Tap + to add one!'), findsOneWidget);
  });

  testWidgets('navigates to Add Task screen when FAB is tapped', (WidgetTester tester) async {
    await tester.pumpWidget(createTestApp());

    await tester.tap(find.byKey(const Key('add_task_fab')));
    await tester.pumpAndSettle();

    expect(find.text('Add Task'), findsOneWidget);
  });




  
}