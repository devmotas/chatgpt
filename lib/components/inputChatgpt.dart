import 'package:flutter/material.dart';

class InputChatgpt extends StatefulWidget {
  late TextEditingController inputController = TextEditingController();
  final VoidCallback onPressed;

  InputChatgpt({
    required this.inputController,
    required this.onPressed,
    super.key,
  });

  @override
  State<InputChatgpt> createState() => _InputChatgptState();
}

class _InputChatgptState extends State<InputChatgpt> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  uploadData() {
    _focusNode.unfocus();
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: _focusNode,
      controller: widget.inputController,
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
          onPressed: uploadData,
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
