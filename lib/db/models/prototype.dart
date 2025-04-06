import 'package:prubea1app/db/models/external_reading.dart';
import 'package:prubea1app/db/models/internal_reading.dart';

class PanelSpecifications {
  final int numberOfPanels;
  final int peakVoltage;
  final double temperatureRate;

  PanelSpecifications({
    required this.numberOfPanels,
    required this.peakVoltage,
    required this.temperatureRate,
  });

  factory PanelSpecifications.fromJson(Map<String, dynamic> json) {
    return PanelSpecifications(
      numberOfPanels: json['number_of_panels'],
      peakVoltage: json['peak_voltage'],
      temperatureRate: json['temperature_rate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'number_of_panels': numberOfPanels,
      'peak_voltage': peakVoltage,
      'temperature_rate': temperatureRate,
    };
  }
}

class UserCustomization {
  final double latitude;
  final double longitude;
  final String label;
  final String icon;

  UserCustomization({
    required this.latitude,
    required this.longitude,
    required this.label,
    required this.icon,
  });

  factory UserCustomization.fromJson(Map<String, dynamic> json) {
    return UserCustomization(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      label: json['label'],
      icon: json['icon'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'label': label,
      'icon': icon,
    };
  }
}

class Prototype {
  final String id;
  final String key;
  final bool active;
  final bool operational;
  final String activationCode;
  final List<String> externalReadings;
  final List<String> internalReadings;
  final String versionId;
  final UserCustomization userCustomization;
  final PanelSpecifications panelSpecifications;

  Prototype({
    required this.id,
    required this.key,
    required this.active,
    required this.operational,
    required this.activationCode,
    required this.externalReadings,
    required this.internalReadings,
    required this.versionId,
    required this.userCustomization,
    required this.panelSpecifications,
  });

  factory Prototype.fromJson(Map<String, dynamic> json) {
    return Prototype(
      id: json['id'],
      key: json['key'],
      active: json['active'],
      operational: json['operational'],
      activationCode: json['activation_code'],
      externalReadings: List.from(json['internal_readings']),
      internalReadings: List.from(json['internal_readings']),
      versionId: json['version_id'],
      userCustomization: UserCustomization.fromJson(json['userCustomization']),
      panelSpecifications: PanelSpecifications.fromJson(
        json['panelSpecifications'],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'key': key,
      'active': active,
      'operational': operational,
      'activation_code': activationCode,
      'external_readings': externalReadings,
      'internal_readings': internalReadings,
      'version_id': versionId,
      'userCustomization': userCustomization.toJson(),
      'panelSpecifications': panelSpecifications.toJson(),
    };
  }
}

class PrototypePreview {
  final String id;
  final bool operational;
  final String versionId;
  final PanelSpecifications panelSpecifications;
  final UserCustomization userCustomization;
  final List<InternalReading> internalReadings;
  final String? oldestInternalReading;
  final List<ExternalReading> externalReadings;
  final String? oldestExternalReading;

  PrototypePreview({
    required this.id,
    required this.operational,
    required this.versionId,
    required this.panelSpecifications,
    required this.userCustomization,
    required this.internalReadings,
    required this.oldestInternalReading,
    required this.externalReadings,
    required this.oldestExternalReading,
  });

  factory PrototypePreview.fromJson(Map<String, dynamic> json) {
    return PrototypePreview(
      id: json['id'],
      operational: json['operational'],
      versionId: json['version_id'],
      panelSpecifications: PanelSpecifications.fromJson(
        json['panelSpecifications'],
      ),
      userCustomization: UserCustomization.fromJson(json['userCustomization']),
      internalReadings:
          (json['internalReadings'] as List)
              .map((e) => InternalReading.fromJson(e))
              .toList(),
      oldestInternalReading: json['oldestInternalReading'],
      externalReadings:
          (json['externalReadings'] as List)
              .map((e) => ExternalReading.fromJson(e))
              .toList(),
      oldestExternalReading: json['oldestExternalReading'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'operational': operational,
      'version_id': versionId,
      'panelSpecifications': panelSpecifications.toJson(),
      'userCustomization': userCustomization.toJson(),
      'internalReadings': internalReadings.map((e) => e.toJson()).toList(),
      'oldestInternalReading': oldestInternalReading,
      'externalReadings': externalReadings.map((e) => e.toJson()).toList(),
      'oldestExternalReading': oldestExternalReading,
    };
  }
}
