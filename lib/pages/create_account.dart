import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:new_chatgpt/components/buttonDefault.dart';
import 'package:new_chatgpt/components/inputDefault.dart';
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

  void _createUser(BuildContext context) async {
    _userWaiting = true;
    _formUser.currentState?.save();

    try {
      // Criação de usuário com Firebase
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _email.trim(),
        password: _password.trim(),
      );

      // Obter o usuário criado
      User? user = userCredential.user;

      if (user != null) {
        // Atualizar o nome do usuário
        await user.updateDisplayName(_username);

        // Exibir mensagem de sucesso
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Usuário criado com sucesso'),
            duration: Duration(seconds: 3),
          ),
        );

        // Aguardar e redirecionar para a página de login
        await Future.delayed(const Duration(seconds: 3));
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      } else {
        throw FirebaseAuthException(
            code: 'unknown-error', message: 'Erro ao criar usuário.');
      }
    } on FirebaseAuthException catch (e) {
      // Tratamento de erros do Firebase
      String errorMessage;
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = 'O email já está em uso.';
          break;
        case 'invalid-email':
          errorMessage = 'Email inválido.';
          break;
        case 'weak-password':
          errorMessage = 'A senha é muito fraca.';
          break;
        default:
          errorMessage = 'Erro ao criar usuário: ${e.message}';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (e) {
      // Tratamento de erros gerais
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro inesperado: ${e.toString()}'),
          duration: const Duration(seconds: 3),
        ),
      );
    } finally {
      // Atualizar o estado de carregamento
      _userWaiting = false;
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
    if (_password.isEmpty || _confirmPassword.isEmpty) {
      return "Por favor, preencha todos os campos.";
    }
    if (_password.length < 6) {
      return "A senha deve ter no mínimo 6 caracteres.";
    }
    if (_password != _confirmPassword) {
      return "As senhas não coincidem.";
    }
    return null;
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
                            keyboard: TextInputType.text,
                            onChanged: (value) {
                              _confirmPassword = value;
                            },
                            validatorNonDefault:
                                validatePassword, // Agora aceita a função diretamente
                          ),
                          const SizedBox(height: 32),
                          ButtonDefault(
                            text: "Cadastrar",
                            onPressed: () {
                              // Salvar os valores dos inputs
                              _formKey1.currentState?.save();
                              _formKey2.currentState?.save();
                              _formKey3.currentState?.save();
                              _formKey4.currentState?.save();

                              // Exibir os valores dos campos no console
                              print("Nome: $_username");
                              print("Email: $_email");
                              print("Senha: $_password");
                              print("Confirmar Senha: $_confirmPassword");
                              print("_valid: $_valid");
                              print("validatePassword: $validatePassword()");
                              print("_userWaiting: $_userWaiting");

                              // Validar os campos (apenas após exibir os valores)
                              validateInputs();
                              if (_valid &&
                                  validatePassword() == null &&
                                  !_userWaiting) {
                                SystemChannels.textInput
                                    .invokeMethod('TextInput.hide');
                                _createUser(context);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Preencha os campos corretamente.'),
                                  ),
                                );
                              }
                            },
                            borderOutline: false,
                            disabled: false,
                          ),
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
