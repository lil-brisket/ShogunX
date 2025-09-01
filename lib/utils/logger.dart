import 'package:flutter/foundation.dart';

class Logger {
  static const String _tag = '[NinjaWorld]';
  
  static void info(String message) {
    if (kDebugMode) {
      print('$_tag [INFO] $message');
    }
  }
  
  static void success(String message) {
    if (kDebugMode) {
      print('$_tag [✅] $message');
    }
  }
  
  static void error(String message) {
    if (kDebugMode) {
      print('$_tag [❌] $message');
    }
  }
  
  static void warning(String message) {
    if (kDebugMode) {
      print('$_tag [⚠️] $message');
    }
  }
  
  static void debug(String message) {
    if (kDebugMode) {
      print('$_tag [DEBUG] $message');
    }
  }
}
