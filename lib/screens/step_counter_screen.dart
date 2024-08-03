import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'dart:async'; // Import the dart:async library for StreamSubscription

class StepCounterScreen extends StatefulWidget {
  @override
  _StepCounterScreenState createState() => _StepCounterScreenState();
}

class _StepCounterScreenState extends State<StepCounterScreen> {
  int _stepCount = 0;
  StreamSubscription<StepCount>? _subscription; // Correct the type of StreamSubscription

  @override
  void initState() {
    super.initState();
    _startListening();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    // Reset step count when the screen is closed or navigated away
    setState(() {
      _stepCount = 0;
    });
    super.dispose();
  }

  void _startListening() {
    _subscription = Pedometer.stepCountStream.listen(
          (StepCount event) {
        setState(() {
          _stepCount = event.steps; // Access the steps property from StepCount
        });
      },
      onError: (error) {
        print('Error: $error');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Step Counter'),
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
