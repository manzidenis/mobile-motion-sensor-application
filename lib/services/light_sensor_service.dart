import 'package:light/light.dart';
import 'dart:async';

class LightSensorService {
  Light _light = Light();
  StreamSubscription<int>? _lightSubscription;

  void startListening(Function(double) onData) {
    _lightSubscription = _light.lightSensorStream.listen((int lux) {
      onData(lux.toDouble());
    });
  }

  void stopListening() {
    _lightSubscription?.cancel();
  }
}
