import 'dart:convert';
import 'package:http/http.dart' as http;

class Api5Service {
  // static const String baseUrl = 'http://192.168.1.42:8000/api';
  static const String baseUrl = 'http://10.0.2.2:8000/api';

  Future<List<dynamic>> fetchNotifs(int id) async {
    final response =
        await http.get(Uri.parse('$baseUrl/notifHealth/user/$id'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data'];
    } else {
      throw Exception('Failed to load notifs');
    }
  }

  Future<dynamic> createNotif(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/notifHealth/add'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      final errorData = jsonDecode(response.body);
      throw Exception('Failed to create notif: ${errorData['error']}');
    }
  }

  Future<dynamic> updateNotif(int id) async {
    final response = await http.post(
      Uri.parse('$baseUrl/notifHealth/update/$id'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to update notif: ${response.body}');
    }
  }

  Future<dynamic> deleteNotif(int id) async {
    final response =
        await http.delete(Uri.parse('$baseUrl/notifHealth/delete/$id'));

    if (response.statusCode != 200 && response.statusCode != 204) {
      final responseBody = json.decode(response.body);
      String errorMessage = 'Échec de la suppression de la notification';

      if (response.statusCode == 404) {
        errorMessage = 'Notification non trouvée';
      } else if (response.statusCode == 500) {
        errorMessage = responseBody['error'] ?? 'Erreur interne du serveur';
      }

      throw Exception(errorMessage);
    }

    return response.body;
  }
}
