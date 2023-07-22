import 'dart:convert';

import 'package:ChatGpt/components/inputDefault.dart';
import 'package:ChatGpt/mixins/validations_mixing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class RecoveryPassword extends StatelessWidget with ValidationsMixing {
  static final _formKey1 = GlobalKey<FormState>();
  static final _formKey2 = GlobalKey<FormState>();
  static final _formKey3 = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmNewPasswordController = TextEditingController();
  final storage = const FlutterSecureStorage();
  String _oldPassword = '';
  String _newPassword = '';
  String _confirmNewPassword = '';
  bool _userWaiting = false;
  bool _invalidOldPassword = true;
  Map<String, dynamic> user;

  RecoveryPassword({required this.user, super.key});

  void _updatePassword(context) async {
    bool form1Valid = _formKey1.currentState!.validate();
    bool form2Valid = _formKey2.currentState!.validate();
    bool form3Valid = _formKey3.currentState!.validate();

    _formKey1.currentState?.save();
    _formKey2.currentState?.save();
    _formKey3.currentState?.save();

    if (form1Valid && form2Valid && form3Valid) {
      _userWaiting = true;
      final apiUrl = dotenv.env['API_URL'];
      final response = await http.put(
        Uri.parse('$apiUrl/update-password/${user['id'].toString()}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'newPassword': _newPassword,
          'password': _oldPassword,
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
        _updateStorage();
        _newPasswordController.clear();
        _oldPasswordController.clear();
        _confirmNewPasswordController.clear();
        _userWaiting = false;
      } else if (jsonDecode(response.body) == "Senha antiga incorreta.") {
        // _invalidOldPassword = true;
        // _formKey1.currentState?.save();
        // _formKey1.currentState!.validate();
        // _userWaiting = false;
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Senha antiga incorreta.'),
            duration: Duration(seconds: 4),
          ),
        );
      } else {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Houve um erro, tente mais tarde.'),
            duration: Duration(seconds: 4),
          ),
        );
        _userWaiting = false;
      }
    }
  }

  _updateStorage() {
    storage.read(key: 'dataUser').then((value) async {
      if (value != null) {
        Map<String, dynamic> userCredentials = jsonDecode(value);
        final dataUser = jsonEncode(<String, String>{
          'email': userCredentials['email'],
          'password': _newPassword,
        });
        await storage.write(key: 'dataUser', value: dataUser);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(color: Colors.grey[850]),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                  16, 16, 16, 16 + MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Alteração de Senha',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 16.0),
                  InputDefault(
                    formKey: _formKey1,
                    label: 'Senha antiga',
                    error: "Por favor insira sua senha antiga",
                    iconInput: Icon(Icons.lock, color: Colors.grey[300]),
                    onChanged: (value) {
                      _oldPassword = value;
                    },
                    keyboard: TextInputType.number,
                    colorText: Colors.grey[300],
                    colorBorder: Colors.grey[300],
                    colorLabel: Colors.grey[500],
                    controller: _oldPasswordController,
                  ),
                  const SizedBox(height: 16.0),
                  InputDefault(
                    formKey: _formKey2,
                    label: 'Nova senha',
                    error: "Por favor insira sua nova senha",
                    iconInput: Icon(Icons.lock, color: Colors.grey[300]),
                    onChanged: (value) {
                      _newPassword = value;
                    },
                    keyboard: TextInputType.number,
                    colorText: Colors.grey[300],
                    colorBorder: Colors.grey[300],
                    colorLabel: Colors.grey[500],
                    controller: _newPasswordController,
                  ),
                  const SizedBox(height: 16.0),
                  InputDefault(
                    formKey: _formKey3,
                    label: 'Confirmar senha',
                    error: "Por favor confirme sua nova senha",
                    iconInput: Icon(Icons.lock, color: Colors.grey[300]),
                    onChanged: (value) {
                      _confirmNewPassword = value;
                    },
                    keyboard: TextInputType.number,
                    colorText: Colors.grey[300],
                    colorBorder: Colors.grey[300],
                    colorLabel: Colors.grey[500],
                    controller: _confirmNewPasswordController,
                  ),
                  const SizedBox(height: 16.0),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.grey[500] ?? Colors.grey),
                      ),
                      onPressed: () {
                        if (_formKey1.currentState!.validate() &&
                            _formKey2.currentState!.validate()) {
                          _updatePassword(context);
                        }
                      },
                      child: const Text("Alterar"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
