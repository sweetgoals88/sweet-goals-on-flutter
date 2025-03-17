import 'package:flutter/material.dart';
import 'package:solar/components/custom_text_field_controller.dart';

class CustomPasswordField extends StatefulWidget {
  final String label;
  final CustomTextFieldController controller;
  final String? Function(String?)? validator;

  const CustomPasswordField({
    super.key,
    required this.label,
    required this.controller,
    this.validator,
  });

  static String? defaultValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingrese una contraseña';
    } else if (value.length < 6) {
      return 'La contraseña debe tener al menos 6 caracteres';
    }
    return null;
  }

  @override
  _CustomPasswordFieldState createState() => _CustomPasswordFieldState();
}

class _CustomPasswordFieldState extends State<CustomPasswordField> {
  bool _passwordVisible = false;

  String? _finalValidator(String? value) {
    final error = widget.validator?.call(value) ??
        CustomPasswordField.defaultValidator(value);
    widget.controller.error = error;
    return error;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String?>(
      valueListenable: widget.controller.errorNotifier,
      builder: (context, errorText, child) {
        return TextFormField(
          controller: widget.controller,
          obscureText: !_passwordVisible,
          decoration: InputDecoration(
            labelText: widget.label,
            errorText: errorText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _passwordVisible ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () {
                setState(() {
                  _passwordVisible = !_passwordVisible;
                });
              },
            ),
          ),
          onChanged: (_) => _finalValidator(widget.controller.text),
          validator: (value) => _finalValidator(value),
        );
      },
    );
  }
}
