import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class AuthService {
  // static const String baseUrl = 'http://192.168.1.42:8000/api';
  static const String baseUrl = 'http://10.0.2.2:8000/api';

  Future<bool> login(String telephone, String password) async {
    final url = Uri.parse('$baseUrl/login');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'telephone': telephone,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', data['token']);
        await prefs.setString('user', json.encode(data['user']));

        return true;
      } else {
        print('Erreur lors de la connexion : ${response.body}');
        return false;
      }
    } catch (e) {
      print('Exception lors de la connexion : $e');
      return false;
    }
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('user');
  }

  Future<Map<String, dynamic>?> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('user')) {
      String userString = prefs.getString('user')!;
      return json.decode(userString);
    }
    return null;
  }

  Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('token');
  }

}
