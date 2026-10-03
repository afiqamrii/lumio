import 'dart:ui' show SemanticsAction;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lumio/app/lumio_app.dart';
import 'package:lumio/core/config/app_config.dart';
import 'package:lumio/core/routing/app_router.dart';
import 'package:lumio/features/adventure/data/learning_world_catalog.dart';
import 'package:lumio/features/adventure/presentation/adventure_map_screen.dart';
import 'package:lumio/features/adventure/presentation/world_landing_screen.dart';
import 'package:lumio/features/child_home/presentation/child_home_screen.dart';
import 'package:lumio/features/profiles/application/profile_store.dart';
import 'package:lumio/features/profiles/presentation/child_unavailable_screen.dart';
import 'package:lumio/features/progression/domain/unlock_condition.dart';

import '../support/profile_test_repository.dart';

const _config = AppConfig(environment: AppEnvironment.development);

Future<ProviderContainer> _launch(
  WidgetTester tester, {
  Size size = const Size(390, 844),
  double textScale = 1,
}) async {
  await tester.binding.setSurfaceSize(size);
  tester.platformDispatcher.textScaleFactorTestValue = textScale;
  tester.platformDispatcher.accessibilityFeaturesTestValue =
      FakeAccessibilityFeatures(disableAnimations: true);
  addTearDown(() async {
    tester.platformDispatcher.clearTextScaleFactorTestValue();
    tester.platformDispatcher.clearAccessibilityFeaturesTestValue();
    await tester.binding.setSurfaceSize(null);
  });
  final repo = TestProfileRepository(complete: true, ids: ['phase4-child']);
  final container = ProviderContainer(
    overrides: [profileRepositoryProvider.overrideWithValue(repo)],
  );
  addTearDown(container.dispose);
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: const LumioApp(config: _config, locale: Locale('en')),
    ),
  );
  await tester.pumpAndSettle();
  return container;
}

void main() {
  test('catalog defines six stable, ordered, broadly open worlds', () {
    final worlds = LearningWorldCatalog.worlds;
    expect(worlds, hasLength(6));
    expect(worlds.map((world) => world.id).toSet(), hasLength(6));
    expect(
      worlds.map((world) => world.sortOrder),
      orderedEquals([0, 1, 2, 3, 4, 5]),
    );
    expect(
      worlds.map((world) => world.unlockCondition),
      everyElement(isA<AlwaysUnlocked>()),
    );
  });

  testWidgets('home uses active child and Continue opens the map', (
    tester,
  ) async {
    final container = await _launch(tester);
    final router = container.read(appRouterProvider(_config));
    router.go('/child/phase4-child/home');
    await tester.pumpAndSettle();

    expect(find.byType(ChildHomeScreen), findsOneWidget);
    expect(find.text('Hi, phase4-child!'), findsOneWidget);
    expect(find.text('Explore with Lumi'), findsOneWidget);

    await tester.ensureVisible(find.text('Explore with Lumi'));
    await tester.tap(find.text('Explore with Lumi'));
    await tester.pumpAndSettle();
    expect(find.byType(AdventureMapScreen), findsOneWidget);
    expect(
      router.routeInformationProvider.value.uri.path,
      '/child/phase4-child/adventure',
    );
  });

  testWidgets('map renders six accessible nodes and opens an unlocked world', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    final container = await _launch(tester);
    final router = container.read(appRouterProvider(_config));
    router.go('/child/phase4-child/adventure');
    await tester.pumpAndSettle();

    for (final world in LearningWorldCatalog.worlds) {
      expect(find.byKey(ValueKey('world-${world.id}')), findsOneWidget);
    }
    final numberNode = find.byKey(const ValueKey('world-number-kingdom'));
    final numberSemantics = find.bySemanticsLabel(
      RegExp(r'(Open, )?Number Kingdom, Mathematics(, Open)?'),
    );
    expect(numberSemantics, findsOneWidget);
    final nodeSemantics = tester.getSemantics(numberSemantics);
    expect(
      nodeSemantics.getSemanticsData().hasAction(SemanticsAction.tap),
      isTrue,
    );

    await tester.ensureVisible(numberNode);
    await tester.tap(find.text('Number Kingdom'));
    await tester.pumpAndSettle();
    expect(find.byType(WorldLandingScreen), findsOneWidget);
    expect(find.text('Number Kingdom'), findsOneWidget);
    expect(find.text('Start Adventure'), findsOneWidget);
    expect(
      GoRouterState.of(
        tester.element(find.byType(WorldLandingScreen)),
      ).uri.path,
      '/child/phase4-child/adventure/number-kingdom',
    );

    await tester.ensureVisible(find.text('Start Adventure'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Start Adventure'));
    await tester.pump();
    expect(find.text('Games are coming in a future phase.'), findsOneWidget);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.byType(AdventureMapScreen), findsOneWidget);
    semantics.dispose();
  });

  testWidgets('all core worlds, including Arabic Oasis, are accessible', (
    tester,
  ) async {
    final container = await _launch(tester);
    final router = container.read(appRouterProvider(_config));
    router.go('/child/phase4-child/adventure');
    await tester.pumpAndSettle();

    final arabicNode = find.byKey(const ValueKey('world-arabic-oasis'));
    await tester.ensureVisible(arabicNode);
    await tester.tap(find.text('Arabic Oasis'));
    await tester.pumpAndSettle();

    expect(find.byType(WorldLandingScreen), findsOneWidget);
    expect(find.text('Arabic Oasis'), findsOneWidget);
    expect(
      GoRouterState.of(
        tester.element(find.byType(WorldLandingScreen)),
      ).uri.path,
      '/child/phase4-child/adventure/arabic-oasis',
    );
  });

  testWidgets('missing child context returns a friendly recovery screen', (
    tester,
  ) async {
    final container = await _launch(tester);
    final router = container.read(appRouterProvider(_config));
    router.go('/child/removed-child/home');
    await tester.pumpAndSettle();

    expect(find.byType(ChildUnavailableScreen), findsOneWidget);
    expect(find.text('This profile isn’t available'), findsOneWidget);
    expect(find.text('Choose a child'), findsOneWidget);
  });

  for (final (size, scale) in [
    (const Size(320, 568), 2.0),
    (const Size(768, 1024), 1.0),
    (const Size(1024, 768), 1.0),
  ]) {
    testWidgets('adventure map fits $size at ${scale}x text', (tester) async {
      final container = await _launch(tester, size: size, textScale: scale);
      container
          .read(appRouterProvider(_config))
          .go('/child/phase4-child/adventure');
      await tester.pumpAndSettle();
      expect(find.byType(AdventureMapScreen), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
}
