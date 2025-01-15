import 'package:cloud_firestore/cloud_firestore.dart';

class HealthMetric {
  final Timestamp day;
  final List<double>? heartRate; // Ubah menjadi List<double>
  final double? sleep;
  final double? calories;

  HealthMetric({
    required this.day,
    this.heartRate,
    this.sleep,
    this.calories,
  });

  factory HealthMetric.fromFirestore(DocumentSnapshot doc) {
    var data = doc.data() as Map<String, dynamic>;
    
    // Parsing heart_rate menjadi List<double>
    List<double>? heartRateList = (data['heart_rate'] as List<dynamic>?)
        ?.map((e) => (e as num).toDouble())
        .toList();

    return HealthMetric(
      day: data['date'] as Timestamp,
      heartRate: heartRateList,
      sleep: data['sleep_duration']?.toDouble(),
      calories: data['calories_burned']?.toDouble(),
    );
  }

  bool get hasHeartRate => heartRate != null && heartRate!.isNotEmpty;
  bool get hasSleep => sleep != null;
  bool get hasCalories => calories != null;

  double get heartRateValue {
    if (heartRate != null && heartRate!.isNotEmpty) {
      // Menghitung rata-rata heart rate
      return heartRate!.reduce((a, b) => a + b) / heartRate!.length;
    }
    return 0;
  }

  double get sleepValue => sleep ?? 0;
  double get caloriesValue => calories ?? 0;

  String get formattedDay {
    DateTime date = day.toDate();
    return '${date.day}/${date.month}/${date.year}';
  }
}