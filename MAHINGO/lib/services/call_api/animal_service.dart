import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // static const String baseUrl = 'http://192.168.1.42:8000/api';
  static const String baseUrl = 'http://10.0.2.2:8000/api';

  Future<List<dynamic>> fetchAnimals(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/animal/user/$id'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data'];
    } else {
      throw Exception('Failed to load animals');
    }
  }

  Future<List<dynamic>> fetchAnimalsb(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/animal/userb/$id'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data'];
    } else {
      throw Exception('Failed to load animals');
    }
  }

  Future<List<dynamic>> fetchColliers() async {
    final response = await http.get(Uri.parse('$baseUrl/necklace/all'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data'];
    } else {
      throw Exception('Failed to load colliers');
    }
  }

  Future<dynamic> fetchAnimal(int id) async {
    final response = await http.post(Uri.parse('$baseUrl/animal/$id'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load animal');
    }
  }

  Future<dynamic> createAnimal(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/animal/add'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      final errorData = jsonDecode(response.body);
      throw Exception('Failed to create animal: ${errorData['error']}');
    }
  }

  Future<dynamic> updateAnimal(int id, Map<String, dynamic> data) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/animal/update/$id'),
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
    final response = await http.delete(Uri.parse('$baseUrl/animal/delete/$id'));

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete animal');
    }
  }



}
