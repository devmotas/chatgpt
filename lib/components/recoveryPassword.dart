import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:new_chatgpt/components/buttonDefault.dart';
import 'package:new_chatgpt/mixins/validations_mixing.dart';

class RecoveryPassword extends StatefulWidget with ValidationsMixing {
  const RecoveryPassword({Key? key}) : super(key: key);

  @override
  State<RecoveryPassword> createState() => _RecoveryPasswordState();
}

class _RecoveryPasswordState extends State<RecoveryPassword> {
  static final GlobalKey<FormState> _formKeyUpdatePassword =
      GlobalKey<FormState>();

  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmNewPasswordController = TextEditingController();

  String _email = '';
  bool _userWaiting = false;

  final storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _loadEmailFromStorage();
  }

  Future<void> _loadEmailFromStorage() async {
    final emailFromStorage = await storage.read(key: 'email');
    setState(() {
      _email = emailFromStorage ?? '';
    });
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmNewPasswordController.dispose();
    super.dispose();
  }

  String? _validateOldPassword() {
    final oldPass = _oldPasswordController.text.trim();
    if (oldPass.length < 6) {
      return 'A senha deve ter no mínimo 6 caracteres';
    }
    return null;
  }

  String? _validateNewPassword() {
    final oldPass = _oldPasswordController.text.trim();
    final newPass = _newPasswordController.text.trim();

    if (newPass.length < 6) {
      return 'A senha deve ter no mínimo 6 caracteres';
    }
    if (newPass == oldPass) {
      return 'A nova senha deve ser diferente da antiga';
    }
    return null;
  }

  String? _validateConfirmPassword() {
    final newPass = _newPasswordController.text.trim();
    final confirmPass = _confirmNewPasswordController.text.trim();

    if (confirmPass.length < 6) {
      return 'A senha deve ter no mínimo 6 caracteres';
    }
    if (confirmPass != newPass) {
      return 'As senhas não conferem';
    }
    return null;
  }

  void _updatePassword(BuildContext context) async {
    if (!_formKeyUpdatePassword.currentState!.validate()) return;

    FocusScope.of(context).unfocus();
    try {
      setState(() => _userWaiting = true);

      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw FirebaseAuthException(
          code: 'user-not-logged-in',
          message: 'Usuário não está autenticado.',
        );
      }

      final credential = EmailAuthProvider.credential(
        email: _email,
        password: _oldPasswordController.text,
      );
      await currentUser.reauthenticateWithCredential(credential);
      await currentUser.updatePassword(_newPasswordController.text);
      await _updateStorage();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Senha alterada com sucesso.'),
          duration: Duration(seconds: 4),
        ),
      );
      Navigator.pop(context);

      _oldPasswordController.clear();
      _newPasswordController.clear();
      _confirmNewPasswordController.clear();
    } on FirebaseAuthException catch (e) {
      setState(() => _userWaiting = false);
      String errorMessage;
      if (e.code == 'invalid-credential') {
        errorMessage = 'Senha antiga incorreta.';
      } else if (e.code == 'weak-password') {
        errorMessage = 'A nova senha é muito fraca.';
      } else {
        errorMessage = 'Houve um erro, tente mais tarde.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          duration: const Duration(seconds: 4),
        ),
      );
    } catch (e) {
      setState(() => _userWaiting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Houve um erro, tente mais tarde.'),
          duration: Duration(seconds: 4),
        ),
      );
    } finally {
      setState(() => _userWaiting = false);
    }
  }

  Future<void> _updateStorage() async {
    final value = await storage.read(key: 'dataUser');
    if (value != null) {
      final userCredentials = jsonDecode(value);
      final dataUser = jsonEncode(
        <String, String>{
          'email': userCredentials['email'],
          'password': _newPasswordController.text,
        },
      );
      await storage.write(key: 'dataUser', value: dataUser);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(32, 34, 34, 1.0),
      appBar: AppBar(
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color.fromRGBO(32, 34, 34, 1.0),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              16,
              16,
              16,
              16 + MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Form(
              key: _formKeyUpdatePassword,
              child: Column(
                children: [
                  TextFormField(
                    controller: _oldPasswordController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: 'Senha antiga',
                      labelStyle: TextStyle(color: Colors.grey[500]),
                      prefixIcon: Icon(Icons.lock, color: Colors.grey[300]),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                    ),
                    style: TextStyle(color: Colors.grey[300]),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor insira sua senha antiga';
                      }
                      return _validateOldPassword();
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _newPasswordController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: 'Nova senha',
                      labelStyle: TextStyle(color: Colors.grey[500]),
                      prefixIcon: Icon(Icons.lock, color: Colors.grey[300]),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                    ),
                    style: TextStyle(color: Colors.grey[300]),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor insira sua nova senha';
                      }
                      return _validateNewPassword();
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _confirmNewPasswordController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: 'Confirmar senha',
                      labelStyle: TextStyle(color: Colors.grey[500]),
                      prefixIcon: Icon(Icons.lock, color: Colors.grey[300]),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                    ),
                    style: TextStyle(color: Colors.grey[300]),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor confirme sua nova senha';
                      }
                      return _validateConfirmPassword();
                    },
                  ),
                  const SizedBox(height: 24),
                  ButtonDefault(
                    text: 'Alterar',
                    onPressed: () => _updatePassword(context),
                    borderOutline: false,
                    disabled: _userWaiting,
                  ),
                ],
              ),
            ),
          ),
          if (_userWaiting)
            Container(
              width: double.infinity,
              height: double.infinity,
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
