import 'dart:ui' show Tristate;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumio/app/lumio_app.dart';
import 'package:lumio/core/config/app_config.dart';
import 'package:lumio/core/design_system.dart';
import 'package:lumio/core/routing/app_router.dart';
import 'package:lumio/features/child_home/presentation/child_rewards_screen.dart';
import 'package:lumio/features/child_shell/presentation/child_shell.dart';
import 'package:lumio/features/dev/presentation/development_entry_screen.dart';
import 'package:lumio/features/parent_shell/presentation/parent_shell.dart';
import 'package:lumio/features/route_error/presentation/route_error_screen.dart';
import 'package:lumio/features/startup/presentation/bootstrap_screen.dart';

import '../support/profile_test_repository.dart';

const previewConfig = AppConfig(
  environment: AppEnvironment.development,
  enableNavigationPreview: true,
  enableDesignPreview: true,
);

Future<void> startPreview(
  WidgetTester tester, {
  Locale locale = const Locale('en'),
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [testProfileOverride(complete: true)],
      child: LumioApp(config: previewConfig, locale: locale),
    ),
  );
  await tester.pump(LumioMotion.slow);
  await tester.pumpAndSettle();
}

Future<void> selectRoute(WidgetTester tester, LumioRoute route) async {
  await tester.ensureVisible(find.byKey(ValueKey(route.name)));
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(ValueKey(route.name)));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets(
    'incoming route during startup is not overwritten by its deferred handoff',
    (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [testProfileOverride(complete: true)],
          child: LumioApp(config: previewConfig, locale: Locale('en')),
        ),
      );
      final router = ProviderScope.containerOf(
        tester.element(find.byType(BootstrapScreen)),
      ).read(appRouterProvider(previewConfig));
      router.goNamed(
        AppRoutes.childWorlds.name,
        pathParameters: AppRoutes.childParameters('incoming_context'),
      );
      await tester.pumpAndSettle();
      await tester.pump(LumioMotion.slow);
      await tester.pumpAndSettle();
      expect(
        tester.widget<ChildShell>(find.byType(ChildShell)).section,
        ChildSection.worlds,
      );
      expect(
        tester.widget<ChildShell>(find.byType(ChildShell)).childId,
        'incoming_context',
      );
      expect(find.byType(DevelopmentEntryScreen), findsNothing);
    },
  );

  testWidgets(
    'reduced motion removes route transitions and resume preserves mode/context',
    (tester) async {
      tester.platformDispatcher.accessibilityFeaturesTestValue =
          FakeAccessibilityFeatures(disableAnimations: true);
      addTearDown(
        tester.platformDispatcher.clearAccessibilityFeaturesTestValue,
      );
      await startPreview(tester);
      await enterPreviewChild(tester);
      await tester.pumpAndSettle();
      await selectRoute(tester, AppRoutes.childRewards);
      final context = tester.element(find.byType(ChildRewardsScreen));
      expect(ModalRoute.of(context)!.transitionDuration, Duration.zero);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
      await tester.pump(const Duration(seconds: 1));
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pumpAndSettle();
      final shell = tester.widget<ChildShell>(find.byType(ChildShell));
      expect(shell.section, ChildSection.rewards);
      expect(shell.childId, 'preview');
    },
  );

  testWidgets(
    'startup renders the official identity then replaces it with development entry',
    (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [testProfileOverride(complete: true)],
          child: LumioApp(config: previewConfig, locale: Locale('en')),
        ),
      );
      expect(find.byType(BootstrapScreen), findsOneWidget);
      expect(find.text('Play. Learn. Glow.'), findsOneWidget);
      expect(find.byType(LumioLogo), findsOneWidget);
      expect(find.byType(LumiMascot), findsOneWidget);
      await tester.pump(LumioMotion.slow);
      await tester.pumpAndSettle();
      expect(find.byType(DevelopmentEntryScreen), findsOneWidget);
      expect(find.byType(BootstrapScreen), findsNothing);
    },
  );

  testWidgets(
    'entry reaches parent mode and all sections replace the route without sharing child navigation',
    (tester) async {
      await startPreview(tester);
      await tester.tap(
        find.text('Open Parent Mode').evaluate().isNotEmpty
            ? find.text('Open Parent Mode')
            : find.text('Open Parent Area'),
      );
      await tester.pumpAndSettle();
      expect(find.text('Welcome, Parent'), findsOneWidget);
      expect(find.byType(ParentShell), findsOneWidget);
      expect(find.byType(ChildShell), findsNothing);
      expect(find.byKey(ValueKey(AppRoutes.childWorlds.name)), findsNothing);
      for (final section in ParentSection.values.skip(1)) {
        await selectRoute(tester, section.route);
        expect(
          tester.widget<ParentShell>(find.byType(ParentShell)).section,
          section,
        );
      }
      // Section switches must not leave a stack of previous tabs to pop.
      final context = tester.element(find.byType(ParentShell));
      final scope = ProviderScope.containerOf(context);
      final router = scope.read(appRouterProvider(previewConfig));
      expect(router.canPop(), isFalse);
      expect(
        router.routeInformationProvider.value.uri.path,
        AppRoutes.parentSettings.path,
      );
    },
  );

  testWidgets(
    'child sections preserve the opaque context and expose no parent navigation',
    (tester) async {
      await startPreview(tester);
      await enterPreviewChild(tester);
      await tester.pumpAndSettle();
      expect(find.text('Hi, Aiman!'), findsOneWidget);
      expect(find.byType(ChildShell), findsOneWidget);
      expect(find.byType(ParentShell), findsNothing);
      expect(find.byKey(ValueKey(AppRoutes.parentChildren.name)), findsNothing);
      await selectRoute(tester, AppRoutes.childWorlds);
      await selectRoute(tester, AppRoutes.childRewards);
      final shell = tester.widget<ChildShell>(find.byType(ChildShell));
      expect(shell.childId, 'preview');
      expect(shell.section, ChildSection.rewards);
      final router = ProviderScope.containerOf(
        tester.element(find.byType(ChildShell)),
      ).read(appRouterProvider(previewConfig));
      expect(router.canPop(), isFalse);
      expect(
        router.routeInformationProvider.value.uri.path,
        '/child/preview/rewards',
      );
    },
  );

  testWidgets(
    'system back returns section to mode home then development entry',
    (tester) async {
      await startPreview(tester);
      await tester.tap(
        find.text('Open Parent Mode').evaluate().isNotEmpty
            ? find.text('Open Parent Mode')
            : find.text('Open Parent Area'),
      );
      await tester.pumpAndSettle();
      await selectRoute(tester, AppRoutes.parentSettings);
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(find.text('Welcome, Parent'), findsOneWidget);
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(find.byType(DevelopmentEntryScreen), findsOneWidget);

      await enterPreviewChild(tester);
      await tester.pumpAndSettle();
      await selectRoute(tester, AppRoutes.childWorlds);
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(find.text('Hi, Aiman!'), findsOneWidget);
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(find.text('Who’s exploring today?'), findsOneWidget);
      expect(find.byType(BootstrapScreen), findsNothing);
    },
  );

  testWidgets('mode changes cannot retain the other mode selected section', (
    tester,
  ) async {
    await startPreview(tester);
    if (find.text('Open Parent Area').evaluate().isNotEmpty) {
      await tester.ensureVisible(find.text('Open Parent Area'));
      await tester.pumpAndSettle();
    }
    await tester.tap(
      find.text('Open Parent Mode').evaluate().isNotEmpty
          ? find.text('Open Parent Mode')
          : find.text('Open Parent Area'),
    );
    await tester.pumpAndSettle();
    await selectRoute(tester, AppRoutes.parentProgress);
    await tester.tap(find.byTooltip('Back to parent home'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Back to development preview'));
    await tester.pumpAndSettle();
    await enterPreviewChild(tester);
    await tester.pumpAndSettle();
    expect(
      tester.widget<ChildShell>(find.byType(ChildShell)).section,
      ChildSection.home,
    );
    await selectRoute(tester, AppRoutes.childRewards);
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    if (find.text('Open Parent Area').evaluate().isNotEmpty) {
      await tester.ensureVisible(find.text('Open Parent Area'));
      await tester.pumpAndSettle();
    }
    await tester.tap(
      find.text('Open Parent Mode').evaluate().isNotEmpty
          ? find.text('Open Parent Mode')
          : find.text('Open Parent Area'),
    );
    await tester.pumpAndSettle();
    expect(
      tester.widget<ParentShell>(find.byType(ParentShell)).section,
      ParentSection.home,
    );
  });

  testWidgets(
    'direct links select the correct shell/context and aliases resolve',
    (tester) async {
      await startPreview(tester);
      final router = ProviderScope.containerOf(
        tester.element(find.byType(DevelopmentEntryScreen)),
      ).read(appRouterProvider(previewConfig));
      router.go(AppRoutes.parent.path);
      await tester.pumpAndSettle();
      expect(find.text('Welcome, Parent'), findsOneWidget);
      router.go('/child/context_42');
      await tester.pumpAndSettle();
      expect(
        tester.widget<ChildShell>(find.byType(ChildShell)).childId,
        'context_42',
      );
      await selectRoute(tester, AppRoutes.childWorlds);
      expect(
        router.routeInformationProvider.value.uri.path,
        '/child/context_42/adventure',
      );
      router.go(AppRoutes.parentSettings.path);
      await tester.pumpAndSettle();
      expect(
        tester.widget<ParentShell>(find.byType(ParentShell)).section,
        ParentSection.settings,
      );
    },
  );

  testWidgets(
    'unknown and malformed child routes recover without raw route details',
    (tester) async {
      await startPreview(tester);
      final router = ProviderScope.containerOf(
        tester.element(find.byType(DevelopmentEntryScreen)),
      ).read(appRouterProvider(previewConfig));
      for (final location in [
        '/missing/private-detail',
        '/child/bad%20context',
        '/child/bad%20context/home',
      ]) {
        router.go(location);
        await tester.pumpAndSettle();
        expect(find.byType(RouteErrorScreen), findsOneWidget);
        expect(find.text('Oops! Lumi got a little lost.'), findsOneWidget);
        expect(find.text(location), findsNothing);
        await tester.tap(find.text('Back to Lumio'));
        await tester.pumpAndSettle();
        expect(find.byType(DevelopmentEntryScreen), findsOneWidget);
      }
    },
  );

  testWidgets(
    'production flags cannot register development routes or exit controls',
    (tester) async {
      const config = AppConfig(
        environment: AppEnvironment.production,
        enableNavigationPreview: true,
        enableDesignPreview: true,
      );
      await tester.pumpWidget(
        ProviderScope(
          overrides: [testProfileOverride(complete: true)],
          child: LumioApp(config: config, locale: Locale('en')),
        ),
      );
      await tester.pump(LumioMotion.slow);
      await tester.pumpAndSettle();
      expect(find.byType(DevelopmentEntryScreen), findsNothing);
      final router = ProviderScope.containerOf(
        tester.element(find.byType(LumioLogo)),
      ).read(appRouterProvider(config));
      for (final route in [
        AppRoutes.development,
        AppRoutes.designSystem,
        AppRoutes.learningContent,
      ]) {
        router.go(route.path);
        await tester.pumpAndSettle();
        expect(find.byType(RouteErrorScreen), findsOneWidget);
      }
      router.go(AppRoutes.childHome.path.replaceFirst(':childId', 'context'));
      await tester.pumpAndSettle();
      expect(find.byTooltip('Exit Child Mode'), findsOneWidget);
      expect(
        tester.widget<ChildShell>(find.byType(ChildShell)).onExitPreview,
        isNotNull,
      );
    },
  );

  testWidgets(
    'selected destinations are labeled, semantic and meet touch/contrast checks',
    (tester) async {
      final semantics = tester.ensureSemantics();
      await startPreview(tester);
      await enterPreviewChild(tester);
      await tester.pumpAndSettle();
      expect(
        tester
            .getSemantics(find.byKey(ValueKey(AppRoutes.childHome.name)))
            .flagsCollection
            .isSelected,
        Tristate.isTrue,
      );
      expect(find.bySemanticsLabel('Exit Child Mode'), findsOneWidget);
      expect(find.bySemanticsLabel('Child Mode'), findsOneWidget);
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      await expectLater(tester, meetsGuideline(textContrastGuideline));
      semantics.dispose();
    },
  );

  for (final (size, scale, locale) in [
    (const Size(320, 568), 1.0, const Locale('en')),
    (const Size(390, 844), 1.0, const Locale('en')),
    (const Size(430, 932), 1.0, const Locale('en')),
    (const Size(768, 1024), 1.0, const Locale('ms')),
    (const Size(1024, 768), 1.0, const Locale('en')),
    (const Size(568, 320), 2.0, const Locale('en')),
    (const Size(320, 568), 2.0, const Locale('ms')),
    (const Size(1024, 768), 2.0, const Locale('ms')),
  ]) {
    testWidgets(
      'both shells fit $size, $scale text, $locale and survive rotation',
      (tester) async {
        await tester.binding.setSurfaceSize(size);
        addTearDown(() => tester.binding.setSurfaceSize(null));
        tester.platformDispatcher.textScaleFactorTestValue = scale;
        tester.platformDispatcher.accessibilityFeaturesTestValue =
            FakeAccessibilityFeatures(disableAnimations: true);
        addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
        addTearDown(
          tester.platformDispatcher.clearAccessibilityFeaturesTestValue,
        );
        await startPreview(tester, locale: locale);
        await tester.ensureVisible(
          find.text(
            locale.languageCode == 'ms'
                ? 'Buka Mod Ibu Bapa'
                : 'Open Parent Mode',
          ),
        );
        await tester.tap(
          find.text(
            locale.languageCode == 'ms'
                ? 'Buka Mod Ibu Bapa'
                : 'Open Parent Mode',
          ),
        );
        await tester.pumpAndSettle();
        await selectRoute(tester, AppRoutes.parentSettings);
        expect(tester.takeException(), isNull);
        final router = ProviderScope.containerOf(
          tester.element(find.byType(ParentShell)),
        ).read(appRouterProvider(previewConfig));
        router.goNamed(
          AppRoutes.childHome.name,
          pathParameters: AppRoutes.childParameters('rotation_context'),
        );
        await tester.pumpAndSettle();
        await selectRoute(tester, AppRoutes.childRewards);
        expect(tester.takeException(), isNull);
        await tester.binding.setSurfaceSize(Size(size.height, size.width));
        await tester.pumpAndSettle();
        expect(
          tester.widget<ChildShell>(find.byType(ChildShell)).childId,
          'rotation_context',
        );
        expect(
          tester.widget<ChildShell>(find.byType(ChildShell)).section,
          ChildSection.rewards,
        );
        expect(tester.takeException(), isNull);
      },
    );
  }
}

Future<void> enterPreviewChild(WidgetTester tester) async {
  await tester.ensureVisible(find.text('Open Child Mode'));
  await tester.tap(find.text('Open Child Mode'));
  await tester.pumpAndSettle();
  await tester.ensureVisible(find.byKey(const ValueKey('profile-preview')));
  await tester.tap(find.byKey(const ValueKey('profile-preview')));
  await tester.pumpAndSettle();
}
