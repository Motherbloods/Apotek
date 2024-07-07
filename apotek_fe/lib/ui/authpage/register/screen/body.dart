import 'dart:async';
import 'dart:convert';
import 'package:apotek_fe/ui/home/main_screens.dart';
import 'package:apotek_fe/utils/api-service/login.dart';
import 'package:apotek_fe/utils/api-service/register.dart';
import 'package:apotek_fe/ui/authpage/register/widget/background.dart';
import 'package:apotek_fe/ui/authpage/register/widget/rounded_pass_field.dart';
import 'package:apotek_fe/ui/authpage/register/widget/rounded_text_field.dart';
import 'package:apotek_fe/ui/home/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? email;
  String? password;
  String? confirmPassword;
  bool _isLoading = false;
  String _message = '';
  Map<String, String> _errors = {};
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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

      Timer(const Duration(seconds: 1), () {
        setState(() {
          _message = '';
        });
      });

      return;
    }
    try {
      String result = await registerUser(email!, password!, confirmPassword!);
      final response = jsonDecode(result);
      if (response['status'] == 201) {
        setState(() {
          _message = response['detail'];
          email = '';
          password = '';
        });
        // Show success message for 3 seconds
        Timer(const Duration(seconds: 1), () {
          setState(() {
            _message = '';
          });
          // if (response['status'] == 201) {
          //   Navigator.push(
          //     context,
          //     MaterialPageRoute(builder: (context) => const LoginScreen()),
          //   );
          // }
        });
      } else {
        setState(() {
          _message = '${response['message']}';
        });
        Timer(Duration(seconds: 1), () {
          setState(() {
            _message = '';
          });
        });
      }
    } catch (e) {
      setState(() {
        _message = 'An error occurred: $e';
      });
      Timer(Duration(seconds: 1), () {
        setState(() {
          _message = '';
        });
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loginUser() async {
    setState(() {
      _isLoading = true;
      _message = '';
    });

    try {
      final result = await loginUser(email!, password!);

      if (result['success']) {
        final userId = result['userId'];

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('userId', userId);

        _message = 'Login successful';

        Timer(Duration(milliseconds: 15), () {
          setState(() {
            _message = '';
          });
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => MainScreen()),
          );
        });
      } else {
        setState(() {
          _message = 'Email atau Password Salah';
        });

        Timer(Duration(seconds: 1), () {
          setState(() {
            _message = '';
          });
        });
      }
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
      child: Container(
        color: Colors.white,
        child: Material(
          color: Colors.transparent,
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      "assets/images/logo.png",
                      height: size.height * 0.35,
                    ),
                    Container(
                      constraints: BoxConstraints(maxWidth: 300),
                      child: TabBar(
                        controller: _tabController,
                        tabs: [
                          Tab(text: 'Sign Up'),
                          Tab(text: 'Login'),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 300, // Adjust this height as needed
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          // Sign Up Form
                          _buildSignUpForm(),
                          // Login Form
                          _buildLoginForm(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (_isLoading || _message.isNotEmpty)
                Positioned.fill(
                  child: Container(
                    color: Colors.black54,
                    child: Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (_isLoading)
                          CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        if (_message.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              _message,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                          ),
                      ],
                    )),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpForm() {
    return Column(
      children: [
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
          onPressed: _registerUser,
          child: Text(
            "SIGN UP",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginForm() {
    return Column(
      children: [
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
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF00BF62)),
          onPressed: _loginUser,
          child: Text(
            "LOGIN",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
