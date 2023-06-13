import 'package:flutter/material.dart';

class InputChatgpt extends StatelessWidget {
  late FocusNode _focusNode;
  final TextEditingController _inputController = TextEditingController();

  final ValueChanged<String>? value;

  InputChatgpt({
    this.value,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: _focusNode,
      controller: _inputController,
      decoration: InputDecoration(
        filled: true,
        fillColor: Color.fromRGBO(47, 50, 49, 1.0),
        hintText: 'Digite aqui...',
        hintStyle: const TextStyle(
          color: Color.fromRGBO(153, 153, 153, 1.0),
        ),
        border: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Color.fromRGBO(153, 153, 153, 1.0),
            width: 2.0, // Define a espessura da borda
          ),
          borderRadius: BorderRadius.circular(8.0), // Define o raio da borda
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Color.fromRGBO(204, 204, 204, 1.0),
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        suffixIcon: IconButton(
          icon: const Icon(Icons.send),
          color: Colors.white,
          onPressed: null,
          // onPressed: _uploadData,
        ),
      ),
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16,
      ),
    );
  }
}
