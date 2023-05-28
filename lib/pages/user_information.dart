import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class UserInformation extends StatefulWidget {
  final storage = const FlutterSecureStorage();

  const UserInformation({super.key});

  @override
  State<UserInformation> createState() => _UserInformationState();
}

class _UserInformationState extends State<UserInformation> {
  Map<String, dynamic> storedUser = {};
  String _name = '';
  String _email = '';
  String _id = '';
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmNewPasswordController = TextEditingController();

  _isValidInput() {
    bool valid = _newPasswordController.text.length >= 6 &&
        _oldPasswordController.text.length >= 6 &&
        _newPasswordController.text == _confirmNewPasswordController.text;
    return valid;
  }

  void _updatePassword(context) async {
    print(_isValidInput());
    final apiUrl = dotenv.env['API_URL'];

    final response = await http.put(
      Uri.parse('$apiUrl/update-password/$_id'),
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
      setState(() {
        _newPasswordController.text = '';
        _oldPasswordController.text = '';
        _confirmNewPasswordController.text = '';
      });

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
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    widget.storage.read(key: 'user').then((value) {
      setState(() {
        storedUser = jsonDecode(value!);
        _name = storedUser['name'];
        _email = storedUser['email'];
        _id = storedUser['id'].toString();
        print(storedUser['id']);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(32, 34, 34, 1.0),
        automaticallyImplyLeading: true,
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(
            16, MediaQuery.sizeOf(context).height * 0.2, 16, 16),
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        decoration: const BoxDecoration(
          color: Color.fromRGBO(32, 34, 34, 1.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Card(
              margin: const EdgeInsets.only(bottom: 30),
              child: InkWell(
                onTap: () {},
                splashColor: Colors.grey,
                child: ListTile(
                  leading: const Icon(Icons.person, color: Colors.black),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Nome',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          _name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Card(
              margin: const EdgeInsets.only(bottom: 30),
              child: InkWell(
                onTap: () {},
                splashColor: Colors.grey,
                child: ListTile(
                  leading: const Icon(Icons.person, color: Colors.black),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Email',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          _email,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      const Color.fromRGBO(47, 50, 49, 1.0),
                    ),
                  ),
                  child: const Text("Alterar senha"),
                  onPressed: () {
                    showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      builder: (context) {
                        return Padding(
                          padding: EdgeInsets.fromLTRB(16, 16, 16,
                              16 + MediaQuery.of(context).viewInsets.bottom),
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
                                                const Color.fromRGBO(
                                                    47, 50, 49, 1.0),
                                              )
                                            : MaterialStateProperty.all<Color>(
                                                Color.fromARGB(255, 17, 17, 17),
                                              )),
                                    onPressed: () {
                                      _formKey.currentState!.validate();
                                      _isValidInput()
                                          ? _updatePassword(context)
                                          : null;
                                    },
                                    child: const Text("Alterar"),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
