import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:prubea1app/home_screen.dart';
import 'api_interface.dart';
import 'login_screen.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'control_variables.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Solar Sync",
      home: LoginScreen()
    );
  }
}
