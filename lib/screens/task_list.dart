// lib/screens/task_list.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';
import '../main.dart';
import '../services/weather_service.dart';
import '../services/calendar_service.dart';
import 'add_task.dart';      
import 'task_detali.dart';   

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<Task> _tasks = [];
  bool _isLoading = true;

  // Погода (REST API - Практична №5)
  final WeatherService _weatherService = WeatherService();
  String _weatherInfo = 'Завантаження погоди...';
  double _lat = 50.4501; // За замовчуванням Київ
  double _lon = 30.5234;

  // Календар
  final CalendarService _calendarService = CalendarService();
  bool _isGoogleLinked = false;

  @override
  void initState() {
    super.initState();
    _loadAppSettings();
    _loadTasks();
  }

  // Завантаження налаштувань регіону для погоди
  Future<void> _loadAppSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _lat = prefs.getDouble('weather_lat') ?? 50.4501;
      _lon = prefs.getDouble('weather_lon') ?? 30.5234;
    });
    _getWeather();
  }

  // Запит до REST API Open-Meteo
  Future<void> _getWeather() async {
    setState(() {
      _weatherInfo = 'Оновлення...';
    });
    final data = await _weatherService.fetchWeather(_lat, _lon);
    if (mounted) {
      setState(() {
        _weatherInfo = '${data['temp']} (${data['description']})';
      });
    }
  }

  // Завантаження завдань з SharedPreferences
  Future<void> _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String? tasksString = prefs.getString('saved_tasks');
    
    if (tasksString != null) {
      try {
        final List<dynamic> decodedJson = jsonDecode(tasksString);
        setState(() {
          _tasks = decodedJson.map((item) => Task.fromJson(item)).toList();
          _isLoading = false;
        });
      } catch (e) {
        print("Помилка завантаження завдань: $e");
        setState(() => _isLoading = false);
      }
    } else {
      setState(() { _tasks = []; _isLoading = false; });
    }
  }

  // Збереження завдань у SharedPreferences
  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = jsonEncode(_tasks.map((task) => task.toJson()).toList());
    await prefs.setString('saved_tasks', encodedData);
  }

  void _deleteTask(Task task) async {
    if (task.googleEventId != null) {
      await _calendarService.deleteTaskFromCalendar(task.googleEventId!);
    }
    setState(() {
      _tasks.removeWhere((t) => t.id == task.id);
    });
    _saveTasks();
  }

  // ВИПРАВЛЕНО: Діалог налаштування локації погоди тепер працює правильно
  void _showWeatherSettings() {
    final latController = TextEditingController(text: _lat.toString());
    final lonController = TextEditingController(text: _lon.toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Налаштування погоди'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: latController, 
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Широта (Latitude)')
            ),
            TextField(
              controller: lonController, 
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Довгота (Longitude)')
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Скасувати'),
          ),
          TextButton(
            onPressed: () async {
              final double? newLat = double.tryParse(latController.text);
              final double? newLon = double.tryParse(lonController.text);
              if (newLat != null && newLon != null) {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setDouble('weather_lat', newLat);
                await prefs.setDouble('weather_lon', newLon);
                setState(() {
                  _lat = newLat;
                  _lon = newLon;
                });
                Navigator.pop(context);
                _getWeather(); // Оновлюємо дані з REST API
              }
            },
            child: const Text('Зберегти'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: _showWeatherSettings,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Мої завдання', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text('Погода: $_weatherInfo ⚙️', style: const TextStyle(fontSize: 13, color: Colors.grey)),
            ],
          ),
        ),
        actions: [
          // Повернено та підключено перемикач теми до ValueNotifier + SharedPreferences
          ValueListenableBuilder<ThemeMode>(
            valueListenable: themeNotifier,
            builder: (context, currentMode, _) {
              final isDark = currentMode == ThemeMode.dark;
              return IconButton(
                icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
                onPressed: () async {
                  final newMode = isDark ? ThemeMode.light : ThemeMode.dark;
                  themeNotifier.value = newMode;
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setBool('isDarkMode', newMode == ThemeMode.dark);
                },
              );
            },
          ),
          // Кнопка підключення Google Календаря
          IconButton(
            icon: Icon(Icons.calendar_month, color: _isGoogleLinked ? Colors.green : null),
            onPressed: () async {
              bool success = await _calendarService.signIn();
              if (!mounted) return;
              setState(() { _isGoogleLinked = success; });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(success ? 'Google Календар підключено!' : 'Помилка підключення')),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _tasks.isEmpty
              ? const Center(child: Text('Список завдань порожній'))
              : ListView.builder(
                  itemCount: _tasks.length,
                  itemBuilder: (context, index) {
                    final task = _tasks[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: ListTile(
                        leading: Checkbox(
                          value: task.isCompleted,
                          onChanged: (bool? value) {
                            setState(() {
                              task.isCompleted = value ?? false;
                            });
                            _saveTasks();
                          },
                        ),
                        title: Text(
                          task.title,
                          style: TextStyle(
                            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                          ),
                        ),
                        subtitle: Text('Дедлайн: ${task.dueDate.toLocal().toString().substring(0,16)} | ${task.category}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteTask(task),
                        ),
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => TaskDetailScreen(task: task)),
                          );
                          if (result == 'delete') {
                            _deleteTask(task);
                          } else if (result is Task) {
                            setState(() { _tasks[index] = result; });
                            _saveTasks();
                          }
                        },
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newTask = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTaskScreen()),
          );
          if (newTask != null && newTask is Task) {
            if (_isGoogleLinked) {
              final eventId = await _calendarService.addTaskToCalendar(newTask);
              newTask.googleEventId = eventId;
            }
            setState(() { _tasks.add(newTask); });
            _saveTasks();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}