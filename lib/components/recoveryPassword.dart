import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class RecoveryPassword extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmNewPasswordController = TextEditingController();
  Map<String, dynamic> user;

  RecoveryPassword({required this.user, super.key});

  _isValidInput() {
    bool valid = _newPasswordController.text.length >= 6 &&
        _oldPasswordController.text.length >= 6 &&
        _newPasswordController.text == _confirmNewPasswordController.text;
    return valid;
  }

  void _updatePassword(context) async {
    SystemChannels.textInput.invokeMethod('TextInput.hide');

    final apiUrl = dotenv.env['API_URL'];

    final response = await http.put(
      Uri.parse('$apiUrl/update-password/${user['id'].toString()}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'newPassword': _newPasswordController.text,
        'password': _oldPasswordController.text,
      }),
    );

    if (response.statusCode == 200) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Senha alterada com sucesso.'),
          duration: Duration(seconds: 4),
        ),
      );
    } else {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao alterar senha.'),
          duration: Duration(seconds: 3),
        ),
      );
    }
    _newPasswordController.text = '';
    _oldPasswordController.text = '';
    _confirmNewPasswordController.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(
            16, 16, 16, 16 + MediaQuery.of(context).viewInsets.bottom),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Alteração de Senha',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: _oldPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Senha antiga',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor insira sua senha antiga!';
                  }
                  return null;
                },
                onEditingComplete: () {
                  FocusScope.of(context).nextFocus();
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: _newPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Nova senha',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor insira sua senha nova!';
                  }
                  return null;
                },
                onEditingComplete: () {
                  FocusScope.of(context).nextFocus();
                },
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: _confirmNewPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Confirmar nova senha',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'A nova foi digitada errada!';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: _isValidInput()
                          ? MaterialStateProperty.all<Color>(
                              const Color.fromRGBO(47, 50, 49, 1.0),
                            )
                          : MaterialStateProperty.all<Color>(
                              Color.fromARGB(255, 17, 17, 17),
                            )),
                  onPressed: () {
                    _formKey.currentState!.validate();
                    _isValidInput() ? _updatePassword(context) : null;
                  },
                  child: const Text("Alterar"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
