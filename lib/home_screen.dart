import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final screens = [
    const Center(child: Text('Análisis de Producción', style: TextStyle(fontSize: 30, color: Colors.black))),
    const Center(child: Text('Dashboard', style: TextStyle(fontSize: 30, color: Colors.black))),
    const Center(child: Text('Alerta', style: TextStyle(fontSize: 30, color: Colors.black))),
    const Center(child: Text('Acciones Correctivas', style: TextStyle(fontSize: 30, color: Colors.black))),
  ];

  final titles = [
    'Análisis de Producción',
    'Dashboard',
    'Alerta',
    'Acciones Correctivas',
  ];

  final colors = [
    Colors.tealAccent.withOpacity(0.3), // Color para Análisis de Producción
    Colors.greenAccent.withOpacity(0.3), // Color para Dashboard
    Colors.orangeAccent.withOpacity(0.3), // Color para Alerta
    Colors.lightBlueAccent.withOpacity(0.3), // Color para Acciones Correctivas
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
        child: screens[_currentIndex],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        margin: const EdgeInsets.only(bottom: 5),
        child: GNav(
          backgroundColor: colors[_currentIndex],
          color: Colors.black,
          activeColor: Colors.black,
          tabBackgroundColor: Colors.white.withOpacity(0.3),
          selectedIndex: _currentIndex,
          onTabChange: (index) {
            setState(() => _currentIndex = index);
          },
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          tabs: const [
            GButton(
              icon: Icons.analytics,
              text: 'Análisis de Producción',
              iconActiveColor: Colors.black,
            ),
            GButton(
              icon: Icons.dashboard,
              text: 'Dashboard',
              iconActiveColor: Colors.black,
            ),
            GButton(
              icon: Icons.warning,
              text: 'Alerta',
              iconActiveColor: Colors.black,
            ),
            GButton(
              icon: Icons.build,
              text: 'Acciones Correctivas',
              iconActiveColor: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}
