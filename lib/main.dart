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
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await dotenv.load();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final OneSignal _oneSignal = OneSignal();

  @override
  void initState() {
    super.initState();
  }

  final ThemeData myTheme = ThemeData(
    primaryColor: Colors.blue,
    iconTheme: const IconThemeData(color: Colors.blue),
    textTheme: const TextTheme(),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/welcome',
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
    OneSignal.initialize("your-app-id");
    bool hasPermission = await OneSignal.Notifications.requestPermission(false);
    if (!hasPermission) {
      debugPrint("Permissão para notificações não concedida.");
    }
    await OneSignal.Notifications.lifecycleInit();
  }
}
