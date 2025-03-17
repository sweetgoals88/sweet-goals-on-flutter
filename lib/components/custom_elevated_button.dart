import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  void Function()? onPressed;
  String label;

  CustomElevatedButton({super.key, required this.label, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        label,
        style: TextStyle(fontSize: 18, color: Colors.white),
      ),
    );
  }
}
