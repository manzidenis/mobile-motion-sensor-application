import 'package:flutter/material.dart';
import 'light_sensor_screen.dart';
import 'motion_detection_screen.dart';
import 'geofencing_screen.dart';
import 'step_counter_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Smart Home Monitoring',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.black,
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          padding: const EdgeInsets.all(16.0),
          children: [
            _buildGridItem(
              context,
              title: 'Light Level Sensing',
              icon: Icons.lightbulb_outline,
              color: Colors.blueGrey[800]!,
              onTap: () => _navigateTo(context, LightSensorScreen()),
            ),
            _buildGridItem(
              context,
              title: 'Motion Detection & Charts',
              icon: Icons.insert_chart_outlined,
              color: Colors.grey[800]!,
              onTap: () => _navigateTo(context, MotionDetectionScreen()),
            ),
            _buildGridItem(
              context,
              title: 'Step Counter',
              icon: Icons.directions_walk,
              color: Colors.grey[800]!,
              onTap: () => _navigateTo(context, StepCounterScreen()),
            ),
            _buildGridItem(
              context,
              title: 'Geofencing',
              icon: Icons.location_on,
              color: Colors.blueGrey[700]!,
              onTap: () => _navigateTo(context, GeofencingScreen()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridItem(BuildContext context, {required String title, required IconData icon, required Color color, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black45,
              offset: Offset(4, 4),
              blurRadius: 8,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.white),
            SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }
}
