import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumio/app/lumio_app.dart';
import 'package:lumio/core/config/app_config.dart';
import 'package:lumio/core/routing/app_router.dart';
import 'package:lumio/features/child_home/presentation/child_rewards_screen.dart';
import 'package:lumio/features/profiles/application/profile_store.dart';
import 'package:lumio/features/progression/application/progression_store.dart';
import 'package:lumio/features/progression/data/memory_progression_repository.dart';
import 'package:lumio/features/progression/domain/progression_models.dart';

import '../support/profile_test_repository.dart';

const _config = AppConfig(environment: AppEnvironment.development);

MissionCompletion _mission({
  required String event,
  required String child,
  required String mission,
  int stars = 3,
}) => MissionCompletion(
  eventId: event,
  childId: child,
  missionId: mission,
  worldId: 'number-kingdom',
  starsEarned: stars,
  completedAt: DateTime.utc(2026, 9, 27),
);

Future<ProviderContainer> _launch(
  WidgetTester tester,
  MemoryProgressionRepository progression,
) async {
  final profiles = TestProfileRepository(
    complete: true,
    ids: const ['child-a', 'child-b'],
  );
  final container = ProviderContainer(
    overrides: [
      profileRepositoryProvider.overrideWithValue(profiles),
      progressionRepositoryProvider.overrideWithValue(progression),
    ],
  );
  addTearDown(container.dispose);
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: const LumioApp(config: _config, locale: Locale('en')),
    ),
  );
  await container.read(profileStoreProvider.future);
  await tester.pump(const Duration(seconds: 1));
  await tester.pumpAndSettle();
  return container;
}

void main() {
  testWidgets('Home and Rewards show the active child progression', (
    tester,
  ) async {
    final progression = MemoryProgressionRepository();
    for (var index = 0; index < 5; index++) {
      await progression.completeMission(
        _mission(event: 'a$index', child: 'child-a', mission: 'm$index'),
      );
    }
    final container = await _launch(tester, progression);
    final router = container.read(appRouterProvider(_config));

    router.go('/child/child-a/home');
    await tester.pumpAndSettle();
    expect(
      router.routeInformationProvider.value.uri.path,
      '/child/child-a/home',
    );
    expect(find.text('Explore with Lumi'), findsOneWidget);
    expect(find.text('Level 2'), findsOneWidget);
    expect(find.text('15 stars'), findsOneWidget);
    expect(find.text('25 coins'), findsOneWidget);

    router.go('/child/child-a/rewards');
    await tester.pumpAndSettle();
    expect(find.byType(ChildRewardsScreen), findsOneWidget);
    expect(find.text('Level 2'), findsOneWidget);
    expect(find.text('15'), findsOneWidget);
    expect(find.text('25'), findsOneWidget);

    router.go('/child/child-b/rewards');
    await tester.pumpAndSettle();
    expect(find.text('Level 1'), findsOneWidget);
    expect(find.text('0'), findsNWidgets(2));

    router.go('/child/child-a/rewards');
    await tester.pumpAndSettle();
    expect(find.text('Level 2'), findsOneWidget);
    expect(find.text('15'), findsOneWidget);
  });

  testWidgets('debug simulator processes mission and ignores duplicate event', (
    tester,
  ) async {
    final progression = MemoryProgressionRepository();
    final container = await _launch(tester, progression);
    container.read(appRouterProvider(_config)).go('/child/child-a/rewards');
    await tester.pumpAndSettle();

    expect(
      container
          .read(appRouterProvider(_config))
          .routeInformationProvider
          .value
          .uri
          .path,
      '/child/child-a/rewards',
    );
    expect(find.byType(DebugProgressionSimulator), findsOneWidget);
    await tester.ensureVisible(find.text('Complete Mission'));
    await tester.tap(find.text('Complete Mission'));
    await tester.pumpAndSettle();
    expect(find.text('New achievement!'), findsOneWidget);
    expect(find.text('First Glow'), findsWidgets);
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('progression-result')), findsOneWidget);
    expect((await progression.loadChild('child-a')).progress.stars, 1);

    await tester.ensureVisible(find.text('Retry Same Event'));
    await tester.tap(find.text('Retry Same Event'));
    await tester.pumpAndSettle();
    expect(
      find.text('Duplicate event ignored — no rewards were added.'),
      findsOneWidget,
    );
    expect((await progression.loadChild('child-a')).progress.stars, 1);
  });

  testWidgets('level-up presentation appears and reduced motion stays usable', (
    tester,
  ) async {
    tester.platformDispatcher.accessibilityFeaturesTestValue =
        FakeAccessibilityFeatures(disableAnimations: true);
    addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);
    final progression = MemoryProgressionRepository();
    for (var index = 0; index < 4; index++) {
      await progression.completeMission(
        _mission(
          event: 'seed$index',
          child: 'child-a',
          mission: 'seed-mission-$index',
        ),
      );
    }
    final container = await _launch(tester, progression);
    container.read(appRouterProvider(_config)).go('/child/child-a/rewards');
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Complete Mission'));
    await tester.tap(find.text('Complete Mission'));
    await tester.pumpAndSettle();

    expect(find.text('Level up! You reached Level 2'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
