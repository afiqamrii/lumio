import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumio/app/lumio_app.dart';
import 'package:lumio/core/config/app_config.dart';
import 'package:lumio/core/design_system.dart';
import 'package:lumio/core/routing/app_router.dart';
import 'package:lumio/features/profiles/application/profile_store.dart';
import 'package:lumio/features/profiles/domain/profiles.dart';
import 'support/profile_test_repository.dart';

const _config = AppConfig(environment: AppEnvironment.development);
const _capture = bool.fromEnvironment('LUMIO_CAPTURE_UI');

void main() {
  setUpAll(() async {
    // Real bundled fonts make the optional captures representative of the app.
    for (final (family, path) in [
      ('MaterialIcons', 'fonts/MaterialIcons-Regular.otf'),
      ('Sora', 'assets/ui/fonts/sora/Sora[wght].ttf'),
      (
        'PlusJakartaSans',
        'assets/ui/fonts/plusjakartasans/PlusJakartaSans[wght].ttf',
      ),
      (
        'NotoSansArabic',
        'assets/brand/fonts/notosansarabic/NotoSansArabic[wdth,wght].ttf',
      ),
    ]) {
      final loader = FontLoader(family)..addFont(rootBundle.load(path));
      await loader.load();
    }
  });

  for (final (size, scale, language) in [
    (const Size(390, 844), 1.0, 'en'),
    (const Size(1024, 768), 1.0, 'en'),
    (const Size(320, 568), 2.0, 'en'),
    (const Size(390, 844), 2.0, 'ms'),
  ]) {
    testWidgets('redesigned routes fit ${size.width} at $scale in $language', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(size);
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = size;
      tester.platformDispatcher.textScaleFactorTestValue = scale;
      addTearDown(() async {
        tester.view.resetDevicePixelRatio();
        tester.view.resetPhysicalSize();
        tester.platformDispatcher.clearTextScaleFactorTestValue();
        await tester.binding.setSurfaceSize(null);
      });
      final repo = TestProfileRepository(complete: true, ids: []);
      final child = await repo.createChild(
        ChildDraft(
          displayName: scale == 1
              ? 'Aiman'
              : 'A very curious explorer with a hat',
          startingAge: 6,
          avatar: ProfileAvatar.sun,
          language: language,
        ),
      );
      await repo.createChild(
        ChildDraft(
          displayName: 'Sofia',
          startingAge: 8,
          avatar: ProfileAvatar.leaf,
          language: language,
        ),
      );
      final container = ProviderContainer(
        overrides: [profileRepositoryProvider.overrideWithValue(repo)],
      );
      addTearDown(container.dispose);
      final boundary = GlobalKey();
      await tester.pumpWidget(
        RepaintBoundary(
          key: boundary,
          child: UncontrolledProviderScope(
            container: container,
            child: LumioApp(config: _config, locale: Locale(language)),
          ),
        ),
      );
      await tester.pump(LumioMotion.slow);
      await tester.pumpAndSettle();
      await _precache(tester, boundary);
      final router = container.read(appRouterProvider(_config));
      for (final (name, route) in [
        ('selector', '/select-child'),
        ('child-home', '/child/${child.id}/home'),
        ('adventure-map', '/child/${child.id}/adventure'),
        ('number-kingdom', '/child/${child.id}/adventure/number-kingdom'),
        ('rewards', '/child/${child.id}/rewards'),
        ('parent-home', '/parent/home'),
        ('children', '/parent/children'),
        ('progress', '/parent/progress'),
        ('settings', '/parent/settings'),
        ('editor', '/parent/children/${child.id}/edit'),
      ]) {
        router.go(route);
        await tester.pumpAndSettle();
        await _precache(tester, boundary);
        expect(
          tester.takeException(),
          isNull,
          reason: '$name $size $scale $language',
        );
        if (_capture && scale == 1) {
          await _save(tester, boundary, '$name-${size.width.toInt()}');
        }
      }
      await tester.pumpWidget(const SizedBox.shrink());
    });
  }

  testWidgets('welcome and setup remain usable with scaled text', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 844);
    addTearDown(() async {
      tester.view.resetDevicePixelRatio();
      tester.view.resetPhysicalSize();
      await tester.binding.setSurfaceSize(null);
    });
    final container = ProviderContainer(
      overrides: [
        profileRepositoryProvider.overrideWithValue(TestProfileRepository()),
      ],
    );
    addTearDown(container.dispose);
    final boundary = GlobalKey();
    await tester.pumpWidget(
      RepaintBoundary(
        key: boundary,
        child: UncontrolledProviderScope(
          container: container,
          child: const LumioApp(config: _config, locale: Locale('en')),
        ),
      ),
    );
    await tester.pump(LumioMotion.slow);
    await tester.pumpAndSettle();
    await _precache(tester, boundary);
    if (_capture) await _save(tester, boundary, 'welcome-390');
    await tester.ensureVisible(find.text('Get started'));
    await tester.tap(find.text('Get started'));
    await tester.pumpAndSettle();
    if (_capture) await _save(tester, boundary, 'parent-setup-390');
    await tester.ensureVisible(find.text('Continue'));
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    if (_capture) await _save(tester, boundary, 'child-setup-390');
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    tester.platformDispatcher.clearTextScaleFactorTestValue();
    await tester.pumpWidget(const SizedBox.shrink());
  });
}

Future<void> _save(WidgetTester tester, GlobalKey key, String name) async {
  await tester.runAsync(() async {
    final boundary =
        key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: 1);
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    final directory = Directory('verification/ui-redesign')
      ..createSync(recursive: true);
    File(
      '${directory.path}/$name.png',
    ).writeAsBytesSync(data!.buffer.asUint8List());
    image.dispose();
  });
}

Future<void> _precache(WidgetTester tester, GlobalKey key) async {
  // Decode the exact ImageProviders used by each screen (including cacheWidth).
  // pumpAndSettle alone does not wait for native image decoding in widget tests.
  final providers = tester
      .widgetList<Image>(find.byType(Image))
      .map((widget) => widget.image)
      .toList();
  await tester.runAsync(() async {
    for (final provider in providers) {
      await precacheImage(provider, key.currentContext!);
    }
  });
  await tester.pumpAndSettle();
}
