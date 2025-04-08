import 'package:prubea1app/db/models/external_reading.dart';
import 'package:prubea1app/db/models/internal_reading.dart';

class PanelSpecificationsPreview {
  final int numberOfPanels;
  final int peakVoltage;
  final double temperatureRate;

  PanelSpecificationsPreview({
    required this.numberOfPanels,
    required this.peakVoltage,
    required this.temperatureRate,
  });

  factory PanelSpecificationsPreview.fromJson(Map<String, dynamic> json) {
    return PanelSpecificationsPreview(
      numberOfPanels: json['numberOfPanels'],
      peakVoltage: json['peakVoltage'],
      temperatureRate: json['temperatureRate'],
    );
  }
}

class UserCustomizationPreview {
  final double latitude;
  final double longitude;
  final String locationName;
  final String label;
  final String icon;

  UserCustomizationPreview({
    required this.latitude,
    required this.longitude,
    required this.locationName,
    required this.label,
    required this.icon,
  });

  factory UserCustomizationPreview.fromJson(Map<String, dynamic> json) {
    return UserCustomizationPreview(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      locationName: json['locationName'],
      label: json['label'],
      icon: json['icon'],
    );
  }
}

class PrototypePreview {
  final String id;
  final bool operational;
  final String versionId;
  final UserCustomizationPreview userCustomization;
  final PanelSpecificationsPreview panelSpecifications;
  final List<InternalReadingPreview> internalReadings;
  final List<ExternalReadingPreview> externalReadings;
  final String? oldestInternalReading;
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
    final id = json['id'];
    final operational = json['operational'] ?? false;
    final versionId = json['versionId'];
    print("After version id");
    final panelSpecifications = PanelSpecificationsPreview.fromJson(
      json['panelSpecifications'],
    );
    final userCustomization = UserCustomizationPreview.fromJson(
      json['userCustomization'],
    );
    print("After user customization");
    final internalReadings =
        (json['internalReadings'] != null
                ? json['internalReadings'] as List
                : List.empty())
            .map((e) => InternalReadingPreview.fromJson(e))
            .toList();
    final oldestInternalReading = json['oldestInternalReading'];
    final externalReadings =
        (json['externalReadings'] != null
                ? json['externalReadings'] as List
                : List.empty())
            .map((e) => ExternalReadingPreview.fromJson(e))
            .toList();
    final oldestExternalReading = json['oldestExternalReading'];

    return PrototypePreview(
      id: id,
      operational: operational,
      versionId: versionId,
      panelSpecifications: panelSpecifications,
      userCustomization: userCustomization,
      internalReadings: internalReadings,
      oldestInternalReading: oldestInternalReading,
      externalReadings: externalReadings,
      oldestExternalReading: oldestExternalReading,
    );
  }
}
