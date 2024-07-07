import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:apotek_fe/ui/authpage/register/screen/body.dart';

class SignUp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        extendBodyBehindAppBar: true,
        extendBody: true,
        body: SafeArea(
          child: Body(),
        ),
      ),
    );
  }
}
