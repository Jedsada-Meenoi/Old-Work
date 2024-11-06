// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:startrack/pages/calculatorPage.dart';
import 'package:startrack/pages/loginPage.dart';
import 'package:startrack/pages/newsEventPage.dart';
import 'package:startrack/pages/profilePage.dart';
import 'package:startrack/pages/registerPage.dart';
import 'package:startrack/pages/guides.dart';
import 'package:startrack/pages/itemsData.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
  SharedPreferences pref = await SharedPreferences.getInstance();
  runApp(StarTrackApp(
    token: pref.getString('token'),
  ));
}

class StarTrackApp extends StatelessWidget {
  final token;
  const StarTrackApp({required this.token, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StarTrack',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: (token != null && !JwtDecoder.isExpired(token) == false)
          ? '/news'
          : '/login',
      routes: {
        '/login': (context) => LoginPage(),
        '/news': (context) => NewsEvents(),
        '/register': (context) => RegisterForm(),
        '/guides': (context) => TipsAndTricksScreen(),
        '/database': (context) => ItemsData(),
        '/user': (context) => UserInfoPage(),
        '/calculator': (context) => CalculatorPage()
      },
    );
  }
}
