import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/design_system.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../application/profile_store.dart';

/// The real asynchronous local load, separate from the finite introduction.
class ProfileEntryScreen extends ConsumerWidget {
  const ProfileEntryScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = AppLocalizations.of(context);
    final state = ref.watch(profileStoreProvider);
    return LumioScaffold(
      child: LumioCard(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Center(child: LumioLogo(width: 200)),
            const SizedBox(height: LumioSpacing.lg),
            Semantics(
              liveRegion: true,
              child: Text(
                state.hasError ? s.profileLoadErrorTitle : s.loadingProfiles,
                style: LumioTypography.headingMedium,
              ),
            ),
            if (state.hasError) ...[
              const SizedBox(height: LumioSpacing.md),
              Text(s.profileLoadErrorInfo, style: LumioTypography.bodyMedium),
              const SizedBox(height: LumioSpacing.lg),
              LumioButton(
                label: s.retryAction,
                onPressed: () => ref.invalidate(profileStoreProvider),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
