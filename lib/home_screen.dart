import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:solar/app_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  Widget _buildScreen(int index) {
    switch (index) {
      case 0:
        return const Center(
          child: Text(
            'Análisis de Producción',
            style: TextStyle(fontSize: 30, color: Colors.black),
          ),
        );
      case 1:
        return const Center(
          child: Text(
            'Dashboard',
            style: TextStyle(fontSize: 30, color: Colors.black),
          ),
        );
      case 2:
        return const Center(
          child: Text(
            'Alerta',
            style: TextStyle(fontSize: 30, color: Colors.black),
          ),
        );
      case 3:
        return const Center(
          child: Text(
            'Acciones Correctivas',
            style: TextStyle(fontSize: 30, color: Colors.black),
          ),
        );
      case 4:
        return _buildProfileScreen();
      default:
        return const Center(child: Text("Pantalla no encontrada"));
    }
  }

  Widget _buildProfileScreen() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Perfil",
          style: TextStyle(fontSize: 30, color: Colors.black),
        ),
        const SizedBox(height: 20),
        ElevatedButton.icon(
          onPressed: () async {
            await Provider.of<ApplicationState>(context, listen: false)
                .logout();
          },
          icon: const Icon(Icons.logout),
          label: const Text("Cerrar sesión"),
        ),
      ],
    );
  }

  final titles = [
    'Análisis de Producción',
    'Dashboard',
    'Alerta',
    'Acciones Correctivas',
    'Perfil'
  ];

  final colors = [
    Colors.tealAccent
        .withValues(alpha: 0.3), // Color para Análisis de Producción
    Colors.greenAccent.withValues(alpha: 0.3), // Color para Dashboard
    Colors.orangeAccent.withValues(alpha: 0.3), // Color para Alerta
    Colors.lightBlueAccent
        .withValues(alpha: 0.3), // Color para Acciones Correctivas
    Colors.orangeAccent.withValues(alpha: 0.3)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titles[_currentIndex]),
        centerTitle: true,
        backgroundColor: colors[_currentIndex],
      ),
      body: ListView(
        children: [
          Container(
            color: Colors.white, // Fondo blanco
            child: _buildScreen(_currentIndex),
          )
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        margin: const EdgeInsets.only(bottom: 5),
        child: GNav(
          backgroundColor: colors[_currentIndex],
          color: Colors.black,
          activeColor: Colors.black,
          tabBackgroundColor: Colors.white.withValues(alpha: 0.3),
          selectedIndex: _currentIndex,
          onTabChange: (index) {
            setState(() => _currentIndex = index);
          },
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          tabs: const [
            GButton(
              icon: Icons.analytics,
              iconActiveColor: Colors.black,
            ),
            GButton(
              icon: Icons.dashboard,
              iconActiveColor: Colors.black,
            ),
            GButton(
              icon: Icons.warning,
              iconActiveColor: Colors.black,
            ),
            GButton(
              icon: Icons.build,
              iconActiveColor: Colors.black,
            ),
            GButton(
              icon: Icons.person,
              iconActiveColor: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}
