import 'dart:async';
import 'package:pedometer/pedometer.dart';

class PedometerService {
  late Stream<StepCount> _stepCountStream;

  Stream<int> getStepCountStream() {
    _stepCountStream = Pedometer.stepCountStream;
    return _stepCountStream.map((stepCount) => stepCount.steps);
  }
}
