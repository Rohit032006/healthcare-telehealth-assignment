import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class LoggerService {
  const LoggerService._();
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      colors: true
    ),
  );
  static void log(dynamic message) {
    if (kDebugMode) {
      _logger.d(message);
    }
  }

  static void error(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      _logger.e(message, error: error, stackTrace: stackTrace);
    }
  }

  static void info(dynamic message) {
    if (kDebugMode) {
      _logger.i(message);
    }
  }
}
