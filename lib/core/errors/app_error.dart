import 'package:flutter/foundation.dart';

/// Internal classification; translate a safe message in the presentation layer.
/// Never store credentials, personal data or raw server responses here.
@immutable
class AppError implements Exception {
  const AppError({required this.code});

  final String code;

  @override
  String toString() => 'AppError($code)';
}
