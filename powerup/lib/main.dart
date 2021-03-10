import 'package:flutter/material.dart';
import 'package:powerup/pages/HomePage.dart';
import 'package:powerup/pages/LoginPage.dart';
import 'package:provider/provider.dart';

void main() => runApp(MaterialApp(
  home: LoginPage(),
  routes: {
  	'/': (context) => LoginPage(),
  	'/home': (context) => HomePage(),
  	'/register': (context) => RegisterPage(),
  	'/course': (context) => CoursePage(),
  }
));

