import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:prubea1app/api_interface.dart' as api;
import 'package:prubea1app/components/custom_elevated_button.dart';
import 'package:prubea1app/components/custom_email_field.dart';
import 'package:prubea1app/components/custom_password_field.dart';
import 'package:prubea1app/components/custom_text_button.dart';
import 'package:prubea1app/components/custom_text_field_controller.dart';
import 'package:prubea1app/register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final CustomTextFieldController _emailController =
      CustomTextFieldController();
  final CustomTextFieldController _passwordController =
      CustomTextFieldController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      try {
        await api.login(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );

        if (!mounted) return;
        context.go("/dashboard");
      } on DioException catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Error al iniciar sesión: ${e.response?.data["message"]}",
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.4,
              decoration: const BoxDecoration(
                color: Colors.tealAccent,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(100),
                ),
              ),
            ),
            Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "¡Bienvenido!",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Inicia sesión para seguir monitoreando tus dispositivos",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        const SizedBox(height: 40),
                        CustomEmailField(
                          label: "Correo electrónico",
                          controller: _emailController,
                        ),
                        const SizedBox(height: 20),
                        CustomPasswordField(
                          label: "Contraseña",
                          controller: _passwordController,
                        ),
                        const SizedBox(height: 30),
                        CustomElevatedButton(
                          label: "Iniciar sesión",
                          onPressed: _login,
                        ),
                        const SizedBox(height: 20),
                        CustomTextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  _emailController.clear();
                                  _passwordController.clear();
                                  return RegisterScreen();
                                },
                              ),
                            );
                          },
                          text: "¿No tienes cuenta? Regístrate",
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
