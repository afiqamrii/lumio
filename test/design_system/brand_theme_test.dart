import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumio/core/constants/brand_assets.dart';
import 'package:lumio/core/design_system.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('raw palette matches every official brand and functional color', () {
    final source =
        jsonDecode(
              File(
                'lumio-assets/brand/05-colors/lumio-colors.json',
              ).readAsStringSync(),
            )
            as Map<String, dynamic>;
    final entries = <String, dynamic>{
      ...source['palette'] as Map<String, dynamic>,
      ...source['functional'] as Map<String, dynamic>,
    };
    expect(LumioPalette.values.keys.toSet(), entries.keys.toSet());
    for (final entry in entries.entries) {
      final hex = (entry.value as Map<String, dynamic>)['hex'] as String;
      expect(
        LumioPalette.values[entry.key]!.toARGB32(),
        int.parse('FF${hex.substring(1)}', radix: 16),
        reason: entry.key,
      );
    }
  });

  test('each bundled brand file is an unchanged source asset', () async {
    final selection =
        jsonDecode(File('docs/ASSET_SELECTION.json').readAsStringSync())
            as Map<String, dynamic>;
    for (final entry in selection['files'] as List<dynamic>) {
      final bundle = await rootBundle.load(entry['asset'] as String);
      final original = await File(entry['source'] as String).readAsBytes();
      expect(
        listEquals(
          bundle.buffer.asUint8List(bundle.offsetInBytes, bundle.lengthInBytes),
          original,
        ),
        isTrue,
        reason: entry['asset'] as String,
      );
    }
  });

  test('all original SVG logos decode into renderable pictures', () async {
    for (final asset in BrandAssets.logos) {
      final picture = await vg.loadPicture(SvgAssetLoader(asset), null);
      expect(picture.size.width, greaterThan(0), reason: asset);
      expect(picture.size.height, greaterThan(0), reason: asset);
      picture.picture.dispose();
    }
  });

  test('both official mascot reactions decode at source resolution', () async {
    for (final asset in BrandAssets.mascots) {
      final data = await rootBundle.load(asset);
      final codec = await ui.instantiateImageCodec(
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
      );
      final frame = await codec.getNextFrame();
      expect(frame.image.width, 1254, reason: asset);
      expect(frame.image.height, 1254, reason: asset);
      frame.image.dispose();
      codec.dispose();
    }
  });

  testWidgets('logo variants and mascot poses load without widget errors', (
    tester,
  ) async {
    for (final variant in LumioLogoVariant.values) {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: LumioLogo(variant: variant)),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(SvgPicture), findsOneWidget);
      expect(tester.takeException(), isNull);
    }
    for (final pose in LumiPose.values) {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: LumiMascot(pose: pose)),
        ),
      );
      await tester.pumpAndSettle();
      expect(
        (tester.widget<Image>(find.byType(Image)).image as ResizeImage)
            .imageProvider,
        isA<AssetImage>(),
      );
      expect(tester.takeException(), isNull);
    }
  });

  test(
    'runtime font manifest maps the new families and Arabic fallback correctly',
    () async {
      final manifest =
          jsonDecode(await rootBundle.loadString('FontManifest.json'))
              as List<dynamic>;
      for (final entry in {
        'Sora': 'assets/ui/fonts/sora/Sora[wght].ttf',
        'PlusJakartaSans':
            'assets/ui/fonts/plusjakartasans/PlusJakartaSans[wght].ttf',
        'NotoSansArabic':
            'assets/brand/fonts/notosansarabic/NotoSansArabic[wdth,wght].ttf',
      }.entries) {
        final families = manifest
            .where((item) => item['family'] == entry.key)
            .toList();
        expect(families, hasLength(1));
        expect(families.single['fonts'], hasLength(1));
        expect(
          Uri.decodeFull(families.single['fonts'][0]['asset'] as String),
          entry.value,
        );
        expect(
          (await rootBundle.load(entry.value)).lengthInBytes,
          greaterThan(10000),
        );
      }
    },
  );

  test(
    'light theme initializes with semantic roles and licensed typography',
    () {
      final theme = LumioTheme.light;
      expect(theme.brightness, Brightness.light);
      expect(theme.colorScheme.primary, LumioColors.primary);
      expect(theme.scaffoldBackgroundColor, LumioColors.background);
      expect(theme.textTheme.displayLarge!.fontFamily, 'Sora');
      expect(theme.textTheme.bodyMedium!.fontFamily, 'PlusJakartaSans');
      expect(
        theme.textTheme.bodyMedium!.fontFamilyFallback,
        contains('NotoSansArabic'),
      );
      expect(
        theme.filledButtonTheme.style!.minimumSize!.resolve({}),
        const Size(56, 56),
      );
    },
  );
}
