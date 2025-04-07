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
  final String type;
  final String adminCode;
  final String permissions;
  final List<String> invitedAdmins;

  AdminPreview({
    required this.id,
    required this.name,
    required this.surname,
    required this.type,
    required this.adminCode,
    required this.permissions,
    required this.invitedAdmins,
  });

  factory AdminPreview.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final name = json['name'];
    final surname = json['surname'];
    final type = json['type'];
    final adminCode = json['adminCode'];
    final permissions = json['permissions'];
    final invitedAdmins =
        (json['invitedAdmins'] != null
                ? json['invitedAdmins'] as List
                : List.empty())
            .map((e) => e.toString())
            .toList();

    return AdminPreview(
      id: id,
      name: name,
      surname: surname,
      type: type,
      adminCode: adminCode,
      permissions: permissions,
      invitedAdmins: invitedAdmins,
    );
  }
}
