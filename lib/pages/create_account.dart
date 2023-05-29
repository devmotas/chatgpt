import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class CreateAccount extends StatelessWidget {
  final _formUser = GlobalKey<FormState>();
  String _username = "";
  String _email = "";
  String _password = "";
  String _confirmPassword = "";
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _userWaiting = false;

  CreateAccount({super.key});

  void _createUser(context) async {
    _userWaiting = true;
    _formUser.currentState?.save();
    final apiUrl = dotenv.env['API_URL'];

    final response = await http.post(
      Uri.parse('${apiUrl!}/create-user'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'name': _username,
        'email': _email,
        'password': _password,
      }),
    );
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Usuário criado com sucesso'),
          duration: Duration(seconds: 3),
        ),
      );
      await Future.delayed(const Duration(seconds: 3));
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    } else {
      _userWaiting = false;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao criar usuário, tente novamente mais tarde.'),
          duration: Duration(seconds: 2),
        ),
      );
      await Future.delayed(const Duration(seconds: 2));
    }
  }

  _checkPasswordEqual() {
    _formUser.currentState?.save();
    return !(_password == _confirmPassword);
  }

  _checkPassword() {
    _formUser.currentState?.save();
    return !(_password == _confirmPassword && _password.length >= 6);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: const Color.fromRGBO(32, 34, 34, 1.0),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Container(
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(32, 34, 34, 1.0),
                ),
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formUser,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: [
                      const Icon(
                        Icons.person,
                        size: 100,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: "Nome",
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
                            return "Por favor insira seu nome";
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
                        decoration: const InputDecoration(
                          labelText: "E-mail",
                          labelStyle: TextStyle(color: Colors.white),
                          prefixIcon: Icon(Icons.email, color: Colors.white),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromRGBO(47, 50, 49, 1.0)),
                          ),
                        ),
                        style: const TextStyle(color: Colors.white),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Por favor insira seu e-mail";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _email = value!;
                        },
                        onEditingComplete: () {
                          FocusScope.of(context).nextFocus();
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        obscureText: true,
                        keyboardType: TextInputType.number,
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
                        onEditingComplete: () {
                          FocusScope.of(context).nextFocus();
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: "Confirmar Senha",
                          labelStyle: TextStyle(color: Colors.white),
                          prefixIcon: Icon(Icons.lock, color: Colors.white),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromRGBO(47, 50, 49, 1.0)),
                          ),
                        ),
                        style: const TextStyle(color: Colors.white),
                        validator: (value) {
                          if (_checkPasswordEqual()) {
                            return "As senhas não coincidem, tente novamente!";
                          } else if (_checkPassword()) {
                            return "Senha tem que ter no mínimo 6 dígitos.";
                          } else if (value == null || value.isEmpty) {
                            return "Por favor confirme a senha";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _confirmPassword = value!;
                        },
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                              Color.fromRGBO(47, 50, 49, 1.0),
                            ),
                          ),
                          onPressed: () {
                            _formUser.currentState?.save();
                            if (_formUser.currentState?.validate() == true &&
                                !_userWaiting) {
                              _createUser(context);
                            }
                          },
                          child: const Text("Cadastrar"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
