// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _fromKey = GlobalKey<FormState>();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  bool _isNotValidate = false;
  String _error = '';

  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    _initPrefs();
  }

  void _initPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  void loginUser() async {
    if (_passwordController.text.isNotEmpty &&
        _usernameController.text.isNotEmpty) {
      var reqBody = {
        "username": _usernameController.text,
        "password": _passwordController.text
      };
      var response = await http.post(
        Uri.parse('http://34.87.22.134:3000/login'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(reqBody),
      );
      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status']) {
        var token = jsonResponse['token'];
        var uid = jsonResponse['uid'];
        // Save token and uid to SharedPreferences

        prefs.setString('token', token);
        prefs.setString('uid', uid);
        Navigator.pushNamed(context, '/news');
      } else {
        setState(() {
          _error = jsonResponse['error'];
          _isNotValidate = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Color.fromARGB(255, 57, 52, 56),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(
                  height: orientation == Orientation.portrait ? 250.0 : 150.0,
                  child: Center(
                    child: Image.asset(
                      'assets/images/sr_logo.png',
                      height:
                          orientation == Orientation.portrait ? 400.0 : 200.0,
                      width:
                          orientation == Orientation.portrait ? 450.0 : 300.0,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Form(
                    key: _fromKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        SizedBox(height: 20.0),
                        Center(
                          child: Text(
                            'StarTrack',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: orientation == Orientation.portrait
                                  ? 40.0
                                  : 30.0,
                              color: Color.fromARGB(255, 229, 207, 163),
                            ),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        TextFormField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                            labelText: 'Username',
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your username';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20.0),
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: loginUser,
                          child: Text('Login'),
                        ),
                        SizedBox(height: 10.0),
                        if (_isNotValidate)
                          Text(
                            _error,
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 16.0,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/register');
                          },
                          child: Text('Don\'t have an account? Register here'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
