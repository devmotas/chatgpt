import 'package:flutter/material.dart';

class PrivacyTerm extends StatelessWidget {
  const PrivacyTerm({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: const Color.fromRGBO(32, 34, 34, 1.0),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Color.fromRGBO(32, 34, 34, 1.0),
        ),
        child: const Center(
          child: Text(
            'Página ainda não disponível',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }
}
