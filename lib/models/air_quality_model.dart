class AirQualityModel {
  final Map<String, dynamic> hourly;

  AirQualityModel({required this.hourly});

  factory AirQualityModel.fromJson(Map<String, dynamic> json) {
    return AirQualityModel(
      hourly: json['hourly'],
    );
  }
}
