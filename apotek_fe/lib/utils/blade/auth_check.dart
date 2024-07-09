import 'package:flutter/material.dart';
import 'package:apotek_fe/ui/home/main_screens.dart';
import 'package:apotek_fe/ui/authpage/register/screen/body.dart';
import 'package:apotek_fe/utils/api-service/login.dart';

class AuthCheck extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: getToken(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data != null) {
            // Token ada, arahkan ke MainScreen
            return MainScreen();
          } else {
            // Token tidak ada, arahkan ke halaman login
            return Body();
          }
        }
        // Menunggu pengecekan token
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
