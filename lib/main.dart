import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'utils/notifications.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationUtils().initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Home Monitoring',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}
