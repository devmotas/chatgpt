import 'package:ChatGpt/mixins/validations_mixing.dart';
import 'package:flutter/material.dart';

class InputDefault extends StatefulWidget with ValidationsMixing {
  final String error;
  final String label;
  final Icon? iconInput;
  final ValueChanged<String>? onChanged;
  final GlobalKey<FormState> formKey;
  final TextInputType? keyboard;
  String? validatorNonDefault;
  final TextEditingController? controller;
  final Color? colorText;
  final Color? colorLabel;
  final Color? colorBorder;

  InputDefault({
    required this.formKey,
    required this.label,
    required this.error,
    this.iconInput,
    this.onChanged,
    this.keyboard,
    this.validatorNonDefault,
    this.controller,
    this.colorText,
    this.colorLabel,
    this.colorBorder,
    Key? key,
  }) : super(key: key);

  @override
  _InputDefaultState createState() => _InputDefaultState();
}

class _InputDefaultState extends State<InputDefault> {
  String _value = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Container(
        child: TextFormField(
          keyboardType: widget.keyboard,
          decoration: InputDecoration(
            labelText: widget.label,
            labelStyle: TextStyle(
                color: widget.colorLabel ?? Colors.white), // Wrap in TextStyle
            prefixIcon: widget.iconInput ?? const SizedBox(),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: widget.colorBorder ?? Color.fromRGBO(47, 50, 49, 1.0)),
            ),
          ),
          style: TextStyle(color: widget.colorText ?? Colors.white),
          controller: widget.controller,
          validator: (value) {
            if (widget.error.isNotEmpty) {
              if (value == null || value.isEmpty) {
                return widget.error;
              }
            } else {
              return widget.validatorNonDefault;
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
