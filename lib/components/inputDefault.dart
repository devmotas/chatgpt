import 'package:flutter/material.dart';

class InputDefault extends StatefulWidget {
  final String error;
  final String label;
  final Icon? iconInput;
  final ValueChanged<String>? onChanged;
  final GlobalKey<FormState> formKey;
  final TextInputType? keyboard;

  const InputDefault({
    required this.formKey,
    required this.label,
    required this.error,
    this.iconInput,
    this.onChanged,
    this.keyboard,
    Key? key,
  }) : super(key: key);

  @override
  _InputDefaultState createState() => _InputDefaultState();
}

class _InputDefaultState extends State<InputDefault> {
  String _value = '';

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Container(
        child: TextFormField(
          keyboardType: widget.keyboard,
          decoration: InputDecoration(
            labelText: widget.label,
            labelStyle: const TextStyle(color: Colors.white),
            prefixIcon: widget.iconInput ?? const SizedBox(),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromRGBO(47, 50, 49, 1.0)),
            ),
          ),
          style: const TextStyle(color: Colors.white),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return widget.error;
            }
            return null;
          },
          onSaved: (value) {
            _value = value!;
            if (widget.onChanged != null) {
              widget.onChanged!(_value);
            }
          },
          onEditingComplete: () {
            widget.formKey.currentState!.validate();
            FocusScope.of(context).nextFocus();
          },
        ),
      ),
    );
  }
}
