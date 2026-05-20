import 'package:flutter/material.dart';
import '../models/task.dart'; // Імпорт оновленої моделі з дедлайном

class AddTaskScreen extends StatefulWidget {
  final Task? taskToEdit; 

  const AddTaskScreen({super.key, this.taskToEdit});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  String _selectedCategory = 'Робота';
  String _selectedPriority = 'Високий';
  DateTime _selectedDate = DateTime.now(); // Дата дедлайну для календаря

  @override
  void initState() {
    super.initState();
    // Якщо ми редагуємо завдання, заповнюємо поля існуючими даними
    if (widget.taskToEdit != null) {
      _titleController.text = widget.taskToEdit!.title;
      _descController.text = widget.taskToEdit!.description;
      _selectedCategory = widget.taskToEdit!.category;
      _selectedPriority = widget.taskToEdit!.priority;
      _selectedDate = widget.taskToEdit!.dueDate; // Беремо збережений дедлайн
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _saveTask() {
    if (_titleController.text.isEmpty) return;

    // Створюємо або оновлюємо об'єкт Task з урахуванням дедлайну та ID події Google Календаря
    final task = Task(
      id: widget.taskToEdit?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text,
      description: _descController.text,
      isCompleted: widget.taskToEdit?.isCompleted ?? false,
      category: _selectedCategory,
      priority: _selectedPriority,
      createdAt: widget.taskToEdit?.createdAt ?? DateTime.now(),
      dueDate: _selectedDate, // Передаємо дедлайн у модель
      googleEventId: widget.taskToEdit?.googleEventId,
    );

    Navigator.pop(context, task);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.taskToEdit != null;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context), 
        ),
        title: Text(isEditing ? 'Редагувати' : 'Нове завдання'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel('Назва завдання'),
            TextField(
              controller: _titleController, 
              decoration: _inputDecoration('Введіть назву'),
            ),
            const SizedBox(height: 20),
            
            _buildLabel('Опис'),
            TextField(
              controller: _descController, 
              maxLines: 3, 
              decoration: _inputDecoration('Додайте опис'),
            ),
            const SizedBox(height: 20),
            
            // Новий блок: Вибір дати дедлайну для інтеграції з Google Календарем
            _buildLabel('Термін виконання (Дедлайн)'),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey.shade300),
              ),
              child: ListTile(
                leading: const Icon(Icons.calendar_today, color: Color(0xFF4A90E2)),
                title: Text(
                  "Обрано: ${_selectedDate.toLocal().toString().substring(0, 10)}",
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                trailing: const Icon(Icons.edit, size: 20),
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime.now().subtract(const Duration(days: 365)),
                    lastDate: DateTime.now().add(const Duration(days: 3650)),
                  );
                  if (picked != null && picked != _selectedDate) {
                    setState(() {
                      _selectedDate = picked;
                    });
                  }
                },
              ),
            ),
            const SizedBox(height: 20),
            
            _buildLabel('Категорія'),
            Wrap(
              spacing: 15,
              children: [
                _categoryItem(Icons.work, 'Робота', Colors.blue),
                _categoryItem(Icons.person, 'Особисте', Colors.orange),
                _categoryItem(Icons.school, 'Навчання', Colors.pink),
              ],
            ),
            const SizedBox(height: 20),
            
            _buildLabel('Пріоритет'),
            Row(
              children: [
                _priorityChip('Високий', Colors.red),
                const SizedBox(width: 8),
                _priorityChip('Середній', Colors.orange),
                const SizedBox(width: 8),
                _priorityChip('Низький', Colors.green),
              ],
            ),
            const SizedBox(height: 40),
            
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _saveTask,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A90E2),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  isEditing ? 'Зберегти зміни' : 'Створити завдання', 
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 8.0, top: 10), 
        child: Text(text, style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
      );
  
  InputDecoration _inputDecoration(String hint) => InputDecoration(
        hintText: hint, 
        filled: true, 
        fillColor: Colors.white, 
        contentPadding: const EdgeInsets.all(16), 
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)), 
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF4A90E2))),
      );

  Widget _categoryItem(IconData icon, String label, Color color) {
    bool isSelected = _selectedCategory == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedCategory = label),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSelected ? color.withValues(alpha: 0.1) : Colors.grey.shade100, 
              shape: BoxShape.circle, 
              border: isSelected ? Border.all(color: color, width: 2) : null,
            ),
            child: Icon(icon, color: isSelected ? color : Colors.grey),
          ),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(color: isSelected ? color : Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _priorityChip(String label, Color color) {
    bool isSelected = _selectedPriority == label;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedPriority = label),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? color.withValues(alpha: 0.1) : Colors.grey.shade100, 
            borderRadius: BorderRadius.circular(25), 
            border: isSelected ? Border.all(color: color) : null,
          ),
          child: Center(child: Text(label, style: TextStyle(color: isSelected ? color : Colors.grey))),
        ),
      ),
    );
  }
}