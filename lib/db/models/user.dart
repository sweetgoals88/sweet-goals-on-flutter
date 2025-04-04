class Customer {
  final String id;
  final String name;
  final String surname;
  final String email;
  final String type;
  final String encryptedPassword;
  final List<String> prototypes;

  Customer({
    required this.id,
    required this.name,
    required this.surname,
    required this.email,
    required this.type,
    required this.encryptedPassword,
    required this.prototypes,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'],
      name: json['name'],
      surname: json['surname'],
      email: json['email'],
      type: json['type'],
      encryptedPassword: json['encrypted_password'],
      prototypes: List<String>.from(json['prototypes']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'surname': surname,
      'email': email,
      'type': type,
      'encrypted_password': encryptedPassword,
      'prototypes': prototypes,
    };
  }
}

class Admin {
  final String id;
  final String name;
  final String surname;
  final String email;
  final String type;
  final String encryptedPassword;
  final String adminCode;
  final List<String> invitedAdmins;

  Admin({
    required this.id,
    required this.name,
    required this.surname,
    required this.email,
    required this.type,
    required this.encryptedPassword,
    required this.adminCode,
    required this.invitedAdmins,
  });

  factory Admin.fromJson(Map<String, dynamic> json) {
    return Admin(
      id: json['id'],
      name: json['name'],
      surname: json['surname'],
      email: json['email'],
      type: json['type'],
      encryptedPassword: json['encrypted_password'],
      adminCode: json['admin_code'],
      invitedAdmins: List<String>.from(json['invited_admins']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'surname': surname,
      'email': email,
      'type': type,
      'encrypted_password': encryptedPassword,
      'admin_code': adminCode,
      'invited_admins': invitedAdmins,
    };
  }
}

class CustomerPreview {
  final String id;
  final String name;
  final String surname;
  final String type;
  final int numberOfPrototypes;

  CustomerPreview({
    required this.id,
    required this.name,
    required this.surname,
    required this.type,
    required this.numberOfPrototypes,
  });

  factory CustomerPreview.fromJson(Map<String, dynamic> json) {
    return CustomerPreview(
      id: json['id'],
      name: json['name'],
      surname: json['surname'],
      type: json['type'],
      numberOfPrototypes: json['number_of_prototypes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'surname': surname,
      'type': type,
      'number_of_prototypes': numberOfPrototypes,
    };
  }
}

class AdminPreview {
  final String id;
  final String name;
  final String surname;
  final String type;
  final List<String> invitedAdmins;

  AdminPreview({
    required this.id,
    required this.name,
    required this.surname,
    required this.type,
    required this.invitedAdmins,
  });

  factory AdminPreview.fromJson(Map<String, dynamic> json) {
    return AdminPreview(
      id: json['id'],
      name: json['name'],
      surname: json['surname'],
      type: json['type'],
      invitedAdmins: List<String>.from(json['invited_admins']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'surname': surname,
      'type': type,
      'invited_admins': invitedAdmins,
    };
  }
}
