import 'package:flutter/material.dart';
import '../design_system.dart';
import 'lumio_action_surface.dart';
import 'responsive_content.dart';

class ShellDestination {
  const ShellDestination({
    required this.id,
    required this.label,
    required this.icon,
  });
  final String id;
  final String label;
  final IconData icon;
}

/// Shared adaptive presentation; parent/child routes still own their state.
class AdaptiveShellFrame extends StatelessWidget {
  const AdaptiveShellFrame({
    super.key,
    required this.title,
    required this.navigationLabel,
    required this.destinations,
    required this.selectedIndex,
    required this.onSelected,
    required this.child,
    required this.backLabel,
    this.onBack,
    this.playful = false,
  });
  final String title;
  final String navigationLabel;
  final List<ShellDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final Widget child;
  final String backLabel;
  final VoidCallback? onBack;
  final bool playful;

  @override
  Widget build(BuildContext context) => PopScope<Object?>(
    canPop: onBack == null,
    onPopInvokedWithResult: (didPop, result) {
      if (!didPop) onBack?.call();
    },
    child: Scaffold(
      backgroundColor: LumioColors.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final rail =
                constraints.maxWidth >= LayoutBreakpoints.expanded ||
                (constraints.maxWidth > constraints.maxHeight &&
                    constraints.maxHeight < LayoutBreakpoints.medium);
            final wideRail = constraints.maxWidth >= 1000;
            final largeText = MediaQuery.textScalerOf(context).scale(14) > 19;
            final actions = [
              for (var i = 0; i < destinations.length; i++)
                _DestinationAction(
                  key: ValueKey(destinations[i].id),
                  destination: destinations[i],
                  selected: i == selectedIndex,
                  rail: rail,
                  onTap: () {
                    if (i != selectedIndex) onSelected(i);
                  },
                ),
            ];
            final navigation = Semantics(
              container: true,
              label: navigationLabel,
              child: Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: LumioColors.navigation,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: LumioColors.outlineSubtle),
                  boxShadow: [
                    BoxShadow(
                      color: LumioColors.textPrimary.withValues(alpha: .04),
                      blurRadius: 24,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: rail
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          for (final action in actions)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 3),
                              child: SizedBox(
                                width: double.infinity,
                                child: action,
                              ),
                            ),
                        ],
                      )
                    : largeText
                    ? SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            for (final action in actions)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                child: ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    minWidth: 128,
                                  ),
                                  child: action,
                                ),
                              ),
                          ],
                        ),
                      )
                    : Row(
                        children: [
                          for (final action in actions) Expanded(child: action),
                        ],
                      ),
              ),
            );
            return Column(
              children: [
                Container(
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 10, 24, 10),
                  decoration: BoxDecoration(
                    color: LumioColors.surface,
                    border: Border(
                      bottom: BorderSide(color: LumioColors.outlineSubtle),
                    ),
                  ),
                  child: Row(
                    children: [
                      if (onBack != null) ...[
                        LumioIconButton(
                          icon: playful
                              ? Icons.arrow_back_rounded
                              : Icons.chevron_left_rounded,
                          label: backLabel,
                          onPressed: onBack,
                        ),
                        const SizedBox(width: 10),
                      ],
                      Expanded(
                        child: Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: Semantics(
                            container: true,
                            label: title,
                            child: const ExcludeSemantics(
                              child: LumioLogo(
                                variant: LumioLogoVariant.colorWordmark,
                                width: 94,
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (constraints.maxWidth >= 600 && !largeText)
                        ExcludeSemantics(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 13,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: LumioColors.primaryContainer,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  playful
                                      ? Icons.auto_awesome_rounded
                                      : Icons.space_dashboard_outlined,
                                  size: 15,
                                  color: LumioColors.primary,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  title,
                                  style: LumioTypography.labelMedium.copyWith(
                                    color: LumioColors.primaryPressed,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (rail)
                        SizedBox(
                          width: wideRail ? 212 : 180,
                          child: SingleChildScrollView(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                              16,
                              24,
                              0,
                              16,
                            ),
                            child: navigation,
                          ),
                        ),
                      Expanded(
                        child: Semantics(
                          container: true,
                          explicitChildNodes: true,
                          child: child,
                        ),
                      ),
                    ],
                  ),
                ),
                if (!rail)
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                      12,
                      0,
                      12,
                      10,
                    ),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 640),
                      child: navigation,
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    ),
  );
}

class _DestinationAction extends StatelessWidget {
  const _DestinationAction({
    super.key,
    required this.destination,
    required this.selected,
    required this.rail,
    required this.onTap,
  });
  final ShellDestination destination;
  final bool selected;
  final bool rail;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    final foreground = selected
        ? LumioColors.primaryPressed
        : LumioColors.textSecondary;
    return LumioActionSurface(
      label: destination.label,
      selected: selected,
      onTap: onTap,
      background: selected
          ? LumioColors.primaryContainer
          : LumioColors.transparent,
      foreground: foreground,
      borderWidth: 1,
      radius: BorderRadius.circular(18),
      padding: EdgeInsets.symmetric(
        horizontal: rail ? 12 : 5,
        vertical: rail ? 14 : 9,
      ),
      child: rail
          ? Row(
              children: [
                Icon(destination.icon, size: 22, color: foreground),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    destination.label,
                    style: LumioTypography.labelMedium.copyWith(
                      color: foreground,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                ),
              ],
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(destination.icon, size: 22, color: foreground),
                const SizedBox(height: 4),
                Text(
                  destination.label,
                  style: LumioTypography.labelMedium.copyWith(
                    color: foreground,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
    );
  }
}
