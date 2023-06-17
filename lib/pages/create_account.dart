import 'dart:convert';

import 'package:ChatGpt/components/buttonDefault.dart';
import 'package:ChatGpt/components/inputDefault.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  bool _valid = false;

  final GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey3 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey4 = GlobalKey<FormState>();

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

  validateInputs() {
    _formKey1.currentState?.save();
    _formKey2.currentState?.save();
    _formKey3.currentState?.save();
    _formKey4.currentState?.save();

    bool form1Valid = _formKey1.currentState?.validate() ?? false;
    bool form2Valid = _formKey2.currentState?.validate() ?? false;
    bool form3Valid = _formKey3.currentState?.validate() ?? false;
    bool form4Valid = _formKey4.currentState?.validate() ?? false;

    _valid = form1Valid && form2Valid && form3Valid && form4Valid;
  }

  String? validatePassword() {
    if (_checkPasswordEqual()) {
      return "As senhas não coincidem, tente novamente!";
    } else if (_checkPassword()) {
      return "Senha deve ter no mínimo 6 dígitos.";
    } else if (_confirmPassword.isEmpty) {
      return "Por favor, confirme a senha.";
    } else {
      return null;
    }
  }

  _checkPasswordEqual() {
    _formKey1.currentState?.save();
    _formKey2.currentState?.save();
    _formKey3.currentState?.save();
    _formKey4.currentState?.save();
    return !(_password == _confirmPassword);
  }

  _checkPassword() {
    _formKey1.currentState?.save();
    _formKey2.currentState?.save();
    _formKey3.currentState?.save();
    _formKey4.currentState?.save();
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
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
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
                          InputDefault(
                            formKey: _formKey1,
                            label: "Nome",
                            error: "Por favor insira seu nome",
                            iconInput:
                                const Icon(Icons.person, color: Colors.white),
                            onChanged: (value) {
                              _username = value;
                            },
                          ),
                          const SizedBox(height: 16),
                          InputDefault(
                            formKey: _formKey2,
                            label: "E-mail",
                            error: "Por favor insira seu e-mail",
                            iconInput:
                                const Icon(Icons.email, color: Colors.white),
                            keyboard: TextInputType.emailAddress,
                            onChanged: (value) {
                              _email = value;
                            },
                          ),
                          const SizedBox(height: 16),
                          InputDefault(
                            formKey: _formKey3,
                            label: "Senha",
                            error: "Por favor insira sua senha",
                            iconInput:
                                const Icon(Icons.lock, color: Colors.white),
                            keyboard: TextInputType.number,
                            onChanged: (value) {
                              _password = value;
                            },
                          ),
                          const SizedBox(height: 16),
                          InputDefault(
                            formKey: _formKey4,
                            label: "Confirmar Senha",
                            error: '',
                            iconInput:
                                const Icon(Icons.lock, color: Colors.white),
                            keyboard: TextInputType.number,
                            onChanged: (value) {
                              _confirmPassword = value;
                            },
                            validatorNonDefault: validatePassword(),
                          ),
                          const SizedBox(height: 32),
                          ButtonDefault(
                              text: "Cadastrar",
                              onPressed: () {
                                validateInputs();
                                if (_valid && !_userWaiting) {
                                  SystemChannels.textInput
                                      .invokeMethod('TextInput.hide');
                                  _createUser(context);
                                }
                              },
                              borderOutline: false,
                              disabled: false),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
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
