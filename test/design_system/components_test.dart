import 'dart:ui' show SemanticsAction, Tristate;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumio/core/design_system.dart';
import 'package:lumio/l10n/generated/app_localizations.dart';

Widget host(Widget child, {bool reduced = false}) => MaterialApp(
  theme: LumioTheme.light,
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  home: MediaQuery(
    data: MediaQueryData(disableAnimations: reduced),
    child: Scaffold(
      body: Center(child: SizedBox(width: 280, child: child)),
    ),
  ),
);

void main() {
  for (final variant in LumioButtonVariant.values) {
    testWidgets('$variant button activates once and has a child-sized target', (
      tester,
    ) async {
      var calls = 0;
      await tester.pumpWidget(
        host(
          LumioButton(
            label: 'Press me',
            variant: variant,
            onPressed: () => calls++,
          ),
        ),
      );
      expect(find.text('Press me'), findsOneWidget);
      final target = tester.getSize(find.byType(InkWell));
      expect(target.height, greaterThanOrEqualTo(56));
      expect(target.width, greaterThanOrEqualTo(56));
      await tester.tap(find.text('Press me'));
      await tester.pumpAndSettle();
      expect(calls, 1);
      final semantics = tester.ensureSemantics();
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      await expectLater(tester, meetsGuideline(textContrastGuideline));
      semantics.dispose();
    });
  }

  testWidgets('disabled button exposes its state and cannot activate', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(
      host(const LumioButton(label: 'Unavailable', onPressed: null)),
    );
    await tester.tap(find.text('Unavailable'));
    final node = tester.getSemantics(find.byType(LumioButton));
    expect(node.getSemanticsData().hasAction(SemanticsAction.tap), isFalse);
    expect(node.flagsCollection.isEnabled, Tristate.isFalse);
    expect(tester.widget<InkWell>(find.byType(InkWell)).onTap, isNull);
    semantics.dispose();
  });

  testWidgets('loading blocks duplicate activation and announces status', (
    tester,
  ) async {
    var calls = 0;
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(
      host(
        LumioButton(
          label: 'Continue',
          isLoading: true,
          onPressed: () => calls++,
        ),
      ),
    );
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(
      tester.getSemantics(find.byType(LumioButton)).getSemanticsData().value,
      'Loading',
    );
    await tester.tap(find.text('Continue'));
    await tester.pump();
    expect(calls, 0);
    await tester.pumpWidget(
      host(
        LumioButton(
          label: 'Continue',
          isLoading: true,
          onPressed: () => calls++,
        ),
        reduced: true,
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byIcon(Icons.hourglass_top_rounded), findsOneWidget);
    semantics.dispose();
  });

  testWidgets(
    'press feedback leaves the hit area stable and honors reduced motion',
    (tester) async {
      await tester.pumpWidget(
        host(LumioButton(label: 'Press', onPressed: () {})),
      );
      final before = tester.getRect(find.byType(InkWell));
      final gesture = await tester.startGesture(before.center);
      await tester.pump(const Duration(milliseconds: 150));
      expect(
        tester.widget<AnimatedScale>(find.byType(AnimatedScale)).scale,
        LumioMotion.pressScale,
      );
      expect(tester.getRect(find.byType(InkWell)), before);
      await gesture.up();
      await tester.pumpAndSettle();
      expect(tester.widget<AnimatedScale>(find.byType(AnimatedScale)).scale, 1);

      await tester.pumpWidget(
        host(LumioButton(label: 'Press', onPressed: () {}), reduced: true),
      );
      final reducedGesture = await tester.startGesture(
        tester.getCenter(find.byType(InkWell)),
      );
      await tester.pump();
      final animation = tester.widget<AnimatedScale>(
        find.byType(AnimatedScale),
      );
      expect(animation.scale, 1);
      expect(animation.duration, Duration.zero);
      await reducedGesture.up();
      await tester.pumpAndSettle();
    },
  );

  testWidgets('keyboard focus and Enter activate the same callback', (
    tester,
  ) async {
    var calls = 0;
    await tester.pumpWidget(
      host(LumioButton(label: 'Keyboard', onPressed: () => calls++)),
    );
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    expect(calls, 1);
  });

  testWidgets('icon action is labeled and selection is visible and semantic', (
    tester,
  ) async {
    var calls = 0;
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(
      host(
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            LumioIconButton(
              icon: Icons.replay_rounded,
              label: 'Reset preview',
              onPressed: () => calls++,
            ),
            LumioCard(
              selected: true,
              semanticLabel: 'Selected sample',
              onTap: () => calls++,
              child: const Text('Sample'),
            ),
          ],
        ),
      ),
    );
    expect(
      tester.getSize(find.byType(LumioIconButton)).shortestSide,
      greaterThanOrEqualTo(56),
    );
    expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);
    expect(
      tester.getSemantics(find.byType(LumioCard)).flagsCollection.isSelected,
      Tristate.isTrue,
    );
    await tester.tap(find.byType(LumioIconButton));
    await tester.tap(find.text('Sample'));
    await tester.pumpAndSettle();
    expect(calls, 2);
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    semantics.dispose();
  });

  for (final (input, normalized, label) in [
    (0.0, 0.0, '0%'),
    (0.5, 0.5, '50%'),
    (1.0, 1.0, '100%'),
    (-1.0, 0.0, '0%'),
    (2.0, 1.0, '100%'),
    (double.nan, 0.0, '0%'),
    (double.infinity, 0.0, '0%'),
  ]) {
    testWidgets(
      'progress $input renders a safe fraction and accessible percentage',
      (tester) async {
        final semantics = tester.ensureSemantics();
        await tester.pumpWidget(
          host(LumioProgressBar(value: input, label: 'Sample progress')),
        );
        await tester.pumpAndSettle();
        expect(
          tester
              .widget<LinearProgressIndicator>(
                find.byType(LinearProgressIndicator),
              )
              .value,
          normalized,
        );
        expect(find.text(label), findsOneWidget);
        expect(
          tester
              .getSemantics(find.byType(LumioProgressBar))
              .getSemanticsData()
              .value,
          label,
        );
        if (normalized == 1) {
          expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);
        }
        expect(tester.takeException(), isNull);
        semantics.dispose();
      },
    );
  }

  testWidgets(
    'progress updates smoothly and reduced motion applies immediately',
    (tester) async {
      await tester.pumpWidget(
        host(const LumioProgressBar(value: 0, label: 'Progress')),
      );
      await tester.pumpAndSettle();
      await tester.pumpWidget(
        host(const LumioProgressBar(value: 1, label: 'Progress')),
      );
      await tester.pump(const Duration(milliseconds: 100));
      final midway = tester
          .widget<LinearProgressIndicator>(find.byType(LinearProgressIndicator))
          .value!;
      expect(midway, greaterThan(0));
      expect(midway, lessThan(1));
      await tester.pumpAndSettle();
      await tester.pumpWidget(
        host(
          const LumioProgressBar(value: 0.5, label: 'Progress'),
          reduced: true,
        ),
      );
      await tester.pump();
      expect(
        tester
            .widget<LinearProgressIndicator>(
              find.byType(LinearProgressIndicator),
            )
            .value,
        0.5,
      );
    },
  );

  testWidgets('all badge tones meet text contrast guidelines', (tester) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(
      host(
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final tone in LumioBadgeTone.values)
              LumioBadge(label: tone.name, tone: tone),
          ],
        ),
      ),
    );
    await expectLater(tester, meetsGuideline(textContrastGuideline));
    semantics.dispose();
  });
}
