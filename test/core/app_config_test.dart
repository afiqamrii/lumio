import 'package:flutter_test/flutter_test.dart';
import 'package:lumio/core/config/app_config.dart';

void main() {
  test('accepts the three explicit environments', () {
    for (final environment in AppEnvironment.values) {
      expect(AppConfig.fromName(environment.name).environment, environment);
    }
  });

  test('production excludes profile sandbox and reset tools', () {
    final config = AppConfig.fromName('production');
    expect(config.profileSandboxEnabled, isFalse);
    expect(config.debugToolsEnabled, isFalse);
  });

  test('rejects typos instead of silently selecting development', () {
    expect(() => AppConfig.fromName('prodution'), throwsArgumentError);
    expect(() => AppConfig.fromName(''), throwsArgumentError);
  });
}
