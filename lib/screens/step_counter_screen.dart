import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'dart:async';

class StepCounterScreen extends StatefulWidget {
  @override
  _StepCounterScreenState createState() => _StepCounterScreenState();
}

class _StepCounterScreenState extends State<StepCounterScreen> {
  int _stepCount = 0;
  int _initialStepCount = 0; // Store the step count at start
  StreamSubscription<StepCount>? _subscription;

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
    _subscription = Pedometer.stepCountStream.listen(
          (StepCount event) {
        setState(() {
          if (_initialStepCount == 0) {
            // Set initial step count if it's not set
            _initialStepCount = event.steps;
          }
          // Calculate displayed step count based on the initial step count
          _stepCount = event.steps - _initialStepCount;
        });
      },
      onError: (error) {
        print('Error: $error');
      },
    );
  }

  void _resetStepCount() {
    print("Resetting step count");
    _subscription?.cancel();
    setState(() {
      _initialStepCount = 0; // Reset the initial step count
      _stepCount = 0; // Reset the displayed step count
    });
    _startListening();
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