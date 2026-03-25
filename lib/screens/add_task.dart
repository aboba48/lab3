import 'package:flutter/material.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  // Контролери для текстових полів [cite: 250]
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  // Змінні стану [cite: 250]
  String _selectedCategory = 'Робота';
  String _selectedPriority = 'Високий';
  DateTime _selectedDate = DateTime(2026, 3, 15);

  @override
  void dispose() {
    // Звільнення ресурсів [cite: 250]
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _saveTask() {
    // Генерація ID згідно з інструкцією [cite: 250]
    final String id = DateTime.now().millisecondsSinceEpoch.toString();
    
    // Вивід у консоль [cite: 237]
    print('--- Нове завдання ---');
    print('ID: $id');
    print('Назва: ${_titleController.text}');
    print('Опис: ${_descController.text}');
    print('Категорія: $_selectedCategory');
    print('Пріоритет: $_selectedPriority');
    print('Дата: ${_selectedDate.day}.${_selectedDate.month}.${_selectedDate.year}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F5FA), // Світлий фон як на фото
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Icon(Icons.arrow_back, color: Colors.black),
        title: const Text('Нове завдання', style: TextStyle(color: Colors.black)),
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
              decoration: _inputDecoration('Введіть назву завдання'),
            ),
            const SizedBox(height: 20),
            _buildLabel('Опис'),
            TextField(
              controller: _descController,
              maxLines: 4, // Багаторядкове поле [cite: 98]
              decoration: _inputDecoration('Додайте детальний опис завдання'),
            ),
            const SizedBox(height: 20),
            _buildLabel('Категорія'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _categoryItem(Icons.work, 'Робота', const Color.fromARGB(255, 245, 35, 140)),
                _categoryItem(Icons.person, 'Особисте', const Color.fromARGB(255, 248, 34, 180)),
                _categoryItem(Icons.school, 'Навчання', const Color.fromARGB(255, 245, 42, 170)),
                _categoryItem(Icons.shopping_cart, 'Покупки', const Color.fromARGB(255, 252, 42, 238)),
              ],
            ),
            const SizedBox(height: 20),
            _buildLabel('Дата виконання'),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${_selectedDate.day}.${_selectedDate.month}.${_selectedDate.year}'),
                  const Icon(Icons.calendar_month, color: Colors.grey),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildLabel('Пріоритет'),
            Row(
              children: [
                _priorityChip('Високий', const Color(0xFFFFE5E5), Colors.red, true),
                const SizedBox(width: 8),
                _priorityChip('Середній', Colors.grey.shade100, Colors.grey, false),
                const SizedBox(width: 8),
                _priorityChip('Низький', Colors.grey.shade100, Colors.grey, false),
              ],
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _saveTask,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A90E2), // Блакитна кнопка [cite: 99]
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Створити завдання', style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Допоміжні методи для стилізації
  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 10),
      child: Text(text, style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.all(16),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF4A90E2)),
      ),
    );
  }

  Widget _categoryItem(IconData icon, String label, Color color) {
    bool isSelected = _selectedCategory == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedCategory = label), // Зміна через setState [cite: 250]
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSelected ? color.withOpacity(0.1) : Colors.grey.shade100,
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

  Widget _priorityChip(String label, Color bgColor, Color textColor, bool isSelected) {
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedPriority = label),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: _selectedPriority == label ? bgColor : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(25),
            border: _selectedPriority == label ? Border.all(color: textColor.withOpacity(0.5)) : null,
          ),
          child: Center(
            child: Text(label, style: TextStyle(color: _selectedPriority == label ? textColor : Colors.grey)),
          ),
        ),
      ),
    );
  }
}