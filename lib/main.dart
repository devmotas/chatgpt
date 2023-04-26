import 'package:ChatGpt/pages/create_account.dart';
import 'package:ChatGpt/pages/home.dart';
import 'package:ChatGpt/pages/login.dart';
import 'package:ChatGpt/pages/profile.dart';
import 'package:flutter/material.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ThemeData myTheme = ThemeData(
    primaryColor: Colors.blue,
    iconTheme: const IconThemeData(color: Colors.blue),
    textTheme: const TextTheme(),
  );

  MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/login',
      routes: {
        '/login': (context) => Login(),
        '/home': (context) => Home(),
        '/profile': (context) => Profile(),
        '/createAccount': (context) => CreateAccount(),
      },
    );
  }
}
