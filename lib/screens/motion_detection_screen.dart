import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:async';
import 'dart:math'; // Import the dart:math library for sqrt
import '../widgets/sensor_chart.dart';
import '../models/sensor_data.dart';
import '../utils/notifications.dart';
import '../services/motion_detection_service.dart';

class MotionDetectionScreen extends StatefulWidget {
  @override
  _MotionDetectionScreenState createState() => _MotionDetectionScreenState();
}

class _MotionDetectionScreenState extends State<MotionDetectionScreen> {
  late MotionDetectionService _motionDetectionService;
  late NotificationUtils _notificationUtils;
  List<SensorData> _accelerometerData = [];
  final int _dataLimit = 50;
  DateTime? _lastNotificationTime;

  @override
  void initState() {
    super.initState();
    _motionDetectionService = MotionDetectionService();
    _notificationUtils = NotificationUtils();
    _notificationUtils.initialize();
    _motionDetectionService.startListening(_onSensorDataReceived);
  }

  @override
  void dispose() {
    _motionDetectionService.stopListening();
    super.dispose();
  }

  void _onSensorDataReceived(SensorData data) {
    setState(() {
      if (_accelerometerData.length >= _dataLimit) {
        _accelerometerData.removeAt(0);
      }
      _accelerometerData.add(data);

      final detectionResult = _detectMotionType(data);
      final now = DateTime.now();

      if (detectionResult == 'motion' && ( _lastNotificationTime == null || now.difference(_lastNotificationTime!).inSeconds > 30)) {
        _notificationUtils.showNotification(
          'Motion Detected',
          'Significant motion detected in your home.',
        );
        _lastNotificationTime = now;
      }
    });
  }

  String? _detectMotionType(SensorData data) {
    double magnitude = sqrt(data.x * data.x + data.y * data.y + data.z * data.z);

    // Adjust the threshold based on real-world testing
    if (magnitude > 1.5) {
      // Detected body movement
      return 'motion';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Motion Detection'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: SensorChart(data: _accelerometerData),
              ),
              SizedBox(height: 20),
              Text(
                'Motion detected',
                style: TextStyle(fontSize: 24, color: Colors.red),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
