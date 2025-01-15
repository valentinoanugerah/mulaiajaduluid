import 'package:cloud_firestore/cloud_firestore.dart';

class HealthMetric {
  DateTime date;
  double? heartRate;
  double? sleepDuration;
  double? caloriesBurned;
  int? steps;
  double? weight; // Tambahkan weight
  double? height; // Tambahkan height
  DateTime? sleepStartTime;

  HealthMetric({
    required this.date,
    this.heartRate,
    this.sleepDuration,
    this.caloriesBurned,
    this.steps,
    this.weight, // Tambahkan weight
    this.height, // Tambahkan height
    this.sleepStartTime,
  });

  factory HealthMetric.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    DateTime date = (data['date'] as Timestamp).toDate();
    DateTime? sleepStartTime;
    if (data['sleepStartTime'] != null) {
      sleepStartTime = (data['sleepStartTime'] as Timestamp).toDate();
    }

    return HealthMetric(
      date: date,
      heartRate: _getNonZeroDouble(data['heartRate']),
      sleepDuration: _getNonZeroDouble(data['sleepDuration']),
      caloriesBurned: _getNonZeroDouble(data['caloriesBurned']),
      steps: _getNonZeroInt(data['steps']),
      weight: _getNonZeroDouble(data['weight']), // Tambahkan weight
      height: _getNonZeroDouble(data['height']), // Tambahkan height
      sleepStartTime: sleepStartTime,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': Timestamp.fromDate(date),
      if (heartRate != null) 'heartRate': heartRate,
      if (sleepDuration != null) 'sleepDuration': sleepDuration,
      if (caloriesBurned != null) 'caloriesBurned': caloriesBurned,
      if (steps != null) 'steps': steps,
      if (weight != null) 'weight': weight, // Tambahkan weight
      if (height != null) 'height': height, // Tambahkan height
      if (sleepStartTime != null) 'sleepStartTime': Timestamp.fromDate(sleepStartTime!),
    };
  }

  static double? _getNonZeroDouble(dynamic value) {
    if (value == null) return null;
    double doubleValue = (value is int) ? value.toDouble() : value;
    return doubleValue == 0 ? null : doubleValue;
  }

  static int? _getNonZeroInt(dynamic value) {
    if (value == null) return null;
    int intValue = value is int ? value : value.toInt();
    return intValue == 0 ? null : intValue;
  }
}
