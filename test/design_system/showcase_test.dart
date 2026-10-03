import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumio/app/lumio_app.dart';
import 'package:lumio/core/config/app_config.dart';
import 'package:lumio/core/theme/lumio_motion.dart';
import 'package:lumio/features/dev/presentation/design_system_showcase.dart';

import '../support/profile_test_repository.dart';

void main() {
  test('production cannot enable the development showcase', () {
    const production = AppConfig(
      environment: AppEnvironment.production,
      enableDesignPreview: true,
    );
    expect(production.designPreviewEnabled, isFalse);
    expect(
      AppConfig.fromName(
        'development',
        enableDesignPreview: true,
      ).designPreviewEnabled,
      isTrue,
    );
  });

  for (final (size, scale, locale) in [
    (const Size(320, 568), 1.0, const Locale('en')),
    (const Size(390, 844), 1.0, const Locale('ms')),
    (const Size(430, 932), 2.0, const Locale('en')),
    (const Size(320, 568), 2.0, const Locale('ms')),
    (const Size(768, 1024), 2.0, const Locale('ms')),
    (const Size(1024, 768), 1.0, const Locale('en')),
  ]) {
    testWidgets('development showcase fits $size at $scale text in $locale', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(size);
      addTearDown(() => tester.binding.setSurfaceSize(null));
      tester.platformDispatcher.textScaleFactorTestValue = scale;
      tester.platformDispatcher.accessibilityFeaturesTestValue =
          FakeAccessibilityFeatures(disableAnimations: true);
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      addTearDown(
        tester.platformDispatcher.clearAccessibilityFeaturesTestValue,
      );
      await tester.pumpWidget(
        ProviderScope(
          overrides: [testProfileOverride(complete: true)],
          child: LumioApp(
            config: const AppConfig(
              environment: AppEnvironment.development,
              enableDesignPreview: true,
            ),
            locale: locale,
          ),
        ),
      );
      await tester.pump(LumioMotion.slow);
      await tester.pumpAndSettle();
      expect(find.byType(DesignSystemShowcase), findsOneWidget);
      expect(tester.widget<Switch>(find.byType(Switch)).onChanged, isNull);
      await tester.ensureVisible(
        find.text(
          locale.languageCode == 'ms'
              ? 'Ruang, bentuk & gerakan'
              : 'Space, shape & motion',
        ),
      );
      await tester.pump(LumioMotion.slow);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('production with preview flag uses real child selection', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [testProfileOverride(complete: true)],
        child: LumioApp(
          config: AppConfig(
            environment: AppEnvironment.production,
            enableDesignPreview: true,
          ),
          locale: Locale('en'),
        ),
      ),
    );
    await tester.pump(LumioMotion.slow);
    await tester.pumpAndSettle();
    expect(find.byType(DesignSystemShowcase), findsNothing);
    expect(find.text('Who’s exploring today?'), findsOneWidget);
  });
}
