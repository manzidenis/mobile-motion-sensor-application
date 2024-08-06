import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:async';
import 'dart:math';

class StepCounterScreen extends StatefulWidget {
  @override
  _StepCounterScreenState createState() => _StepCounterScreenState();
}

class _StepCounterScreenState extends State<StepCounterScreen> {
  int _stepCount = 0;
  StreamSubscription<UserAccelerometerEvent>? _subscription;
  double _previousMagnitude = 0.0;
  bool _isAboveThreshold = false;

  @override
  void initState() {
    super.initState();
    _startListening();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  void _startListening() {
    _subscription = userAccelerometerEvents.listen(
          (UserAccelerometerEvent event) {
        setState(() {
          _detectStep(event);
        });
      },
      onError: (error) {
        print('Error: $error');
      },
    );
  }

  void _detectStep(UserAccelerometerEvent event) {
    // Calculate the magnitude of the acceleration vector
    double magnitude = sqrt(event.x * event.x + event.y * event.y + event.z * event.z);

    // Threshold for step detection - this value may need to be adjusted based on real-world testing
    double threshold = 1.2;

    if (magnitude > threshold && !_isAboveThreshold) {
      // Detected a step
      _isAboveThreshold = true;
      _stepCount++;
    } else if (magnitude < threshold && _isAboveThreshold) {
      // Reset the flag when the magnitude drops below the threshold
      _isAboveThreshold = false;
    }
  }

  void _resetStepCount() {
    setState(() {
      _stepCount = 0; // Reset the displayed step count
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Step Counter'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _resetStepCount,
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Step Count:',
                style: TextStyle(fontSize: 24, color: Colors.black),
              ),
              Text(
                '$_stepCount',
                style: TextStyle(fontSize: 48, color: Colors.blue),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
