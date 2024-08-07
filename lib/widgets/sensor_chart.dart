import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/sensor_data.dart';

class SensorChart extends StatelessWidget {
  final List<int> motionData;
  final List<int> vibrationData;

  SensorChart({required this.motionData, required this.vibrationData});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(show: true),
          borderData: FlBorderData(show: true),
          lineBarsData: [
            LineChartBarData(
              spots: _getDataPoints(motionData),
              isCurved: true,
              color: Colors.blue,
              dotData: FlDotData(show: true),
              belowBarData: BarAreaData(show: false),
            ),
            LineChartBarData(
              spots: _getDataPoints(vibrationData),
              isCurved: true,
              color: Colors.red,
              dotData: FlDotData(show: true),
              belowBarData: BarAreaData(show: false),
            ),
          ],
          lineTouchData: LineTouchData(enabled: true),
        ),
      ),
    );
  }

  List<FlSpot> _getDataPoints(List<int> data) {
    return data.asMap().entries.map((entry) {
      int index = entry.key;
      int value = entry.value;
      return FlSpot(index.toDouble(), value.toDouble());
    }).toList();
  }
}
