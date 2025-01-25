// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../components/buttonDefault.dart';
import '../components/inputDefault.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final storage = const FlutterSecureStorage();
  final GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _username = "";
  String _password = "";
  bool _userWaiting = false;
  bool _saveData = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      _username = '';
      _password = '';
      _saveData = false;
      _usernameController.text = _username;
      _passwordController.text = _password;
    });
    storage.read(key: 'dataUser').then((value) {
      if (value != null) {
        Map<String, dynamic> userCredentials = jsonDecode(value);
        setState(() {
          _username = userCredentials['email'];
          _password = userCredentials['password'];
          _saveData = true;
          _usernameController.text = _username;
          _passwordController.text = _password;
        });
        // _login();
      } else {
        _saveData = false;
      }
    });
  }

  void _login() async {
    _formKey1.currentState?.save();
    _formKey2.currentState?.save();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    bool form1Valid = _formKey1.currentState!.validate();
    bool form2Valid = _formKey2.currentState!.validate();

    if (form1Valid && form2Valid) {
      setState(() {
        _userWaiting = true;
      });

      try {
        // Login com Firebase
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _username.trim(),
          password: _password.trim(),
        );

        // Obter usuário logado
        User? user = userCredential.user;

        if (user != null) {
          // Salvar informações no local storage
          await storage.write(key: 'user', value: user.uid);
          await storage.write(key: 'email', value: user.email);
          await storage.write(key: 'isLoggedBefore', value: 'true');

          if (_saveData) {
            await storage.write(
              key: 'dataUser',
              value: jsonEncode({'email': _username, 'password': _password}),
            );
          } else {
            await storage.delete(key: 'dataUser');
          }

          setState(() {
            _userWaiting = false;
            _username = '';
            _password = '';
            _saveData = false;
          });

          Navigator.pushNamed(context, '/home');
        } else {
          throw FirebaseAuthException(
              code: 'user-not-found', message: 'Usuário não encontrado.');
        }
      } on FirebaseAuthException catch (e) {
        setState(() {
          _userWaiting = false;
        });

        String errorMessage;
        switch (e.code) {
          case 'user-not-found':
            errorMessage = 'Usuário não encontrado.';
            break;
          case 'wrong-password':
            errorMessage = 'Senha incorreta.';
            break;
          case 'invalid-email':
            errorMessage = 'Email inválido.';
            break;
          default:
            errorMessage = 'Erro ao fazer login: ${e.message}';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            duration: const Duration(seconds: 2),
          ),
        );
      } catch (e) {
        setState(() {
          _userWaiting = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro inesperado: ${e.toString()}'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: !_userWaiting,
        backgroundColor: const Color.fromRGBO(32, 34, 34, 1.0),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      resizeToAvoidBottomInset: true, // Garante ajuste ao teclado
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 20, right: 20),
            decoration: const BoxDecoration(
              color: Color.fromRGBO(32, 34, 34, 1.0),
            ),
            child: LayoutBuilder(
              // Calcula o espaço disponível
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    // Garante que o conteúdo ocupe toda a altura
                    constraints: BoxConstraints(
                      minHeight: constraints
                          .maxHeight, // Altura mínima = altura da tela
                    ),
                    child: IntrinsicHeight(
                      // Expande os widgets filhos
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InputDefault(
                            formKey: _formKey1,
                            label: 'E-mail',
                            error: "Por favor insira seu email",
                            iconInput:
                                const Icon(Icons.person, color: Colors.white),
                            onChanged: (value) {
                              _username = value;
                            },
                            keyboard: TextInputType.emailAddress,
                            controller: _usernameController,
                          ),
                          const SizedBox(height: 30),
                          InputDefault(
                            formKey: _formKey2,
                            label: 'Senha',
                            error: "Por favor insira sua senha",
                            iconInput:
                                const Icon(Icons.lock, color: Colors.white),
                            onChanged: (value) {
                              _password = value;
                            },
                            keyboard: TextInputType.number,
                            controller: _passwordController,
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Switch(
                                value: _saveData,
                                activeColor: Colors.grey,
                                onChanged: (bool value) {
                                  setState(() {
                                    _saveData = value;
                                  });
                                },
                              ),
                              const Text(
                                'Lembrar de mim',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 42),
                          ButtonDefault(
                            text: 'ENTRAR',
                            onPressed: () {
                              if (_formKey1.currentState!.validate() &&
                                  _formKey2.currentState!.validate() &&
                                  !_userWaiting) {
                                _login();
                              }
                            },
                            borderOutline: false,
                            disabled: false,
                          ),
                          const SizedBox(height: 30),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/createAccount');
                            },
                            child: const Text(
                              "Não tem uma conta ?",
                              style: TextStyle(
                                color: Colors.white,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (_userWaiting)
            Positioned.fill(
              child: Container(
                color: Colors.black54,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
