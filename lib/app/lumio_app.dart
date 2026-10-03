import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/config/app_config.dart';
import '../core/routing/app_router.dart';
import '../core/theme/lumio_colors.dart';
import '../core/theme/lumio_theme.dart';
import '../l10n/generated/app_localizations.dart';

class LumioApp extends ConsumerWidget {
  const LumioApp({super.key, required this.config, this.locale});

  final AppConfig config;

  /// Uses the system locale by default; injectable for localisation tests.
  final Locale? locale;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context).appName,
      debugShowCheckedModeBanner: false,
      theme: LumioTheme.light,
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, child) => AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: LumioColors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
          systemNavigationBarColor: LumioColors.transparent,
          systemNavigationBarIconBrightness: Brightness.dark,
          systemNavigationBarContrastEnforced: true,
          systemStatusBarContrastEnforced: false,
        ),
        child: config.profileSandboxEnabled
            ? Banner(
                message: 'PROFILE SANDBOX',
                location: BannerLocation.topEnd,
                color: LumioColors.primary,
                child: child ?? const SizedBox.shrink(),
              )
            : child ?? const SizedBox.shrink(),
      ),
      routerConfig: ref.watch(appRouterProvider(config)),
    );
  }
}
