import 'package:new_chatgpt/components/buttonDefault.dart';
import 'package:new_chatgpt/components/cardInformationUser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserInformation extends StatefulWidget {
  final storage = const FlutterSecureStorage();

  const UserInformation({super.key});

  @override
  State<UserInformation> createState() => _UserInformationState();
}

class _UserInformationState extends State<UserInformation> {
  final storage = const FlutterSecureStorage();

  Map<String, dynamic> storedUser = {};
  String _email = '';

  void _exitApp(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Tem certeza que deseja sair?',
            style:
                TextStyle(color: Color.fromRGBO(32, 34, 34, 1.0), fontSize: 16),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Sim',
                style: TextStyle(
                  color: Color.fromRGBO(204, 204, 204, 1.0),
                ),
              ),
              onPressed: () {
                exit();
              },
            ),
            TextButton(
              child: const Text(
                'Não',
                style: TextStyle(
                  color: Color.fromRGBO(32, 34, 34, 1.0),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        );
      },
    );
  }

  exit() async {
    await widget.storage.write(key: 'isLoggedBefore', value: 'false');
    await widget.storage.delete(key: 'dataUser');
    await widget.storage.delete(key: 'user');
    await widget.storage.delete(key: 'email');
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  @override
  void initState() {
    super.initState();
    _initializeUserData();
  }

  Future<void> _initializeUserData() async {
    String? email = await storage.read(key: 'email');
    setState(() {
      _email = email ?? '';
      storedUser = {'email': _email};
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(32, 34, 34, 1.0),
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app, color: Colors.red),
            onPressed: () {
              _exitApp(context);
            },
          )
        ],
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
                  onPressed: () {
                    Navigator.pushNamed(context, '/recoveryPassword');
                  },
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
