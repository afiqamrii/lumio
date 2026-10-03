import 'package:flutter/material.dart';

import '../../../../core/design_system.dart';
import '../../../../core/widgets/lumio_action_surface.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../progression/domain/progression_models.dart';
import '../../domain/learning_world.dart';
import '../world_presentation.dart';

class LumioWorldNode extends StatefulWidget {
  const LumioWorldNode({
    super.key,
    required this.world,
    required this.unlocked,
    required this.onPressed,
    this.progress,
  });

  final LearningWorld world;
  final bool unlocked;
  final WorldProgress? progress;
  final VoidCallback onPressed;

  @override
  State<LumioWorldNode> createState() => _LumioWorldNodeState();
}

class _LumioWorldNodeState extends State<LumioWorldNode>
    with SingleTickerProviderStateMixin {
  late final AnimationController _lockedReaction;

  @override
  void initState() {
    super.initState();
    _lockedReaction = AnimationController(
      vsync: this,
      duration: LumioMotion.standard,
    );
  }

  @override
  void dispose() {
    _lockedReaction.dispose();
    super.dispose();
  }

  void _activate() {
    if (!widget.unlocked && !LumioMotion.reduced(context)) {
      _lockedReaction.forward(from: 0);
    }
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final enlarged = MediaQuery.textScalerOf(context).scale(14) > 19;
    final title = widget.world.title(strings);
    final progress = widget.progress;
    final status = widget.unlocked ? strings.openStatus : strings.lockedStatus;
    return AnimatedBuilder(
      animation: _lockedReaction,
      builder: (context, child) {
        final direction = (_lockedReaction.value * 5).round().isEven
            ? 1.0
            : -1.0;
        final offset = _lockedReaction.value == 0
            ? 0.0
            : (1 - _lockedReaction.value) * 5 * direction;
        return Transform.translate(offset: Offset(offset, 0), child: child);
      },
      child: SizedBox(
        width: enlarged ? 260 : 214,
        child: LumioActionSurface(
          label: '$title, ${widget.world.subject(strings)}',
          semanticValue: status,
          onTap: _activate,
          background: LumioColors.transparent,
          foreground: LumioColors.textPrimary,
          padding: EdgeInsets.zero,
          radius: BorderRadius.circular(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 176,
                    height: 94,
                    decoration: BoxDecoration(
                      color: widget.world.color,
                      borderRadius: const BorderRadius.all(
                        Radius.elliptical(88, 48),
                      ),
                      border: Border.all(
                        color: widget.unlocked
                            ? widget.world.accent.withValues(alpha: .35)
                            : LumioColors.outlineSubtle,
                        width: 2,
                      ),
                      boxShadow: widget.unlocked
                          ? [
                              BoxShadow(
                                color: widget.world.accent.withValues(
                                  alpha: .16,
                                ),
                                blurRadius: 18,
                                offset: const Offset(0, 7),
                              ),
                            ]
                          : null,
                    ),
                  ),
                  Positioned(
                    top: 8,
                    child: Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: LumioColors.surface,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: widget.world.accent,
                          width: 3,
                        ),
                      ),
                      child: Icon(
                        widget.world.icon,
                        size: 38,
                        color: widget.world.accent,
                      ),
                    ),
                  ),
                  if (!widget.unlocked)
                    PositionedDirectional(
                      top: -6,
                      end: 12,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: LumioColors.textPrimary,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.lock_rounded,
                          size: 20,
                          color: LumioColors.surface,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: LumioTypography.headingSmall,
              ),
              const SizedBox(height: 3),
              Text(
                widget.world.subject(strings),
                textAlign: TextAlign.center,
                style: LumioTypography.bodySmall.copyWith(
                  color: LumioColors.textSecondary,
                ),
              ),
              if (progress != null && progress.completedMissions > 0) ...[
                const SizedBox(height: 6),
                Text(
                  strings.worldStarProgress(
                    progress.totalStars,
                    progress.completedMissions,
                  ),
                  style: LumioTypography.labelMedium.copyWith(
                    color: LumioColors.textSecondary,
                  ),
                ),
              ],
              if (!widget.unlocked) ...[
                const SizedBox(height: 6),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.lock_rounded,
                      size: 16,
                      color: LumioColors.textSecondary,
                    ),
                    const SizedBox(width: 5),
                    Text(status, style: LumioTypography.labelMedium),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
