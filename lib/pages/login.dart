// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final storage = FlutterSecureStorage();
  final _formLogin = GlobalKey<FormState>();
  String _username = "";
  String _password = "";
  bool _userWaiting = false;

  void _login() async {
    setState(() {
      _userWaiting = true;
    });
    final apiUrl = dotenv.env['API_URL'];

    final response = await http.post(
      Uri.parse('$apiUrl/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': _username,
        'password': _password,
      }),
    );
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final user = jsonResponse['user'];
      print(user);

      if (user['authorization'] == 1) {
        await storage.write(key: 'user', value: jsonEncode(user));
        setState(() {
          _userWaiting = false;
        });
        Navigator.pushNamed(context, '/home');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Logado com sucesso.'),
            duration: Duration(seconds: 3),
          ),
        );
        await Future.delayed(const Duration(seconds: 3));
      } else {
        setState(() {
          _username = '';
          _password = '';
          _userWaiting = false;
        });
        _formLogin.currentState?.reset();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Você esta cadastrado mas não tem autorização para entrar.'),
            duration: Duration(seconds: 3),
          ),
        );
        await Future.delayed(const Duration(seconds: 3));
      }
    } else {
      setState(() {
        _userWaiting = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Usuário inválido.'),
          duration: Duration(seconds: 2),
        ),
      );
      await Future.delayed(const Duration(seconds: 2));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: const BoxDecoration(
        color: Color.fromRGBO(32, 34, 34, 1.0),
      ),
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formLogin,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.code,
              size: 100,
              color: Colors.white,
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: "E-mail",
                labelStyle: TextStyle(color: Colors.white),
                prefixIcon: Icon(Icons.person, color: Colors.white),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Color.fromRGBO(47, 50, 49, 1.0)),
                ),
              ),
              style: const TextStyle(color: Colors.white),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Por favor insira seu usuário";
                }
                return null;
              },
              onSaved: (value) {
                _username = value!;
              },
              onEditingComplete: () {
                FocusScope.of(context).nextFocus();
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Senha",
                labelStyle: TextStyle(color: Colors.white),
                prefixIcon: Icon(Icons.lock, color: Colors.white),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Color.fromRGBO(47, 50, 49, 1.0)),
                ),
              ),
              style: const TextStyle(color: Colors.white),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Por favor insira sua senha";
                }
                return null;
              },
              onSaved: (value) {
                _password = value!;
              },
              onEditingComplete: () {
                if (_formLogin.currentState!.validate() && !_userWaiting) {
                  _formLogin.currentState?.save();
                  _login();
                }
              },
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromRGBO(47, 50, 49, 1.0),
                  ),
                ),
                onPressed: () {
                  // Navigator.pushNamed(context, '/home');

                  if (_formLogin.currentState!.validate() && !_userWaiting) {
                    _formLogin.currentState?.save();
                    _login();
                  }
                },
                child: const Text("Entrar"),
              ),
            ),
            const SizedBox(height: 30),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/createAccount');
              },
              child: const Text(
                "Don't have an account? Sign up",
                style: TextStyle(
                  color: Colors.white,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
