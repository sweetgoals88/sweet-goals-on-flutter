import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:solar/home_screen.dart';
import 'package:solar/login_screen.dart';
import 'package:solar/register_screen.dart';

import 'firebase_options.dart';
import 'app_state.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    ChangeNotifierProvider(
      create: (context) => ApplicationState(),
      builder: ((context, child) => MainApp()),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Solar Sync",
      home: Consumer<ApplicationState>(
        builder: (context, appState, _) {
          return appState.loggedIn ? HomeScreen() : LoginScreen();
        },
      ),
    );
  }
}
