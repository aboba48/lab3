import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import '../models/task.dart';

class CalendarService {
  // === ЗАМІНІТЬ ЦЕЙ БЛОК ===
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: '271505070177-vqtilq731stg785156n7amp2f2ccmunq.apps.googleusercontent.com', // Вставте сюди скопійований ID
    scopes: [CalendarApi.calendarEventsScope],
  );

  GoogleSignInAccount? _currentUser;

  Future<bool> signIn() async {
    try {
      _currentUser = await _googleSignIn.signIn();
      return _currentUser != null;
    } catch (e) {
      print('Помилка авторизації Google: $e');
      return false;
    }
  }

  Future<CalendarApi?> _getCalendarApi() async {
    if (_currentUser == null) {
      _currentUser = await _googleSignIn.signInSilently();
    }
    if (_currentUser == null) return null;

    // Використання містка між google_sign_in та googleapis
    final httpClient = await _googleSignIn.authenticatedClient();
    return httpClient != null ? CalendarApi(httpClient) : null;
  }

  // Додавання завдання до Гугл Календаря
  Future<String?> addTaskToCalendar(Task task) async {
    final api = await _getCalendarApi();
    if (api == null) return null;

    final event = Event()
      ..summary = '[Todo] ${task.title}'
      ..description = 'Категорія: ${task.category}\nПріоритет: ${task.priority}\n\n${task.description}'
      ..start = (EventDateTime()..dateTime = task.dueDate.toUtc())
      ..end = (EventDateTime()..dateTime = task.dueDate.add(const Duration(hours: 1)).toUtc()); // Тривалість 1 година

    try {
      final createdEvent = await api.events.insert(event, 'primary');
      return createdEvent.id; // Повертаємо ID події для збереження в додатку
    } catch (e) {
      print('Помилка додавання події в календар: $e');
      return null;
    }
  }

  // Видалення події з Гугл Календаря
  Future<void> deleteTaskFromCalendar(String eventId) async {
    final api = await _getCalendarApi();
    if (api == null) return;

    try {
      await api.events.delete('primary', eventId);
    } catch (e) {
      print('Помилка видалення події з календаря: $e');
    }
  }
}