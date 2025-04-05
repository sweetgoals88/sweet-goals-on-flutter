import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:prubea1app/api_interface.dart' as api;
import 'package:prubea1app/main.dart';
import 'package:prubea1app/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  Widget _buildScreen(int index) {
    switch (index) {
      case 0: // Análisis de Producción
        return const Center(child: Text("Análisis de Producción"));
      case 1: // Dashboard
        return const Center(child: Text("Dashboard"));
      case 2: // Alertas
        return const Center(child: Text("Alertas"));
      case 3: // Acciones Correctivas
        return const Center(child: Text("Acciones Correctivas"));
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
            await api.logout();
            if (!mounted) return;
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
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
    'Perfil',
  ];

  final colors = [
    Colors.tealAccent.withAlpha(76), // Color para Análisis de Producción
    Colors.greenAccent.withAlpha(76), // Color para Dashboard
    Colors.orangeAccent.withAlpha(76), // Color para Alerta
    Colors.lightBlueAccent.withAlpha(76), // Color para Acciones Correctivas
    Colors.orangeAccent.withAlpha(76), // Color para Perfil
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titles[_currentIndex]),
        centerTitle: true,
        backgroundColor: colors[_currentIndex],
      ),
      body: Container(
        color: Colors.white, // Fondo blanco
        child: _buildScreen(
          _currentIndex,
        ), // Asegúrate de que este método esté funcionando correctamente
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        margin: const EdgeInsets.only(bottom: 5),
        child: GNav(
          backgroundColor: colors[_currentIndex],
          color: Colors.black,
          activeColor: Colors.black,
          tabBackgroundColor: Colors.white.withAlpha(76),
          selectedIndex:
              _currentIndex, // Asegúrate de que este valor coincida con el índice actual
          onTabChange: (index) {
            setState(
              () => _currentIndex = index,
            ); // Actualiza el estado correctamente
          },
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          tabs: const [
            GButton(icon: Icons.analytics, iconActiveColor: Colors.black),
            GButton(icon: Icons.dashboard, iconActiveColor: Colors.black),
            GButton(icon: Icons.warning, iconActiveColor: Colors.black),
            GButton(icon: Icons.build, iconActiveColor: Colors.black),
            GButton(icon: Icons.person, iconActiveColor: Colors.black),
          ],
        ),
      ),
    );
  }
}
