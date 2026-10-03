import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routing/app_routes.dart';
import '../../../core/widgets/adaptive_shell_frame.dart';
import '../../../core/widgets/navigation_placeholder.dart';
import '../../../l10n/generated/app_localizations.dart';

class ParentShell extends StatelessWidget {
  const ParentShell({
    super.key,
    required this.section,
    required this.child,
    this.onExitPreview,
  });
  final ParentSection section;
  final Widget child;
  final VoidCallback? onExitPreview;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final back = section != ParentSection.home
        ? () => context.goNamed(AppRoutes.parentHome.name)
        : onExitPreview;
    return AdaptiveShellFrame(
      title: strings.parentArea,
      navigationLabel: strings.parentNavigation,
      destinations: [
        for (final section in ParentSection.values)
          ShellDestination(
            id: section.route.name,
            label: section.label(strings),
            icon: section.icon,
          ),
      ],
      selectedIndex: section.index,
      onSelected: (index) =>
          context.goNamed(ParentSection.values[index].route.name),
      onBack: back,
      backLabel: section == ParentSection.home
          ? strings.returnToDevelopment
          : strings.backToParentHome,
      child: child,
    );
  }
}

class ParentPlaceholderScreen extends StatelessWidget {
  const ParentPlaceholderScreen({super.key, required this.section});
  final ParentSection section;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    return NavigationPlaceholder(
      title: section == ParentSection.home
          ? strings.parentHomeTitle
          : section.label(strings),
      description: switch (section) {
        ParentSection.home => strings.parentHomePlaceholder,
        ParentSection.children => strings.childrenPlaceholder,
        ParentSection.progress => strings.parentProgressPlaceholder,
        ParentSection.settings => strings.settingsPlaceholder,
      },
      icon: section.icon,
    );
  }
}

extension on ParentSection {
  String label(AppLocalizations strings) => switch (this) {
    ParentSection.home => strings.overviewDestination,
    ParentSection.children => strings.profilesDestination,
    ParentSection.progress => strings.progressDestination,
    ParentSection.settings => strings.settingsDestination,
  };
  IconData get icon => switch (this) {
    ParentSection.home => Icons.home_outlined,
    ParentSection.children => Icons.people_outline_rounded,
    ParentSection.progress => Icons.insights_rounded,
    ParentSection.settings => Icons.settings_outlined,
  };
}
