import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumio/features/learning/presentation/learning_content_browser_screen.dart';
import 'package:lumio/l10n/generated/app_localizations.dart';

void main() {
  testWidgets(
    'debug browser exposes subjects, Arabic, sessions and validation',
    (tester) async {
      tester.view.physicalSize = const Size(1200, 1600);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            locale: Locale('en'),
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            home: LearningContentBrowserScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Mathematics'), findsOneWidget);
      expect(find.text('English'), findsOneWidget);
      expect(find.text('Bahasa Melayu'), findsOneWidget);
      expect(find.text('Arabic'), findsOneWidget);
      expect(find.text('Logic'), findsOneWidget);
      expect(find.text('Science and discovery'), findsOneWidget);

      await tester.tap(find.text('Arabic'));
      await tester.pumpAndSettle();
      expect(find.text('arabic.letters.isolated'), findsWidgets);
      expect(find.text('اختر حرف ب'), findsOneWidget);
      expect(
        Directionality.of(tester.element(find.text('اختر حرف ب'))),
        TextDirection.rtl,
      );

      final buildButton = find.text('Build Test Session');
      await tester.ensureVisible(buildButton);
      await tester.tap(buildButton);
      await tester.pumpAndSettle();
      expect(find.textContaining('Test session · seed 6042'), findsOneWidget);

      final validationButton = find.text('Validate Learning Catalog');
      await tester.ensureVisible(validationButton);
      await tester.tap(validationButton);
      await tester.pumpAndSettle();
      expect(
        find.text('Valid · all learning catalog checks passed.'),
        findsOneWidget,
      );
    },
  );
}
