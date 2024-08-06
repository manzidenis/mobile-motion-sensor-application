import 'dart:async';
import 'package:flutter/material.dart';
import '../services/light_sensor_service.dart';
import '../utils/notifications.dart';
import '../widgets/sensor_data_display.dart';

class LightSensorScreen extends StatefulWidget {
@override
_LightSensorScreenState createState() => _LightSensorScreenState();
}

class _LightSensorScreenState extends State<LightSensorScreen> {
late LightSensorService _lightSensorService;
late NotificationUtils _notificationUtils;
double _lightLevel = 0.0;
double _previousLightLevel = 0.0;
String _warningMessage = '';

@override
void initState() {
super.initState();
_lightSensorService = LightSensorService();
_notificationUtils = NotificationUtils();
_notificationUtils.initialize();
_lightSensorService.startListening(_onLightDataReceived);
}

@override
void dispose() {
_lightSensorService.stopListening();
super.dispose();
}

void _onLightDataReceived(double lux) {
setState(() {
_lightLevel = lux;
});
_handleLightLevelChange();
}

void _handleLightLevelChange() {
if (_lightLevel <= 30 && _previousLightLevel > 30) {
setState(() {
_warningMessage = "Warning, light level is low";
});
} else if (_lightLevel > 30 && _previousLightLevel <= 30) {
setState(() {
_warningMessage = '';
});
} else if (_lightLevel > 90 && _previousLightLevel <= 90) {
setState(() {
_warningMessage = "Light level is very high";
});
} else if (_lightLevel <= 90 && _previousLightLevel > 90) {
setState(() {
_warningMessage = '';
});
}
_previousLightLevel = _lightLevel;
}

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: Text('Light Level Sensing'),
backgroundColor: Colors.white,
),
body: Container(
color: Colors.black,
child: Center(
child: Column(
mainAxisSize: MainAxisSize.min,
children: [
Card(
color: Colors.blueGrey[800],
elevation: 10,
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(12),
),
child: Padding(
padding: const EdgeInsets.all(24.0),
child: Column(
mainAxisSize: MainAxisSize.min,
children: [
Icon(Icons.lightbulb_outline, size: 100, color: Colors.yellow),
SizedBox(height: 24),
SensorDataDisplay(
label: 'Light Level',
value: '${_lightLevel.toStringAsFixed(0)} %',
),
],
),
),
),
SizedBox(height: 24),
Text(
_warningMessage,
style: TextStyle(
color: Colors.red,
fontSize: 16,
fontWeight: FontWeight.bold,
),
),
],
),
),
),
);
}
}