import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumio/core/design_system.dart';
import 'package:lumio/features/startup/presentation/bootstrap_screen.dart';
import 'package:lumio/l10n/generated/app_localizations.dart';

Widget host(VoidCallback onReady, {bool reduced = false}) => MaterialApp(
  theme: LumioTheme.light,
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  home: MediaQuery(
    data: MediaQueryData(disableAnimations: reduced),
    child: BootstrapScreen(onReady: onReady),
  ),
);

void main() {
  testWidgets(
    'bootstrap does not navigate in the background and resumes only once',
    (tester) async {
      var completions = 0;
      await tester.pumpWidget(host(() => completions++));
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
      await tester.pump(const Duration(seconds: 2));
      expect(completions, 0);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pump(LumioMotion.slow);
      expect(completions, 1);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pump(const Duration(seconds: 2));
      expect(completions, 1);
    },
  );

  testWidgets('disposing bootstrap cancels deferred navigation', (
    tester,
  ) async {
    var completions = 0;
    await tester.pumpWidget(host(() => completions++));
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(seconds: 2));
    expect(completions, 0);
  });

  testWidgets(
    'reduced motion preserves a readable startup and completes normally',
    (tester) async {
      var completions = 0;
      await tester.pumpWidget(host(() => completions++, reduced: true));
      await tester.pump();
      expect(tester.widget<Opacity>(find.byType(Opacity).first).opacity, 1);
      expect(find.text('Play. Learn. Glow.'), findsOneWidget);
      await tester.pump(LumioMotion.slow);
      expect(completions, 1);
    },
  );
}
