import 'dart:async';
import 'dart:convert';
import 'package:apotek_fe/utils/api-service/register.dart';

import 'package:apotek_fe/ui/authpage/register/widget/background.dart';
import 'package:apotek_fe/ui/authpage/register/widget/rounded_pass_field.dart';
import 'package:apotek_fe/ui/authpage/register/widget/rounded_text_field.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  String? email;
  String? password;
  String? confirmPassword;
  bool _isLoading = false;
  bool _isComplete = false;
  String _message = '';

  Future<void> _registerUser() async {
    setState(() {
      _isLoading = true;
      _message = '';
    });
    if (email == null || password == null || confirmPassword == null) {
      setState(() {
        _message = 'Please fill all fields';
        _isLoading = false;
      });
      return;
    }
    try {
      String result = await registerUser(email!, password!, confirmPassword!);
      final response = jsonDecode(result);
      print(response['status']);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('userId', response['id']);

      setState(() {
        _message = response['detail'];
        _isComplete = true;
      });
      // Show success message for 3 seconds
      Timer(Duration(seconds: 1), () {
        setState(() {
          _message = '';
          _isComplete = false;
        });
        // if (response['status'] == 201) {
        //   Navigator.push(
        //     context,
        //     MaterialPageRoute(builder: (context) => LoginScreen()),
        //   );
        // }
      });
    } catch (e) {
      setState(() {
        _message = 'An error occurred: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "SIGNUP",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Image.asset(
            "assets/images/logo.png",
            height: size.height * 0.35,
          ),
          RoundedInputField(
            hintText: "Email",
            onChanged: (value) {
              email = value;
            },
          ),
          RoundedPasswordField(
            onChanged: (value) {
              password = value;
            },
            conf: false,
          ),
          RoundedPasswordField(
            onChanged: (value) {
              confirmPassword = value;
            },
            conf: true,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF00BF62)),
            onPressed: () {
              _registerUser();
            },
            child: Text(
              "SIGN UP",
              style: TextStyle(color: Colors.white),
            ),
          ),
          if (_isLoading) CircularProgressIndicator(),
          if (_message.isNotEmpty) Text(_message),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Sudah Punya akun? ",
                style: TextStyle(color: Colors.black),
              ),
              // GestureDetector(
              //   onTap: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(builder: (context) => LoginScreen()),
              //     );
              //   },
              //   child: Text(
              //     "Login",
              //     style: TextStyle(
              //       color: Color(0xFF00BF62),
              //       fontWeight: FontWeight.bold,
              //     ),
              //   ),
              // ),
            ],
          ),
        ],
      ),
    );
  }
}
