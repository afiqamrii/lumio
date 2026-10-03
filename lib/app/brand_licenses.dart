import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

void registerBrandFontLicenses() {
  const fonts = {
    'Sora': 'assets/ui/fonts/sora/OFL.txt',
    'Plus Jakarta Sans': 'assets/ui/fonts/plusjakartasans/OFL.txt',
    'Nunito': 'assets/brand/fonts/nunito/OFL.txt',
    'Lexend': 'assets/brand/fonts/lexend/OFL.txt',
    'Noto Sans Arabic': 'assets/brand/fonts/notosansarabic/OFL.txt',
  };
  for (final font in fonts.entries) {
    LicenseRegistry.addLicense(() async* {
      final license = await rootBundle.loadString(font.value);
      yield LicenseEntryWithLineBreaks([font.key], license);
    });
  }
}
