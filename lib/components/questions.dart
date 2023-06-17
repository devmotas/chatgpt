import 'package:flutter/material.dart';

class Questions extends StatelessWidget {
  List<Map<String, String>> allData = [];
  var index = 0;

  Questions({required this.allData, required this.index, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(vertical: 20),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        allData[index]['question']!,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
