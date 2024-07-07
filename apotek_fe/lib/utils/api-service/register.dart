import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<String> registerUser(
    String email, String password, String confirmPassword) async {
  try {
    final api = dotenv.env['URL'] ?? '';
    var url = '$api/api/register/';
    print(' halsdof $api');

    final Map<String, String> payload = {
      'email': email,
      'password': password,
      'confirmPassword': confirmPassword,
    };

    final response = await http.post(
      (Uri.parse(url)),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(payload),
    );

    if (response.statusCode == 201) {
      return response.body;
    } else {
      return response.body;
    }
  } catch (e) {
    print('Error: $e');
    return 'An error occurred during registration.';
  }
}
