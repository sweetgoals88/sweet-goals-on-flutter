class InternalReadingPreview {
  final String id;
  final DateTime dateTime;
  final double humidity;
  final double temperature;

  InternalReadingPreview({
    required this.id,
    required this.dateTime,
    required this.humidity,
    required this.temperature,
  });

  factory InternalReadingPreview.fromJson(Map<String, dynamic> json) {
    return InternalReadingPreview(
      id: json['id'],
      dateTime: DateTime.parse(json['dateTime']),
      humidity: (json['humidity'] as num).toDouble(),
      temperature: (json['temperature'] as num).toDouble(),
    );
  }
}
