import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:prubea1app/api_interface.dart' as api;

class ProfileFragment extends StatelessWidget {
  const ProfileFragment({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () async {
            try {
              await api.logout();
              if (!context.mounted) return;
              context.go("/login");
            } catch (e) {
              if (!context.mounted) return;
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text("Error al cerrar sesión")));
            }
          },
          child: Text("Cerrar sesión"),
        ),
      ],
    );
  }
}
