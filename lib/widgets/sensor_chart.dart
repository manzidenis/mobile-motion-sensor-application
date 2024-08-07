import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class SensorChart extends StatelessWidget {
  final int motionCount;
  final int vibrationCount;

  SensorChart({required this.motionCount, required this.vibrationCount});

  @override
  Widget build(BuildContext context) {
    final int totalCount = motionCount + vibrationCount;

    return Column(
      children: [
        // Pie Chart wrapped in a fixed height container
        SizedBox(
          height: 250, // Specify a fixed height
          child: PieChart(
            PieChartData(
              centerSpaceRadius: 40,
              sectionsSpace: 2,
              sections: [
                PieChartSectionData(
                  color: Colors.blue,
                  value: motionCount.toDouble(),
                  title: '${(motionCount / totalCount * 100).toStringAsFixed(1)}%',
                  radius: 60,
                  titleStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                  badgeWidget: _Badge(
                    'assets/motion.png', // Replace with an appropriate icon
                    size: 24,
                    borderColor: Colors.blue,
                  ),
                  badgePositionPercentageOffset: .98,
                ),
                PieChartSectionData(
                  color: Colors.red,
                  value: vibrationCount.toDouble(),
                  title: '${(vibrationCount / totalCount * 100).toStringAsFixed(1)}%',
                  radius: 60,
                  titleStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                  badgeWidget: _Badge(
                    'assets/vibration.png', // Replace with an appropriate icon
                    size: 24,
                    borderColor: Colors.red,
                  ),
                  badgePositionPercentageOffset: .98,
                ),
              ],
              borderData: FlBorderData(show: false),
            ),
          ),
        ),
        SizedBox(height: 20),
        // Legend
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLegendItem(Colors.blue, 'Motion'),
            SizedBox(width: 10),
            _buildLegendItem(Colors.red, 'Vibration'),
          ],
        ),
      ],
    );
  }

  Widget _buildLegendItem(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          color: color,
        ),
        SizedBox(width: 4),
        Text(text, style: TextStyle(fontSize: 16)),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  final String iconPath;
  final double size;
  final Color borderColor;

  const _Badge(this.iconPath, {Key? key, required this.size, required this.borderColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: borderColor, width: 2),
      ),
      child: Center(
        child: Image.asset(
          iconPath,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
