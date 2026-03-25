import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  // Додаємо список у стан 
  List<Task> _tasks = [];

  @override
  void initState() {
    super.initState();
    // Додаємо тестові завдання
    _tasks = [
      Task(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: 'Завдання 1: Розібратись у Flutter',
        description: 'Пройти документацію по StatefulWidget.',
        category: 'Навчання',
        date: DateTime.now(),
      ),
      Task(
        id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
        title: 'Завдання 2: ПаІгртАтЬ в КАМПУТЕР',
        description: 'Дедлок.',
        category: 'Розваги',
        date: DateTime.now(),
        isCompleted: true,
      ),
    ];
  }

  // Змінює статус isCompleted
  void _toggleTaskStatus(String id) {
    setState(() {
      final task = _tasks.firstWhere((t) => t.id == id);
      task.isCompleted = !task.isCompleted;
    });
    print('Статус завдання $id змінено');
  }

  // Видаляє завдання
  void _deleteTask(String id) {
    setState(() {
      _tasks.removeWhere((t) => t.id == id);
    });
    print('Завдання $id видалено');
  }

  // Додає нове завдання 
  void _addTask(Task task) {
    setState(() {
      _tasks.add(task);
    });
    print('Додано нове завдання: ${task.title}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Мої завдання'),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: _tasks.length,
        itemBuilder: (context, index) {
          final task = _tasks[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
            child: ListTile(
              leading: Checkbox(
                value: task.isCompleted,
                onChanged: (value) => _toggleTaskStatus(task.id),
              ),
              title: Text(task.title),
              subtitle: Text('Створено: ${task.date.day}.${task.date.month}.${task.date.year}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.category, color: Colors.blue),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _deleteTask(task.id),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print("Тут буде перехід на AddTaskScreen");
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}