import 'package:flutter/foundation.dart';

enum AppEnvironment { development, staging, production }

@immutable
class AppConfig {
  const AppConfig({
    required this.environment,
    this.enableDesignPreview = false,
    this.enableNavigationPreview = false,
  });

  factory AppConfig.fromEnvironment() => AppConfig.fromName(
    const String.fromEnvironment('LUMIO_ENV', defaultValue: 'development'),
    enableDesignPreview: const bool.fromEnvironment(
      'LUMIO_DESIGN_PREVIEW',
      defaultValue: false,
    ),
    enableNavigationPreview: const bool.fromEnvironment(
      'LUMIO_NAVIGATION_PREVIEW',
      defaultValue: false,
    ),
  );

  factory AppConfig.fromName(
    String name, {
    bool enableDesignPreview = false,
    bool enableNavigationPreview = false,
  }) {
    final environment = switch (name) {
      'development' => AppEnvironment.development,
      'staging' => AppEnvironment.staging,
      'production' => AppEnvironment.production,
      _ => throw ArgumentError.value(name, 'LUMIO_ENV', 'Unknown environment'),
    };
    return AppConfig(
      environment: environment,
      enableDesignPreview: enableDesignPreview,
      enableNavigationPreview: enableNavigationPreview,
    );
  }

  final AppEnvironment environment;
  final bool enableDesignPreview;
  final bool enableNavigationPreview;

  bool get debugToolsEnabled =>
      kDebugMode && environment != AppEnvironment.production;

  /// Fixed alternate file for safe development reset testing; never release.
  bool get profileSandboxEnabled =>
      debugToolsEnabled && const bool.fromEnvironment('LUMIO_PROFILE_SANDBOX');

  // No development route is registered in release/profile or production.
  bool get designPreviewEnabled =>
      kDebugMode &&
      environment != AppEnvironment.production &&
      enableDesignPreview;
  bool get navigationPreviewEnabled =>
      kDebugMode &&
      environment != AppEnvironment.production &&
      enableNavigationPreview;
}
