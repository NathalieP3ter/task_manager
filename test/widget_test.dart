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

  
}