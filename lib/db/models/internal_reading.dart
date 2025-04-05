import 'dart:ffi';

class InternalReading {
  final String id;
  final DateTime dateTime;
  final double humidity;
  final double temperature;

  InternalReading({
    required this.id,
    required this.dateTime,
    required this.humidity,
    required this.temperature,
  });

  factory InternalReading.fromJson(Map<String, dynamic> json) {
    return InternalReading(
      id: json['id'],
      dateTime: DateTime.parse(json['dateTime']),
      humidity: (json['humidity'] as num).toDouble(),
      temperature: (json['temperature'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dateTime': dateTime.toIso8601String(),
      'humidity': humidity,
      'temperature': temperature,
    };
  }
}
