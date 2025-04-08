import 'package:flutter/material.dart';
import 'package:prubea1app/api_interface.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Dashboard')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(
            child: Text(
              'El dashboard del administrador está bajo desarrollo.\n¡Visita la página web en su lugar!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              await logout();
            },
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }
}
