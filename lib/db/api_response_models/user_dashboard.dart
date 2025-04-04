// Customers can view their panels, panel data, their last notifications, their name and surname

import 'package:prubea1app/db/models/notification.dart';
import 'package:prubea1app/db/models/prototype.dart';
import 'package:prubea1app/db/models/user.dart';

class CustomerDashboardPayload {
  final String id;
  final String name;
  final String surname;
  final String email;
  final String type;
  final List<NotificationPreview> notifications;
  final String oldestNotification;
  final List<PrototypePreview> prototypes;

  CustomerDashboardPayload({
    required this.id,
    required this.name,
    required this.surname,
    required this.email,
    required this.type,
    required this.notifications,
    required this.oldestNotification,
    required this.prototypes,
  });

  factory CustomerDashboardPayload.fromJson(Map<String, dynamic> json) {
    return CustomerDashboardPayload(
      id: json['id'],
      name: json['name'],
      surname: json['surname'],
      email: json['email'],
      type: json['type'],
      notifications:
          (json['notifications'] as List)
              .map((e) => NotificationPreview.fromJson(e))
              .toList(),
      oldestNotification: json['oldestNotification'],
      prototypes:
          (json['prototypes'] as List)
              .map((e) => PrototypePreview.fromJson(e))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'surname': surname,
      'email': email,
      'type': type,
      'notifications': notifications.map((e) => e.toJson()).toList(),
      'oldestNotification': oldestNotification,
      'prototypes': prototypes.map((e) => e.toJson()).toList(),
    };
  }
}

// Admins can view their invited admins and all users in general, as well
// as their last notifications, their name and surname

class AdminDashboardPayload {
  final String id;
  final String name;
  final String surname;
  final String email;
  final String type;
  final List<NotificationPreview> notifications;
  final String oldestNotification;
  final List<AdminPreview> admins;
  final List<CustomerPreview> customers;

  AdminDashboardPayload({
    required this.id,
    required this.name,
    required this.surname,
    required this.email,
    required this.type,
    required this.notifications,
    required this.oldestNotification,
    required this.admins,
    required this.customers,
  });

  factory AdminDashboardPayload.fromJson(Map<String, dynamic> json) {
    return AdminDashboardPayload(
      id: json['id'],
      name: json['name'],
      surname: json['surname'],
      email: json['email'],
      type: json['type'],
      notifications:
          (json['notifications'] as List)
              .map((e) => NotificationPreview.fromJson(e))
              .toList(),
      oldestNotification: json['oldestNotification'],
      admins:
          (json['admins'] as List)
              .map((e) => AdminPreview.fromJson(e))
              .toList(),
      customers:
          (json['customers'] as List)
              .map((e) => CustomerPreview.fromJson(e))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'surname': surname,
      'email': email,
      'type': type,
      'notifications': notifications.map((e) => e.toJson()).toList(),
      'oldestNotification': oldestNotification,
      'admins': admins.map((e) => e.toJson()).toList(),
      'customers': customers.map((e) => e.toJson()).toList(),
    };
  }
}
