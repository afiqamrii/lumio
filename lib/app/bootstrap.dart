import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/config/app_config.dart';
import '../services/app_logger.dart';
import 'brand_licenses.dart';
import 'lumio_app.dart';

Future<void> bootstrap({AppLogger logger = const DebugAppLogger()}) async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (details) {
    logger.error(
      'framework_error',
      details.exception,
      details.stack ?? StackTrace.current,
    );
    if (kDebugMode) {
      FlutterError.presentError(details);
    }
  };
  PlatformDispatcher.instance.onError = (error, stackTrace) {
    logger.error('unhandled_error', error, stackTrace);
    return true;
  };

  // Fail clearly on a misspelled build environment before launching.
  final config = AppConfig.fromEnvironment();
  registerBrandFontLicenses();
  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }
  runApp(ProviderScope(child: LumioApp(config: config)));
}
