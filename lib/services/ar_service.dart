import 'package:flutter/services.dart';

class ARService {
  static const MethodChannel _channel = MethodChannel('ar_service');

  static Future<bool> isARCoreSupported() async {
    try {
      final bool? result = await _channel.invokeMethod('checkARCoreSupport');
      return result ?? false;
    } catch (e) {
      print("ARCore check error: $e");
      return false;
    }
  }

  static Future<void> openARCorePlayStore() async {
    try {
      await _channel.invokeMethod('openARCorePlayStore');
    } catch (e) {
      print("Failed to open Play Store: $e");
    }
  }
}