import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumio/app/lumio_app.dart';
import 'package:lumio/core/config/app_config.dart';
import 'package:lumio/core/routing/app_router.dart';
import 'package:lumio/core/theme/lumio_motion.dart';
import 'package:lumio/core/widgets/lumio_logo.dart';

import 'support/profile_test_repository.dart';

const config = AppConfig(environment: AppEnvironment.development);

void main() {
  testWidgets('boots the router and renders the English branded shell', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [testProfileOverride(complete: false)],
        child: LumioApp(config: config, locale: Locale('en')),
      ),
    );
    await tester.pump(LumioMotion.slow);
    await tester.pumpAndSettle();
    expect(find.text('A bright start\nto big ideas.'), findsOneWidget);
    expect(find.text('A bright start\nto big ideas.'), findsWidgets);
    expect(find.text('A product by Nexura Labs.'), findsNothing);
    final image = tester.widget<LumioLogo>(find.byType(LumioLogo));
    expect(image.semanticLabel, 'Lumio');
    expect(tester.takeException(), isNull);
  });

  testWidgets('resolves Bahasa Melayu from the device locale', (tester) async {
    tester.platformDispatcher.localesTestValue = const [Locale('ms', 'MY')];
    addTearDown(tester.platformDispatcher.clearLocalesTestValue);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [testProfileOverride(complete: false)],
        child: LumioApp(config: config),
      ),
    );
    await tester.pump(LumioMotion.slow);
    await tester.pumpAndSettle();
    expect(find.text('Langkah kecil.\nIdea besar.'), findsOneWidget);
    expect(find.text('Langkah kecil.\nIdea besar.'), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  for (final size in [
    const Size(320, 568),
    const Size(1024, 768),
    const Size(768, 1024),
    const Size(568, 320),
  ]) {
    testWidgets('shell fits $size with 200% text and reduced motion', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(size);
      addTearDown(() => tester.binding.setSurfaceSize(null));
      tester.platformDispatcher.textScaleFactorTestValue = 2;
      tester.platformDispatcher.accessibilityFeaturesTestValue =
          FakeAccessibilityFeatures(disableAnimations: true);
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      addTearDown(
        tester.platformDispatcher.clearAccessibilityFeaturesTestValue,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [testProfileOverride(complete: false)],
          child: LumioApp(config: config, locale: Locale('ms')),
        ),
      );
      await tester.pump(LumioMotion.slow);
      await tester.pumpAndSettle();
      expect(find.text('Langkah kecil.\nIdea besar.'), findsWidgets);
      expect(find.text('Produk oleh Nexura Labs.'), findsNothing);
      await tester.ensureVisible(find.text('Mulakan'));
      await tester.pump(LumioMotion.slow);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('unmatched route provides a working accessible return action', (
    tester,
  ) async {
    final container = ProviderContainer(
      overrides: [testProfileOverride(complete: false)],
    );
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const LumioApp(config: config, locale: Locale('en')),
      ),
    );
    await tester.pump(LumioMotion.slow);
    await tester.pumpAndSettle();
    container.read(appRouterProvider(config)).go('/missing');
    await tester.pump(LumioMotion.slow);
    await tester.pumpAndSettle();
    expect(find.text('This page could not be found.'), findsOneWidget);

    final semantics = tester.ensureSemantics();

    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    await expectLater(tester, meetsGuideline(textContrastGuideline));

    await tester.tap(find.text('Back to Lumio'));
    await tester.pump(LumioMotion.slow);
    await tester.pumpAndSettle();
    expect(find.text('A bright start\nto big ideas.'), findsWidgets);
    expect(tester.takeException(), isNull);
    semantics.dispose();
    // Unmount before the externally owned container is disposed.
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
