import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solar/app_state.dart';
import 'package:solar/components/custom_elevated_button.dart';
import 'package:solar/components/custom_email_field.dart';
import 'package:solar/components/custom_password_field.dart';
import 'package:solar/components/custom_text_button.dart';
import 'package:solar/components/custom_text_field_controller.dart';
import 'package:solar/home_screen.dart';
import 'package:solar/main.dart';
import 'package:solar/register_screen.dart';

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
        // Attempt to sign in
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // Notify the app state that user is logged in
        Provider.of<ApplicationState>(context, listen: false).init();

        // Navigate to HomeScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } on FirebaseAuthException catch (e) {
        String errorMessage = "Error al iniciar sesión.";
        if (e.code == 'user-not-found') {
          errorMessage = "No se encontró un usuario con este correo.";
        } else if (e.code == 'wrong-password') {
          errorMessage = "Contraseña incorrecta.";
        }

        // Display error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
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
