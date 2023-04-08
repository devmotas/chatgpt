import 'package:ChatGpt/pages/home.dart';
import 'package:ChatGpt/pages/profile.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ThemeData myTheme = ThemeData(
    primaryColor: Colors.blue,
    iconTheme: const IconThemeData(color: Colors.blue),
    textTheme: const TextTheme(),
  );

  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool showProfile = false;

  void backHome() {
    setState(() {
      showProfile = false;
    });
  }

  void openProfile() {
    setState(() {
      showProfile = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(32, 34, 34, 1.0),
          leading: showProfile
              ? InkWell(
                  child: const Icon(Icons.arrow_back, color: Colors.white),
                  onTap: () => backHome(),
                )
              : Container(),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: !showProfile
                  ? InkWell(
                      child: const Icon(Icons.account_circle_rounded,
                          color: Colors.white),
                      onTap: () => openProfile(),
                    )
                  : Container(),
            ),
          ],
        ),
        // body: Profile(),
        body: !showProfile ? const Home() : Profile());
  }
}
