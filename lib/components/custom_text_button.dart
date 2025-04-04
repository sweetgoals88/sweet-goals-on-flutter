import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  void Function()? onPressed;
  String text;

  CustomTextButton({super.key, required this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(text, style: TextStyle(color: Colors.green)),
    );
  }
}
