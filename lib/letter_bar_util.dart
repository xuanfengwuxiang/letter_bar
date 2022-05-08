
import 'dart:async';

import 'package:flutter/services.dart';

class LetterBarUtil {
  static const MethodChannel _channel = MethodChannel('letter_bar');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
