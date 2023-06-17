import 'package:flutter/material.dart';

class ClearChat extends StatelessWidget {
  final VoidCallback clear;

  const ClearChat({required this.clear, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 16),
          child: FloatingActionButton(
            onPressed: clear,
            backgroundColor: Colors.red,
            child: const Icon(Icons.delete),
          ),
        ),
      ],
    );
  }
}
