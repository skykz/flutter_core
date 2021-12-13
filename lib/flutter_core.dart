import 'dart:async';
import 'package:flutter/services.dart';

/// test
class FlutterCore {
  static const MethodChannel _channel = const MethodChannel('flutter_core');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
