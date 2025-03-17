import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:solar/components/custom_elevated_button.dart';
import 'package:solar/components/custom_email_field.dart';
import 'package:solar/components/custom_password_field.dart';
import 'package:solar/components/custom_text_field_controller.dart';
import 'package:solar/home_screen.dart';

class RegisterScreen extends StatefulWidget {
  bool allowFormSubmission = true;

  RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final CustomTextFieldController _nameController = CustomTextFieldController();
  final CustomTextFieldController _emailController =
      CustomTextFieldController();
  final CustomTextFieldController _passwordController =
      CustomTextFieldController();
  final CustomTextFieldController _confirmPasswordController =
      CustomTextFieldController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _register() async {
    if (!widget.allowFormSubmission) {
      return;
    }

    setState(() {
      widget.allowFormSubmission = false;
    });

    final name = _nameController.text;
    final email = _emailController.text;
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (password != confirmPassword) {
      _confirmPasswordController.error =
          "El texto no coincide con la contraseña anterior";
      return;
    }

    try {
      final credentials =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        _passwordController.error = "La contraseña es muy débil";
      } else if (e.code == "email-already-in-use") {
        _emailController.error = "El correo ingresado ya está en uso";
      } else {
        print(e);
        _showError(e.code);
      }
    } catch (e) {
      print(e);
    }

    setState(() {
      widget.allowFormSubmission = true;
    });
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registro"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Crear una nueva cuenta",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: "Nombre de usuario",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Ingresa un nombre de usuario";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomEmailField(
                    label: "Correo electrónico",
                    controller: _emailController,
                  ),
                  const SizedBox(height: 20),
                  CustomPasswordField(
                    label: "Contraseña",
                    controller: _passwordController,
                  ),
                  const SizedBox(height: 20),
                  CustomPasswordField(
                    label: "Confirmar contraseña",
                    controller: _confirmPasswordController,
                  ),
                  const SizedBox(height: 30),
                  CustomElevatedButton(
                    label: "Registrarse",
                    onPressed: widget.allowFormSubmission ? _register : null,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
