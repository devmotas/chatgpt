import 'package:ChatGpt/pages/create_account.dart';
import 'package:ChatGpt/pages/home.dart';
import 'package:ChatGpt/pages/login.dart';
import 'package:ChatGpt/pages/profile.dart';
import 'package:ChatGpt/pages/user_information.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

void main() async {
  await dotenv.load();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final oneSignalAppId = dotenv.env['API_KEY'];

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  final ThemeData myTheme = ThemeData(
    primaryColor: Colors.blue,
    iconTheme: const IconThemeData(color: Colors.blue),
    textTheme: const TextTheme(),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/login',
      routes: {
        '/login': (context) => const Login(),
        '/home': (context) => Home(),
        '/profile': (context) => Profile(),
        '/createAccount': (context) => CreateAccount(),
        '/userInformation': (context) => const UserInformation(),
      },
    );
  }

  Future<void> initPlatformState() async {
    await OneSignal.shared.setAppId("oneSignalAppId!");
    await OneSignal.shared.consentGranted(true); // Set privacy consent to true
    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      // Handle notification opened
    });
  }
}
