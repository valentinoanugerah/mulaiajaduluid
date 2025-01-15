import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/air_quality_model.dart';  // Sesuaikan path model

class AirQualityService {
  static const String _baseUrl = 'https://air-quality-api.open-meteo.com/v1/air-quality';

  Future<AirQualityModel> getAirQuality(double latitude, double longitude) async {
    final response = await http.get(
      Uri.parse('$_baseUrl?latitude=$latitude&longitude=$longitude&hourly=pm10,pm2_5'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // Periksa apakah data yang diterima valid
      if (data != null && data.containsKey('hourly')) {
        return AirQualityModel.fromJson(data);
      } else {
        throw Exception('Invalid data structure');
      }
    } else {
      throw Exception('Failed to load air quality data');
    }
  }
}
