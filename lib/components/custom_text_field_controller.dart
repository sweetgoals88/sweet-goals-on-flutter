import 'package:flutter/material.dart';

class CustomTextFieldController extends TextEditingController {
  final ValueNotifier<String?> errorNotifier = ValueNotifier(null);

  String? get error {
    return errorNotifier.value;
  }

  set error(String? error) {
    errorNotifier.value = error;
  }

  void clearError() {
    errorNotifier.value = null;
  }

  @override
  void dispose() {
    errorNotifier.dispose();
    super.dispose();
  }
}
