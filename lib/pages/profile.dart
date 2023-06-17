import 'dart:convert';

import 'package:ChatGpt/components/cardProfile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Profile extends StatefulWidget {
  final storage = const FlutterSecureStorage();

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Map<String, dynamic> storedUser = {};
  String name = '';
  final _textController = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    widget.storage.read(key: 'user').then((value) {
      setState(() {
        storedUser = jsonDecode(value!);
        name = storedUser['name'];
      });
    });
  }

  void _exitApp(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Deseja mesmo sair?',
            style: TextStyle(
              color: Color.fromRGBO(32, 34, 34, 1.0),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Sim',
                style: TextStyle(
                  color: Color.fromRGBO(204, 204, 204, 1.0),
                ),
              ),
              onPressed: () {
                _focusNode.unfocus();
                Navigator.of(context).pop();
                Navigator.pushNamedAndRemoveUntil(
                    context, '/login', (route) => false);
              },
            ),
            TextButton(
              child: const Text(
                'Não',
                style: TextStyle(
                  color: Color.fromRGBO(32, 34, 34, 1.0),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: const Color.fromRGBO(32, 34, 34, 1.0),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Color.fromRGBO(32, 34, 34, 1.0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      SizedBox(
                        width: 200,
                        child: Image.asset(
                          'assets/images/user.png',
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 30),
                        child: Text(
                          'Olá $name',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Expanded(
                child: Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        Column(children: [
                          const SizedBox(height: 16.0),
                          CardProfile(
                              text: 'Informações usuário',
                              router: '/userInformation',
                              icon: const Icon(Icons.person,
                                  color: Colors.black)),
                          const SizedBox(height: 16.0),
                          CardProfile(
                              text: 'Termo de privacidade',
                              router: '/privacyTerm',
                              icon: const Icon(Icons.security,
                                  color: Colors.black)),
                          const SizedBox(height: 16.0),
                          CardProfile(
                              text: 'Mudar Tema',
                              router: '/changeTheme',
                              icon: const Icon(Icons.color_lens,
                                  color: Colors.black)),
                          const SizedBox(height: 30.0),
                          Center(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.6,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () {
                                  _exitApp(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'SAIR',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Icon(Icons.exit_to_app,
                                        color: Colors.white),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ])
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
