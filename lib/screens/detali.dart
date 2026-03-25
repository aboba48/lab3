import 'package:flutter/material.dart';

class TaskDetailScreen extends StatefulWidget {
  const TaskDetailScreen({super.key});

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  // Локальний стан для демонстрації роботи перемикача
  bool _isCompleted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F5FA), // Світлий фон як на макеті
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Icon(Icons.arrow_back, color: Colors.black),
        title: const Text('Деталі завдання', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // 1. Велика іконка категорії [cite: 131]
            Center(
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEBD8), // Світло-помаранчевий фон
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.school, size: 60, color: Color.fromARGB(255, 245, 35, 186)),
              ),
            ),
            const SizedBox(height: 24),

            // 2. Назва завдання [cite: 132]
            const Text(
              'Підготувати звіт з лаораторної',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // 3. Чіпи Категорії та Пріоритету
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildChip(Icons.work, 'Навчання', const Color(0xFFFFEBD8), const Color.fromARGB(255, 245, 35, 158)),
                const SizedBox(width: 12),
                _buildChip(Icons.priority_high, 'Високий пріоритет', const Color(0xFFFFE5E5), Colors.red),
              ],
            ),
            const SizedBox(height: 30),

            // 4. Блок опису [cite: 133, 139]
            _buildDetailCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.description, color: Colors.blue, size: 20),
                      SizedBox(width: 8),
                      Text('Опис', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'ну дуууууже важливий текст про роботу який я не хочу друкувати з фото методички)',
                    style: TextStyle(color: Colors.black87, height: 1.5),
                  ),
                ],
              ),
            ),

            // 5. Блок Дати та Дедлайну [cite: 134, 141, 142]
            _buildDetailCard(
              child: Column(
                children: [
                  _buildDateRow(Icons.edit_note, 'Створено', '10.03.2026 о 14:30', Colors.green),
                  const Divider(height: 24),
                  _buildDateRow(Icons.calendar_today, 'Дедлайн', '15.03.2026 о 18:00', Colors.red),
                ],
              ),
            ),

            // 6. Статус виконання [cite: 135]
            _buildDetailCard(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        _isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
                        color: Colors.blue,
                      ),
                      const SizedBox(width: 12),
                      const Text('Статус виконання', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                  Switch(
                    value: _isCompleted,
                    onChanged: (value) {
                      setState(() {
                        _isCompleted = value; // Зміна стану 
                      });
                    },
                    activeColor: Colors.blue,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // 7. Кнопки дій [cite: 135, 143]
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.edit, size: 18),
                    label: const Text('Редагувати'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      side: const BorderSide(color: Colors.blue),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.delete, color: Colors.white, size: 18),
                    label: const Text('Видалити', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE5533D), // Червоний колір
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Допоміжні методи для дизайну
  Widget _buildChip(IconData icon, String label, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: textColor),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(color: textColor, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildDetailCard({required Widget child}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildDateRow(IconData icon, String label, String value, Color iconColor) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
          ],
        ),
      ],
    );
  }
}