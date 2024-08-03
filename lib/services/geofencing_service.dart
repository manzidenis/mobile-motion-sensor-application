import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class GeofencingService {
  final Location _locationController = Location();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  final List<LatLng> _kigaliBoundaries = [
    LatLng(-1.9740, 30.0274), // Northwest corner
    LatLng(-1.9740, 30.1300), // Northeast corner
    LatLng(-1.8980, 30.1300), // Southeast corner
    LatLng(-1.8980, 30.0274), // Southwest corner
  ];

  LatLng? _currentPosition;
  StreamSubscription<LocationData>? _locationSubscription;
  bool _notificationSentOutside = false;
  bool _notificationSentInside = false;
  Function(LatLng)? onLocationUpdate;

  GeofencingService(this.flutterLocalNotificationsPlugin);

  void startGeofencing() {
    _startLocationUpdates();
  }

  void stopGeofencing() {
    _locationSubscription?.cancel();
  }

  void _startLocationUpdates() async {
    _locationSubscription = _locationController.onLocationChanged.listen((LocationData currentLocation) {
      if (currentLocation.latitude != null && currentLocation.longitude != null) {
        LatLng newLocation = LatLng(currentLocation.latitude!, currentLocation.longitude!);
        _currentPosition = newLocation;
        onLocationUpdate?.call(newLocation);

        bool insideGeofence = _isLocationInsideGeofence(currentLocation.latitude!, currentLocation.longitude!);

        if (insideGeofence && !_notificationSentInside) {
          _triggerInsideNotification();
        } else if (!insideGeofence && !_notificationSentOutside) {
          _triggerOutsideNotification();
        }
      }
    });
  }

  bool _isLocationInsideGeofence(double latitude, double longitude) {
    bool isInside = false;
    int i, j = _kigaliBoundaries.length - 1;
    for (i = 0; i < _kigaliBoundaries.length; i++) {
      if ((_kigaliBoundaries[i].latitude < latitude && _kigaliBoundaries[j].latitude >= latitude ||
          _kigaliBoundaries[j].latitude < latitude && _kigaliBoundaries[i].latitude >= latitude) &&
          (_kigaliBoundaries[i].longitude <= longitude || _kigaliBoundaries[j].longitude <= longitude)) {
        if (_kigaliBoundaries[i].longitude +
            (latitude - _kigaliBoundaries[i].latitude) /
                (_kigaliBoundaries[j].latitude - _kigaliBoundaries[i].latitude) *
                (_kigaliBoundaries[j].longitude - _kigaliBoundaries[i].longitude) <
            longitude) {
          isInside = !isInside;
        }
      }
      j = i;
    }
    return isInside;
  }

  void _triggerInsideNotification() async {
    if (!_notificationSentInside) {
      const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'Map_channel',
        'Map Notifications',
        importance: Importance.max,
        priority: Priority.high,
      );
      const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.show(
        0,
        'Hello!',
        'Inside Geographical Boundaries of Kigali',
        platformChannelSpecifics,
      );
      print('Inside geofence notification sent');
      _notificationSentInside = true;
      _notificationSentOutside = false;
    }
  }

  void _triggerOutsideNotification() async {
    if (!_notificationSentOutside) {
      const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'Map_channel',
        'Map Notifications',
        importance: Importance.max,
        priority: Priority.high,
      );
      const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.show(
        0,
        'Hello!',
        'Outside Geographical Boundaries of Kigali',
        platformChannelSpecifics,
      );
      print('Outside geofence notification sent');
      _notificationSentOutside = true;
      _notificationSentInside = false;
    }
  }
}
