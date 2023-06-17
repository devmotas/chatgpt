import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HomeIntroduction extends StatelessWidget {
  const HomeIntroduction({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/logo/chatgpt_logo.svg',
            color: Colors.white.withOpacity(0.1),
          ),
          const Text(
            'Bem vindo ao ChatGPT',
            style: TextStyle(fontSize: 26, color: Colors.white60),
          ),
        ],
      ),
    );
  }
}
