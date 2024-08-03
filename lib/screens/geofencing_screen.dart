import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'; // Import this for flutterLocalNotificationsPlugin
import '../services/geofencing_service.dart'; // Ensure this path is correct for your project

class GeofencingScreen extends StatefulWidget {
  @override
  _GeofencingScreenState createState() => _GeofencingScreenState();
}

class _GeofencingScreenState extends State<GeofencingScreen> {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  late final GeofencingService _geofencingService;
  final Completer<GoogleMapController> _mapController = Completer<GoogleMapController>();
  LatLng _kigaliCenter = LatLng(-1.9441, 30.0619); // Coordinates for Kigali center
  LatLng? _currentPosition;
  Map<PolygonId, Polygon> _polygons = {};

  @override
  void initState() {
    super.initState();
    _geofencingService = GeofencingService(_flutterLocalNotificationsPlugin);
    _geofencingService.onLocationUpdate = _onLocationUpdate;
    _geofencingService.startGeofencing();
    _createGeofence();
  }

  @override
  void dispose() {
    _geofencingService.stopGeofencing();
    super.dispose();
  }

  void _onLocationUpdate(LatLng newPosition) {
    setState(() {
      _currentPosition = newPosition;
    });
    _cameraToPosition(newPosition);
  }

  void _createGeofence() {
    List<LatLng> kigaliBoundaries = [
      LatLng(-1.9740, 30.0274), // Northwest corner
      LatLng(-1.9740, 30.1300), // Northeast corner
      LatLng(-1.8980, 30.1300), // Southeast corner
      LatLng(-1.8980, 30.0274), // Southwest corner
    ];

    PolygonId polygonId = PolygonId('kigali');
    Polygon polygon = Polygon(
      polygonId: polygonId,
      points: kigaliBoundaries,
      strokeWidth: 2,
      strokeColor: Colors.blue,
      fillColor: Colors.blue.withOpacity(0.3),
    );

    setState(() {
      _polygons[polygonId] = polygon;
    });
  }

  Future<void> _cameraToPosition(LatLng pos) async {
    final GoogleMapController controller = await _mapController.future;
    CameraPosition _newCameraPosition = CameraPosition(
      target: pos,
      zoom: 13,
    );
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(_newCameraPosition),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Geofencing'),
      ),
      body: _currentPosition == null
          ? const Center(child: Text("Loading..."))
          : GoogleMap(
        onMapCreated: (GoogleMapController controller) {
          _mapController.complete(controller);
        },
        initialCameraPosition: CameraPosition(
          target: _kigaliCenter,
          zoom: 13,
        ),
        mapType: MapType.hybrid, // Set the map type to hybrid
        polygons: Set<Polygon>.of(_polygons.values),
        markers: {
          if (_currentPosition != null)
            Marker(
              markerId: MarkerId("_currentLocation"),
              icon: BitmapDescriptor.defaultMarker,
              position: _currentPosition!,
            ),
        },
      ),
    );
  }
}
