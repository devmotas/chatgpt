// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../components/buttonDefault.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final storage = const FlutterSecureStorage();
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(); // Apenas uma chave
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _username = "";
  String _password = "";
  bool _userWaiting = false;
  bool _saveData = false;
  bool _isObscured = true;

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  Future<void> _loadSavedData() async {
    final value = await storage.read(key: 'dataUser');
    if (value != null) {
      Map<String, dynamic> userCredentials = jsonDecode(value);
      setState(() {
        _username = userCredentials['email'];
        _password = userCredentials['password'];
        _saveData = true;
        _usernameController.text = _username;
        _passwordController.text = _password;
      });
      _login();
    }
  }

  void _login() async {
    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();

    setState(() {
      _userWaiting = true;
    });

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _username.trim(),
        password: _password.trim(),
      );

      User? user = userCredential.user;

      if (user != null) {
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
      print(e.code);
      String errorMessage;
      switch (e.code) {
        case "invalid-credential":
          errorMessage = 'Dados de autenticação inválidos.';
          setState(() {
            _saveData = false;
            storage.delete(key: 'dataUser');
            storage.delete(key: 'isLoggedBefore');
            storage.delete(key: 'user');
            storage.delete(key: 'email');
          });
          break;
        default:
          errorMessage = 'Erro inesperado ao fazer login';
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
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: const BoxDecoration(
              color: Color.fromRGBO(32, 34, 34, 1.0),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight, // Garante altura total
                    ),
                    child: IntrinsicHeight(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextFormField(
                              controller: _usernameController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                labelText: 'E-mail',
                                labelStyle:
                                    const TextStyle(color: Colors.white),
                                prefixIcon: const Icon(Icons.person,
                                    color: Colors.white),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade300),
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white54),
                                ),
                              ),
                              style: const TextStyle(color: Colors.white),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor insira seu email';
                                }
                                final emailRegex =
                                    RegExp(r'^[^@]+@[^@]+\.[^@]+$');
                                if (!emailRegex.hasMatch(value)) {
                                  return 'Insira um email válido';
                                }
                                return null;
                              },
                              onChanged: (value) => _username = value,
                            ),
                            const SizedBox(height: 30),
                            TextFormField(
                              controller: _passwordController,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: false, signed: false),
                              obscureText: _isObscured,
                              decoration: InputDecoration(
                                labelText: 'Senha',
                                labelStyle:
                                    const TextStyle(color: Colors.white),
                                prefixIcon:
                                    const Icon(Icons.lock, color: Colors.white),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isObscured
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isObscured = !_isObscured;
                                    });
                                  },
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade300),
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white54),
                                ),
                              ),
                              style: const TextStyle(color: Colors.white),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor insira sua senha';
                                }
                                if (value.length < 6) {
                                  return 'A senha deve ter pelo menos 6 caracteres';
                                }
                                return null;
                              },
                              onChanged: (value) => _password = value,
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Switch(
                                  value: _saveData,
                                  activeColor: Colors.grey,
                                  onChanged: (value) {
                                    setState(() {
                                      _saveData = value;
                                    });
                                  },
                                ),
                                const Text(
                                  'Lembrar de mim',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                            const SizedBox(height: 42),
                            ButtonDefault(
                              text: 'ENTRAR',
                              onPressed: () {
                                if (_formKey.currentState!.validate() &&
                                    !_userWaiting) {
                                  FocusScope.of(context)
                                      .unfocus(); // Fecha o teclado
                                  _login();
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
