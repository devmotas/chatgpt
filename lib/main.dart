import 'package:new_chatgpt/pages/change_photo.dart';
import 'package:new_chatgpt/pages/change_theme.dart';
import 'package:new_chatgpt/pages/create_account.dart';
import 'package:new_chatgpt/pages/home.dart';
import 'package:new_chatgpt/pages/login.dart';
import 'package:new_chatgpt/pages/privacy_term.dart';
import 'package:new_chatgpt/pages/profile.dart';
import 'package:new_chatgpt/pages/user_information.dart';
import 'package:new_chatgpt/pages/welcome.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:new_chatgpt/pages/welcome.dart';
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
  // final oneSignalAppId = dotenv.env['API_KEY'];

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
      initialRoute: '/home',
      routes: {
        '/welcome': (context) => const Welcome(),
        '/login': (context) => const Login(),
        '/home': (context) => Home(),
        '/profile': (context) => Profile(),
        '/createAccount': (context) => CreateAccount(),
        '/userInformation': (context) => const UserInformation(),
        '/privacyTerm': (context) => const PrivacyTerm(),
        '/changeTheme': (context) => const ChangeTheme(),
        '/changePhoto': (context) => const ChangePhoto(),
      },
    );
  }

  Future<void> initPlatformState() async {
    //   await OneSignal.shared.setAppId("oneSignalAppId!");
    //   await OneSignal.shared.consentGranted(true); // Set privacy consent to true
    //   OneSignal.shared
    //       .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
    //     // Handle notification opened
    //   });
  }
}
