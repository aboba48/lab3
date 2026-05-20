// lib/models/task.dart
class Task {
  String id;
  String title;
  String description;
  bool isCompleted;
  String category;
  String priority;
  DateTime createdAt;
  DateTime dueDate;
  String? googleEventId;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.category,
    required this.priority,
    required this.createdAt,
    required this.dueDate,
    this.googleEventId,
  });

  // Парсинг JSON у об'єкт Dart (Вимога Практичної №5)
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'] ?? '',
      isCompleted: json['isCompleted'] == true,
      category: json['category'] ?? 'Робота',
      priority: json['priority'] ?? 'Середній',
      createdAt: DateTime.parse(json['createdAt']),
      dueDate: DateTime.parse(json['dueDate']),
      googleEventId: json['googleEventId'],
    );
  }

  // Конвертація об'єкта у JSON для SharedPreferences
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'category': category,
      'priority': priority,
      'createdAt': createdAt.toIso8601String(),
      'dueDate': dueDate.toIso8601String(),
      'googleEventId': googleEventId,
    };
  }
}