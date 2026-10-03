import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumio/app/lumio_app.dart';
import 'package:lumio/core/config/app_config.dart';
import 'package:lumio/core/design_system.dart';
import 'package:lumio/core/routing/app_router.dart';
import 'package:lumio/features/child_shell/presentation/child_shell.dart';
import 'package:lumio/features/onboarding/presentation/onboarding_screen.dart';
import 'package:lumio/features/profiles/application/profile_store.dart';
import 'package:lumio/features/profiles/domain/profiles.dart';
import 'package:lumio/features/profiles/presentation/children_screen.dart';
import 'package:lumio/features/profiles/presentation/profile_widgets.dart';
import '../support/profile_test_repository.dart';

const config = AppConfig(environment: AppEnvironment.development);

Future<void> tapText(WidgetTester tester, String label) async {
  FocusManager.instance.primaryFocus?.unfocus();
  await tester.pumpAndSettle();
  final target = find.text(label).last;
  await tester.ensureVisible(target);
  await tester.pumpAndSettle();
  await tester.tap(target);
  await tester.pumpAndSettle();
}

Future<void> fillChild(
  WidgetTester tester,
  String name, {
  int age = 6,
  String avatar = 'Sun',
}) async {
  await tester.ensureVisible(find.byKey(const ValueKey('childNickname')));
  await tester.enterText(find.byKey(const ValueKey('childNickname')), name);
  await tester.ensureVisible(find.byKey(ValueKey('age-$age')));
  await tester.tap(find.byKey(ValueKey('age-$age')));
  await tester.pumpAndSettle();
  await tapText(tester, avatar);
}

Future<ProviderContainer> launch(
  WidgetTester tester,
  TestProfileRepository repo, {
  AppConfig appConfig = config,
  Locale locale = const Locale('en'),
}) async {
  final container = ProviderContainer(
    overrides: [profileRepositoryProvider.overrideWithValue(repo)],
  );
  addTearDown(container.dispose);
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: LumioApp(config: appConfig, locale: locale),
    ),
  );
  await tester.pump(LumioMotion.slow);
  await tester.pumpAndSettle();
  return container;
}

void main() {
  testWidgets(
    'first run completes atomic setup, CRUD, selection, switch and restart',
    (tester) async {
      final repo = TestProfileRepository();
      final container = await launch(tester, repo);
      expect(find.byType(OnboardingScreen), findsOneWidget);
      await tapText(tester, 'Get started');
      await tester.enterText(
        find.byKey(const ValueKey('parentDisplayName')),
        'Maya',
      );
      await tapText(tester, 'Continue');
      await tapText(tester, 'Continue');
      expect(find.text('Enter a nickname.'), findsOneWidget);
      expect(repo.snapshot.onboardingComplete, isFalse);
      await fillChild(tester, ' Aiman ');
      await tapText(tester, 'Continue');
      expect(repo.snapshot.children, isEmpty);
      await tapText(tester, 'Finish setup');
      expect(repo.snapshot.parent!.displayName, 'Maya');
      expect(find.text('Aiman'), findsOneWidget);
      expect(repo.snapshot.onboardingComplete, isTrue);
      final first = repo.snapshot.children.single;
      await tester.tap(find.byKey(ValueKey('profile-${first.id}')));
      await tester.pumpAndSettle();
      expect(find.text('Hi, Aiman!'), findsOneWidget);
      expect(
        container.read(activeChildProvider(first.id)).value!.avatar,
        ProfileAvatar.sun,
      );
      expect(
        tester.widget<ProfileAvatarView>(find.byType(ProfileAvatarView)).avatar,
        ProfileAvatar.sun,
      );
      await tester.tap(find.byTooltip('Exit Child Mode'));
      await tester.pumpAndSettle();
      await tapText(tester, 'Add child');
      await fillChild(tester, 'Sofia', age: 9, avatar: 'Moon');
      await tapText(tester, 'Save profile');
      final second = repo.snapshot.children.last;
      expect(repo.snapshot.children, hasLength(2));
      await tapText(tester, 'Open Sofia’s space');
      expect(find.text('Hi, Sofia!'), findsOneWidget);
      expect(
        tester.widget<ChildShell>(find.byType(ChildShell)).childId,
        second.id,
      );
      expect(
        container.read(activeChildProvider(second.id)).value!.avatar,
        ProfileAvatar.moon,
      );
      await tester.tap(find.byTooltip('Exit Child Mode'));
      await tester.pumpAndSettle();
      await tapText(tester, 'Open Parent Area');
      await tapText(tester, 'Manage child profiles');
      await tapText(tester, 'Edit Sofia');
      await tester.enterText(
        find.byKey(const ValueKey('childNickname')),
        'Sof',
      );
      await tapText(tester, 'Save profile');
      expect(repo.snapshot.child(second.id)!.displayName, 'Sof');
      expect(repo.snapshot.child(second.id)!.createdAt, second.createdAt);
      await tapText(tester, 'Delete Sof');
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(repo.snapshot.children, hasLength(2));
      await tapText(tester, 'Cancel');
      expect(repo.snapshot.children, hasLength(2));
      await tapText(tester, 'Delete Sof');
      await tapText(tester, 'Delete profile');
      expect(repo.snapshot.children, hasLength(1));
      await tester.pumpWidget(const SizedBox.shrink());
      await launch(tester, repo);
      expect(find.byType(OnboardingScreen), findsNothing);
      expect(find.text('Who’s exploring today?'), findsOneWidget);
      expect(find.text('Aiman'), findsOneWidget);
      expect(find.byType(ChildShell), findsNothing);
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );

  testWidgets('final deletion stays usable and deleted active IDs recover', (
    tester,
  ) async {
    final repo = TestProfileRepository(complete: true, ids: ['first']);
    final container = await launch(tester, repo);
    final router = container.read(appRouterProvider(config));
    router.go('/child/first/home');
    await tester.pumpAndSettle();
    await container.read(profileStoreProvider.notifier).delete('first');
    await tester.pumpAndSettle();
    expect(find.text('This profile isn’t available'), findsOneWidget);
    expect(container.read(activeChildProvider('first')).value, isNull);
    await tapText(tester, 'Choose a child');
    expect(find.text('Their first chapter starts here'), findsOneWidget);
    expect(find.text('Add child'), findsOneWidget);
    expect(repo.snapshot.onboardingComplete, isTrue);
    router.go('/child/does-not-exist/home');
    await tester.pumpAndSettle();
    expect(find.text('This profile isn’t available'), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets(
    'load errors preserve local data and retry; save errors retain draft',
    (tester) async {
      final repo = TestProfileRepository(complete: true, ids: ['first'])
        ..failLoad = true;
      await launch(tester, repo);
      expect(find.text('We couldn’t open your local profiles'), findsOneWidget);
      expect(repo.snapshot.children, hasLength(1));
      repo.failLoad = false;
      await tapText(tester, 'Try again');
      await tapText(tester, 'Add child');
      await fillChild(tester, 'New');
      repo.failWrite = true;
      await tapText(tester, 'Save profile');
      expect(find.byType(ProfileErrorText), findsOneWidget);
      expect(
        tester
            .widget<TextFormField>(
              find.descendant(
                of: find.byKey(const ValueKey('childNickname')),
                matching: find.byType(TextFormField),
              ),
            )
            .controller!
            .text,
        'New',
      );
      expect(repo.snapshot.children, hasLength(1));
      await tapText(tester, 'Cancel');
      expect(find.byType(AlertDialog), findsOneWidget);
      await tapText(tester, 'Discard changes');
      expect(find.text('Manage child profiles'), findsOneWidget);
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );

  testWidgets('debug reset confirms and returns to real onboarding', (
    tester,
  ) async {
    final repo = TestProfileRepository(complete: true, ids: ['first']);
    final container = await launch(tester, repo);
    container
        .read(appRouterProvider(config))
        .goNamed(AppRoutes.parentSettings.name);
    await tester.pumpAndSettle();
    await tapText(tester, 'Reset Lumio Local Data');
    expect(repo.snapshot.onboardingComplete, isTrue);
    await tapText(tester, 'Reset local data');
    expect(find.byType(OnboardingScreen), findsOneWidget);
    expect(repo.snapshot.parent, isNull);
    expect(repo.snapshot.children, isEmpty);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets(
    'production cannot show debug reset; child language stays inside child mode',
    (tester) async {
      final repo = TestProfileRepository(complete: true, ids: []);
      final child = await repo.createChild(
        const ChildDraft(
          displayName: 'Aiman',
          startingAge: 6,
          avatar: ProfileAvatar.leaf,
          language: 'ms',
        ),
      );
      const production = AppConfig(environment: AppEnvironment.production);
      final container = await launch(tester, repo, appConfig: production);
      final router = container.read(appRouterProvider(production));
      router.goNamed(AppRoutes.parentSettings.name);
      await tester.pumpAndSettle();
      expect(find.text('Reset Lumio Local Data'), findsNothing);
      router.goNamed(
        AppRoutes.childHome.name,
        pathParameters: AppRoutes.childParameters(child.id),
      );
      await tester.pumpAndSettle();
      expect(find.text('Hai, Aiman!'), findsOneWidget);
      await tester.tap(find.byTooltip('Keluar Mod Kanak-kanak'));
      await tester.pumpAndSettle();
      expect(find.text('Who’s exploring today?'), findsOneWidget);
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );

  for (final size in [
    const Size(320, 568),
    const Size(390, 844),
    const Size(430, 932),
    const Size(768, 1024),
    const Size(1024, 768),
  ]) {
    testWidgets('profile forms and cards fit $size at 200 percent text', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(size);
      addTearDown(() => tester.binding.setSurfaceSize(null));
      tester.platformDispatcher.textScaleFactorTestValue = 2;
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      final repo = TestProfileRepository(complete: true, ids: ['one', 'two']);
      final container = await launch(tester, repo);
      expect(find.byType(ChildrenScreen), findsOneWidget);
      await tapText(tester, 'Add child');
      await fillChild(tester, 'Explorer', avatar: 'Leaf');
      await tapText(tester, 'Save profile');
      container
          .read(appRouterProvider(config))
          .goNamed(AppRoutes.parentSettings.name);
      await tester.pumpAndSettle();
      await tapText(tester, 'Reset Lumio Local Data');
      await tapText(tester, 'Cancel');
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
    });
  }
}
