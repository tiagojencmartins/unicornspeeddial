import 'dart:async';

import 'package:flutter/services.dart';

class Unicorndialer {
  static const MethodChannel _channel =
      const MethodChannel('unicorndialer');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
