import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/sensor_data.dart';

class SensorChart extends StatelessWidget {
  final int motionCount;
  final int vibrationCount;

  SensorChart({required this.motionCount, required this.vibrationCount});

  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
        sections: [
          PieChartSectionData(
            color: Colors.blue,
            value: motionCount.toDouble(),
            title: 'Motion',
            radius: 50,
            titleStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          PieChartSectionData(
            color: Colors.red,
            value: vibrationCount.toDouble(),
            title: 'Vibration',
            radius: 50,
            titleStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
