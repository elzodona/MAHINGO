import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://votre-backend-laravel.com/api';

  Future<List<dynamic>> fetchAnimals() async {
    final response = await http.get(Uri.parse('$baseUrl/animals'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load animals');
    }
  }

  Future<dynamic> fetchAnimal(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/animals/$id'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load animal');
    }
  }

  Future<dynamic> createAnimal(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/animals'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to create animal');
    }
  }

  Future<dynamic> updateAnimal(int id, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('$baseUrl/animals/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to update animal');
    }
  }

  Future<void> deleteAnimal(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/animals/$id'));
    if (response.statusCode != 204) {
      throw Exception('Failed to delete animal');
    }
  }

}
