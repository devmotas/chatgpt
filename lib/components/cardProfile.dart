import 'package:flutter/material.dart';

class CardProfile extends StatelessWidget {
  String text = '';
  String router = '';
  Icon icon;
  CardProfile(
      {required this.text,
      required this.router,
      required this.icon,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      // margin: const EdgeInsets.fromLTRB(0, 30, 0, 30),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, router);
        },
        splashColor: Colors.grey,
        child: ListTile(
          leading: icon,
          title: Text(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.black,
            ),
          ),
          trailing: const Icon(Icons.arrow_forward_ios),
        ),
      ),
    );
  }
}
