import 'package:ChatGpt/pages/createAccount.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  final void Function(bool) isLoggedApproved;

  Login({super.key, required this.isLoggedApproved});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();

  String _username = "";

  String _password = "";

  bool _createAccountScreen = false;

  void _login() {
    widget.isLoggedApproved(true);
  }

  void _openRegistrationUser() {
    setState(() {
      _createAccountScreen = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: !_createAccountScreen
            ? Container(
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(32, 34, 34, 1.0),
                ),
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
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
                            borderSide: BorderSide(
                                color: Color.fromRGBO(47, 50, 49, 1.0)),
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
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: "Senha",
                          labelStyle: TextStyle(color: Colors.white),
                          prefixIcon: Icon(Icons.lock, color: Colors.white),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromRGBO(47, 50, 49, 1.0)),
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
                            // if (_formKey.currentState!.validate()) {
                            //   _formKey.currentState!.save();
                            //   // TODO: perform login action
                            // }
                            _login();
                          },
                          child: const Text("Entrar"),
                        ),
                      ),
                      const SizedBox(height: 30),
                      GestureDetector(
                        onTap: () {
                          _openRegistrationUser();
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
              )
            : CreateAccount(
                backPage: () => setState(() {
                  _createAccountScreen = false;
                }),
              ));
  }
}
