import 'package:sensors_plus/sensors_plus.dart';
import 'dart:async';
import '../models/sensor_data.dart';

class MotionDetectionService {
  late StreamSubscription<AccelerometerEvent> _accSubscription;

  void startListening(Function(SensorData) onData) {
    _accSubscription = accelerometerEvents.listen((AccelerometerEvent event) {
      onData(SensorData(
        timestamp: DateTime.now(),
        x: event.x,
        y: event.y,
        z: event.z,
      ));
    });
  }

  void stopListening() {
    _accSubscription.cancel();
  }
}
