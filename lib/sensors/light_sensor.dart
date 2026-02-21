import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:light_sensor/light_sensor.dart';

class LightSensorController {
  StreamSubscription<int>? _subscription;

  // Notifier for dark mode state
  final ValueNotifier<bool> isDarkMode = ValueNotifier(false);
  // Notifier for current lux value (optional, can show in UI)
  final ValueNotifier<int> luxValue = ValueNotifier(0);
  // Notifier for sensor availability and errors
  final ValueNotifier<bool> isAvailable = ValueNotifier(false);
  final ValueNotifier<String?> error = ValueNotifier(null);
  // Smoothed lux and smoothing controls
  final ValueNotifier<double> smoothedLux = ValueNotifier(0.0);
  bool useSmoothing = true;
  double _ema = 0.0;
  double smoothingAlpha = 0.2; // 0..1, higher = more responsive
  int darkThreshold = 50; // lux threshold to decide dark mode

  /// Start listening to light sensor
  Future<void> startListening() async {
    // plugin supports Android only; check platform first
    if (!kIsWeb && Platform.isAndroid) {
      try {
        final bool has = await LightSensor.hasSensor();
        debugPrint('LightSensor.hasSensor: $has');
        isAvailable.value = has;
        if (!has) {
          error.value = 'No light sensor available on this device';
          return;
        }

        _subscription = LightSensor.luxStream().listen((lux) {
          luxValue.value = lux;
          // smoothing
          if (useSmoothing) {
            _ema = smoothingAlpha * lux + (1 - smoothingAlpha) * _ema;
            smoothedLux.value = _ema;
          } else {
            smoothedLux.value = lux.toDouble();
            _ema = lux.toDouble();
          }
          // Determine dark mode using smoothed value
          isDarkMode.value = smoothedLux.value < darkThreshold;
          debugPrint('LightSensor.lux -> $lux  smoothed=${smoothedLux.value.toStringAsFixed(1)} dark=${isDarkMode.value}');
        }, onError: (e, st) {
          error.value = e?.toString();
          debugPrint('LightSensor stream error: $e\n$st');
        });
      } catch (e, st) {
        error.value = e.toString();
        debugPrint('Failed to start LightSensor: $e\n$st');
      }
    } else {
      isAvailable.value = false;
      error.value = 'LightSensor is supported only on Android devices';
    }
  }

  /// Stop listening
  void stopListening() {
    _subscription?.cancel();
    _subscription = null;
  }
}

// Shared controller instance for app-wide usage
final LightSensorController lightSensorController = LightSensorController();