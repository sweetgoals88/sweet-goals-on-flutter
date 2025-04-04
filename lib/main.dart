import 'package:flutter/material.dart';
import 'package:prubea1app/home_screen.dart';
import 'package:prubea1app/routing.dart';
import 'login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: "Solar Sync",
      routerConfig: router,
    );
  }
}
