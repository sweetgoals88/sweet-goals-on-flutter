class LocationOption {
  final double latitude;
  final double longitude;
  final String locationName;

  LocationOption({
    required this.latitude,
    required this.longitude,
    required this.locationName,
  });

  factory LocationOption.fromJson(Map<String, dynamic> json) {
    return LocationOption(
      latitude: json['latitude'],
      longitude: json['longitude'],
      locationName: json['locationName'],
    );
  }
}
