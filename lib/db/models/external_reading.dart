import 'package:prubea1app/db/models/prototype.dart';

class ExternalReadingPreview {
  final String id;
  final DateTime dateTime;
  final double light;
  final double temperature;
  final double current;
  final double voltage;
  final double wattage;
  final PanelSpecificationsPreview panelSpecifications;

  ExternalReadingPreview({
    required this.id,
    required this.dateTime,
    required this.light,
    required this.temperature,
    required this.current,
    required this.voltage,
    required this.wattage,
    required this.panelSpecifications,
  });

  factory ExternalReadingPreview.fromJson(Map<String, dynamic> json) {
    return ExternalReadingPreview(
      id: json['id'],
      dateTime: DateTime.parse(json['dateTime']),
      light: (json['light'] as num).toDouble(),
      temperature: (json['temperature'] as num).toDouble(),
      current: (json['current'] as num).toDouble(),
      voltage: (json['voltage'] as num).toDouble(),
      wattage: (json['wattage'] as num).toDouble(),
      panelSpecifications: PanelSpecificationsPreview.fromJson(
        json['panelSpecifications'],
      ),
    );
  }
}
