import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  // Координати за замовчуванням (Київ: 50.4501, 30.5234)
  Future<Map<String, dynamic>> fetchWeather(double lat, double lon) async {
    final url = Uri.parse(
        'https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&current_weather=true');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final temp = data['current_weather']['temperature'];
        final code = data['current_weather']['weathercode'];
        return {
          'temp': '$temp°C',
          'description': _getWeatherDescription(code),
        };
      }
    } catch (e) {
      print('Помилка завантаження погоди: $e');
    }
    return {'temp': '--°C', 'description': 'Немає даних'};
  }

  String _getWeatherDescription(int code) {
    if (code == 0) return 'Ясно';
    if (code >= 1 && code <= 3) return 'Мінлива хмарність';
    if (code >= 51 && code <= 67) return 'Дощ';
    if (code >= 71 && code <= 77) return 'Сніг';
    if (code >= 95) return 'Гроза';
    return 'Хмарно';
  }
}