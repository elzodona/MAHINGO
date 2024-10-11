import 'dart:convert';
import 'package:http/http.dart' as http;

class Api2Service {
  // static const String baseUrl = 'http://192.168.1.63:8000/api';
  static const String baseUrl = 'http://10.0.2.2:8000/api';

  Future<List<dynamic>> fetchEvents(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/event/user/$id'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data'];
    } else {
      throw Exception('Failed to load events');
    }
  }

  Future<dynamic> createEvent(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/event/add'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      final errorData = jsonDecode(response.body);
      throw Exception('Failed to create event: ${errorData['error']}');
    }
  }

  Future<dynamic> updateEvent(int id, Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/event/update/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to update event: ${response.body}');
    }
  }

  Future<void> deleteEvent(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/event/delete/$id'));

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete event');
    }
  }
}
