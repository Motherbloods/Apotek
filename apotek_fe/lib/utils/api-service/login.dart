import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveToken(String token) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('auth_token', token);
}

Future<String?> getToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('auth_token');
}

Future<void> removeToken() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('auth_token');
}

Future<Map<String, dynamic>> loginUser(String email, String password) async {
  try {
    final api = dotenv.env['URL'] ?? '';
    var url = '$api/api/login';

    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return {
        'success': true,
        'token': responseData['token'],
        'userId': responseData['id'],
      };
    } else {
      return {
        'success': false,
        'message': 'Login failed',
      };
    }
  } catch (e) {
    print('Error: $e');
    return {
      'success': false,
      'message': 'An error occurred. Please check your internet connection.',
    };
  }
}
