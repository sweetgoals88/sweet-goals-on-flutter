import 'package:flutter/material.dart';
import 'package:solar/components/custom_text_field_controller.dart';

class CustomEmailField extends StatelessWidget {
  CustomTextFieldController controller;
  String? Function(String?)? validator;
  String label;

  CustomEmailField({
    super.key,
    required this.label,
    required this.controller,
    this.validator,
  });

  static String? defaultValidator(String? value) {
    final emailRegExp = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (value == null || value.isEmpty) {
      return 'Por favor ingrese su correo electrónico';
    } else if (!emailRegExp.hasMatch(value)) {
      return 'Por favor ingrese un correo válido';
    }
    return null;
  }

  String? _finalValidator(String? value) {
    final error =
        validator?.call(value) ?? CustomEmailField.defaultValidator(value);
    controller.error = error;
    return error;
  }

  String? _validate() {
    final error = validator?.call(controller.text) ??
        CustomEmailField.defaultValidator(controller.text);
    controller.error = error;
    return error;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String?>(
      valueListenable: controller.errorNotifier,
      builder: (context, errorText, child) => TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          errorText: errorText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onChanged: (_) => _finalValidator(controller.text),
        validator: (value) => _finalValidator(value),
      ),
    );
  }
}
