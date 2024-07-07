import 'package:apotek_fe/ui/authpage/register/body.dart';
import 'package:apotek_fe/ui/authpage/register/signup.dart';
import 'package:apotek_fe/ui/home/main_screens.dart';
import 'package:apotek_fe/ui/home/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:apotek_fe/ui/authpage/login/Screens/Login/login_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: 'assets/.env');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Apotek',
      theme: ThemeData(),
      home: MainScreen(),
    );
  }
}
