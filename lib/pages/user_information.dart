import 'dart:convert';

import 'package:new_chatgpt/components/buttonDefault.dart';
import 'package:new_chatgpt/components/cardInformationUser.dart';
import 'package:new_chatgpt/components/recoveryPassword.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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

  recoveryPassword() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return RecoveryPassword(
          user: storedUser,
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    widget.storage.read(key: 'user').then((value) {
      setState(() {
        storedUser = jsonDecode(value!);
        _name = storedUser['name'];
        _email = storedUser['email'];
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
            CardInformationUser(
                data: _name,
                label: 'Nome',
                icon: const Icon(Icons.person, color: Colors.black)),
            CardInformationUser(
                data: _email,
                label: 'Email',
                icon: const Icon(Icons.email, color: Colors.black)),
            const SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ButtonDefault(
                  text: 'Alterar senha',
                  onPressed: recoveryPassword,
                  borderOutline: false,
                  disabled: false,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
