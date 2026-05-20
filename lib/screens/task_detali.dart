import 'package:flutter/material.dart';
import '../models/task.dart';
import 'add_task.dart'; 

class TaskDetailScreen extends StatefulWidget {
  final Task task; 

  const TaskDetailScreen({super.key, required this.task});

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  late Task _currentTask;

  @override
  void initState() {
    super.initState();
    _currentTask = widget.task;
  }

  // ВИПРАВЛЕНО: Безпечний асинхронний метод видалення
  void _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Видалити завдання?'),
        content: const Text('Ви дійсно хочете видалити це завдання? Дія незворотна.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false), 
            child: const Text('Ні'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true), 
            child: const Text('Так, видалити', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    // Перевірка, чи екран все ще існує в дереві віджетів (захист від async gaps)
    if (!mounted) return;

    if (confirmed == true) {
      Navigator.pop(context, 'delete'); 
    }
  }

  void _editTask() async {
    final updatedTask = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddTaskScreen(taskToEdit: _currentTask),
      ),
    );

    if (!mounted) return;

    if (updatedTask != null && updatedTask is Task) {
      setState(() {
        _currentTask = updatedTask; 
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F5FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context, _currentTask), 
        ),
        title: const Text('Деталі', style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              _currentTask.title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ЗАМІНЕНО .withOpacity на .withValues
                _buildChip(Icons.category, _currentTask.category, Colors.blue.withValues(alpha: 0.1), Colors.blue),
                const SizedBox(width: 12),
                _buildChip(Icons.priority_high, _currentTask.priority, Colors.red.withValues(alpha: 0.1), Colors.red),
              ],
            ),
            const SizedBox(height: 30),

            _buildDetailCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Опис', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 12),
                  Text(_currentTask.description.isEmpty ? 'Опис відсутній' : _currentTask.description, style: const TextStyle(color: Colors.black87, height: 1.5)),
                ],
              ),
            ),

            _buildDetailCard(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Статус виконання', style: TextStyle(fontSize: 16)),
                  Switch(
                    value: _currentTask.isCompleted,
                    onChanged: (value) {
                      setState(() {
                        _currentTask.isCompleted = value;
                      });
                    },
                    // ЗАМІНЕНО застарілий activeColor на activeThumbColor
                    activeThumbColor: Colors.blue,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _editTask, 
                    icon: const Icon(Icons.edit, size: 18),
                    label: const Text('Редагувати'),
                    style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 15)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _confirmDelete, 
                    icon: const Icon(Icons.delete, color: Colors.white, size: 18),
                    label: const Text('Видалити', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE5533D), padding: const EdgeInsets.symmetric(vertical: 15)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(IconData icon, String label, Color bgColor, Color textColor) => Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(20)), child: Row(children: [Icon(icon, size: 16, color: textColor), const SizedBox(width: 6), Text(label, style: TextStyle(color: textColor, fontWeight: FontWeight.w500))]));
  
  Widget _buildDetailCard({required Widget child}) => Container(width: double.infinity, margin: const EdgeInsets.only(bottom: 16), padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))]), child: child);
}