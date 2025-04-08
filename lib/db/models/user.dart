import 'package:prubea1app/db/models/notification.dart';
import 'package:prubea1app/db/models/prototype.dart';

class CustomerPreview {
  final String id;
  final String name;
  final String surname;
  final String email;
  final String type;
  final List<NotificationPreview> notifications;
  final String? oldestNotification;
  final List<PrototypePreview> prototypes;

  CustomerPreview({
    required this.id,
    required this.name,
    required this.surname,
    required this.email,
    required this.type,
    required this.notifications,
    required this.oldestNotification,
    required this.prototypes,
  });

  factory CustomerPreview.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final name = json['name'];
    final surname = json['surname'];
    final email = json['email'];
    final type = json['type'];
    final notifications =
        (json['notifications'] != null
                ? json['notifications'] as List
                : List.empty())
            .map((e) => NotificationPreview.fromJson(e))
            .toList();
    final oldestNotification = json['oldestNotification'];
    final prototypes =
        (json['prototypes'] != null ? json['prototypes'] as List : List.empty())
            .map((e) => PrototypePreview.fromJson(e))
            .toList();

    return CustomerPreview(
      id: id,
      name: name,
      surname: surname,
      email: email,
      type: type,
      notifications: notifications,
      oldestNotification: oldestNotification,
      prototypes: prototypes,
    );
  }
}

class AdminPreview {
  final String id;
  final String name;
  final String surname;
  final String email;
  final String type;
  final String adminCode;
  final String permissions;
  final List<String> invitedAdmins;
  final List<NotificationPreview> notifications;
  final String? lastNotification;

  AdminPreview({
    required this.id,
    required this.name,
    required this.surname,
    required this.email,
    required this.type,
    required this.adminCode,
    required this.permissions,
    required this.invitedAdmins,
    required this.notifications,
    required this.lastNotification,
  });

  factory AdminPreview.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final name = json['name'];
    final surname = json['surname'];
    final email = json['email'];
    final type = json['type'];
    final adminCode = json['adminCode'];
    final permissions = json['permissions'];
    final invitedAdmins =
        (json['invitedAdmins'] != null
                ? json['invitedAdmins'] as List
                : List.empty())
            .map((e) => e.toString())
            .toList();
    final notifications =
        (json['notifications'] != null
                ? json['notifications'] as List
                : List.empty())
            .map((e) => NotificationPreview.fromJson(e))
            .toList();
    final lastNotification = json['lastNotification'];

    return AdminPreview(
      id: id,
      name: name,
      surname: surname,
      email: email,
      type: type,
      adminCode: adminCode,
      permissions: permissions,
      invitedAdmins: invitedAdmins,
      notifications: notifications,
      lastNotification: lastNotification,
    );
  }
}

class UserPreview {
  final String id;
  final String name;
  final String surname;
  final String email;
  final String type;
  final List<NotificationPreview> notifications;
  final String? oldestNotification;

  UserPreview({
    required this.id,
    required this.name,
    required this.surname,
    required this.email,
    required this.type,
    required this.notifications,
    required this.oldestNotification,
  });

  factory UserPreview.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final name = json['name'];
    final surname = json['surname'];
    final email = json['email'];
    final type = json['type'];
    final notifications =
        (json['notifications'] != null
                ? json['notifications'] as List
                : List.empty())
            .map((e) => NotificationPreview.fromJson(e))
            .toList();
    final oldestNotification =
        json['oldestNotification'] ?? json['lastNotification'];

    return UserPreview(
      id: id,
      name: name,
      surname: surname,
      email: email,
      type: type,
      notifications: notifications,
      oldestNotification: oldestNotification,
    );
  }

  factory UserPreview.fromCustomer(CustomerPreview customer) {
    return UserPreview(
      id: customer.id,
      name: customer.name,
      surname: customer.surname,
      email: customer.email,
      type: customer.type,
      notifications: customer.notifications,
      oldestNotification: customer.oldestNotification,
    );
  }

  factory UserPreview.fromAdmin(AdminPreview admin) {
    return UserPreview(
      id: admin.id,
      name: admin.name,
      surname: admin.surname,
      email: admin.email,
      type: admin.type,
      notifications: admin.notifications,
      oldestNotification: admin.lastNotification,
    );
  }
}
