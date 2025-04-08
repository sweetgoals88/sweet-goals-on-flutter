import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:prubea1app/views/dashboard/dashboard_data_provider.dart';
import 'package:prubea1app/db/models/notification.dart';

class NotificationsFragment extends StatelessWidget {
  const NotificationsFragment({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DashboardDataProvider>(context, listen: false);
    final notifications = provider.asUser().notifications;

    return Scaffold(
      appBar: AppBar(title: const Text("Notificaciones")),
      body:
          notifications.isEmpty
              ? const Center(
                child: Text(
                  "Sin notificaciones disponibles",
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              )
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final notification = notifications[index];
                  final cardColor =
                      notification.seen ? Colors.grey[200] : Colors.white;
                  return Card(
                    color: cardColor,
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      title: Text(
                        notification.message.substring(
                          0,
                          min(24, notification.message.length),
                        ),
                      ),
                      subtitle: Text(notification.message),
                      trailing: Text(
                        notification.createdAt.toString(),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
