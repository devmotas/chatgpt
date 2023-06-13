import 'package:flutter/material.dart';

class ButtonDefault extends StatelessWidget {
  String text = "";
  bool borderOutline = false;
  bool disabled = false;
  final VoidCallback onPressed;

  ButtonDefault({
    required this.text,
    required this.onPressed,
    required this.borderOutline,
    required this.disabled,
  });
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
          onPressed: disabled ? null : onPressed,
          style: ButtonStyle(
              backgroundColor: borderOutline
                  ? MaterialStateProperty.all<Color>(
                      const Color.fromRGBO(32, 34, 34, 1.0))
                  : MaterialStateProperty.all<Color>(
                      const Color.fromRGBO(47, 50, 49, 1.0)),
              side: MaterialStateProperty.all(BorderSide(
                  color: borderOutline ? Colors.white : Colors.transparent)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(10), // Define o raio da borda
                ),
              )),
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
            ),
          )),
    );
  }
}
