import 'package:flutter/material.dart';
import 'screens/task_list.dart';
import 'screens/add_task.dart';
import 'screens/detali.dart';

void main() {
  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AddTaskScreen(), 
    );
  }
}