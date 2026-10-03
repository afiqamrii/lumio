import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

/// A replacement boundary for a future reviewed production logging service.
/// Callers supply fixed event names, never credentials or child data.
abstract interface class AppLogger {
  void error(String event, Object error, StackTrace stackTrace);
}

class DebugAppLogger implements AppLogger {
  const DebugAppLogger();

  @override
  void error(String event, Object error, StackTrace stackTrace) {
    if (kDebugMode) {
      developer.log(
        event,
        name: 'lumio',
        level: 1000,
        // Do not emit error messages that could contain sensitive values.
        error: error.runtimeType.toString(),
        stackTrace: stackTrace,
      );
    }
  }
}
