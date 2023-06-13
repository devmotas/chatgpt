import 'package:flutter/material.dart';

import '../components/buttonDefault.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  _login() {
    Navigator.pushNamed(context, '/login');
  }

  void _createAccount() {
    Navigator.pushNamed(context, '/createAccount');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Color.fromRGBO(32, 34, 34, 1.0),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Bem vindo',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            const Text(
              'Entre ou cadastre seu perfil para poder aproveitar todo o potencial do Chatgpt.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 50),
            ButtonDefault(
              text: 'ENTRAR',
              onPressed: _login,
              borderOutline: false,
              disabled: false,
            ),
            const SizedBox(height: 20),
            ButtonDefault(
              text: 'CRIAR CONTA',
              onPressed: _createAccount,
              borderOutline: true,
              disabled: false,
            ),
            const SizedBox(height: 20),
            const Text(
              'Precisa de ajuda?',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
