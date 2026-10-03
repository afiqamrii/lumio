import 'package:flutter/material.dart';
import '../design_system.dart';
import 'lumio_action_surface.dart';

/// A recessed writing surface with a soft illuminated rim on keyboard focus.
/// The native form field retains selection, validation, autofill and semantics.
class LumioTextField extends StatefulWidget {
  const LumioTextField({
    super.key,
    this.controller,
    this.initialValue,
    this.hintText,
    this.icon,
    this.validator,
    this.onChanged,
    this.textCapitalization = TextCapitalization.none,
    this.textInputAction,
    this.onFieldSubmitted,
    this.enabled = true,
    this.autocorrect = true,
  });

  final TextEditingController? controller;
  final String? initialValue;
  final String? hintText;
  final IconData? icon;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final TextCapitalization textCapitalization;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onFieldSubmitted;
  final bool enabled;
  final bool autocorrect;

  @override
  State<LumioTextField> createState() => _LumioTextFieldState();
}

class _LumioTextFieldState extends State<LumioTextField> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) => Focus(
    onFocusChange: (value) => setState(() => _focused = value),
    child: AnimatedContainer(
      duration: LumioMotion.duration(context, LumioMotion.fast),
      padding: const EdgeInsets.all(1.5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(21),
        gradient: LinearGradient(
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
          colors: _focused
              ? [LumioColors.primary, LumioColors.secondary]
              : [LumioColors.controlOutline, LumioColors.outlineSubtle],
        ),
        boxShadow: [
          BoxShadow(
            color: LumioColors.primary.withValues(alpha: _focused ? .1 : .025),
            blurRadius: _focused ? 22 : 8,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: widget.enabled
              ? LumioColors.surface
              : LumioColors.surfaceSubtle,
          borderRadius: BorderRadius.circular(19.5),
        ),
        child: TextFormField(
          controller: widget.controller,
          initialValue: widget.initialValue,
          validator: widget.validator,
          onChanged: widget.onChanged,
          textCapitalization: widget.textCapitalization,
          textInputAction: widget.textInputAction,
          onFieldSubmitted: widget.onFieldSubmitted,
          enabled: widget.enabled,
          autocorrect: widget.autocorrect,
          style: LumioTypography.bodyMedium.copyWith(
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: widget.hintText,
            filled: false,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 21,
            ),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            // Validation remains visibly distinct inside the illuminated rim.
            errorBorder: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(19),
              borderSide: const BorderSide(color: LumioColors.error, width: 2),
            ),
            focusedErrorBorder: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(19),
              borderSide: const BorderSide(color: LumioColors.error, width: 2),
            ),
            prefixIcon: widget.icon == null
                ? null
                : Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                      12,
                      10,
                      10,
                      10,
                    ),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: _focused
                            ? LumioColors.primaryContainer
                            : LumioColors.surfaceSubtle,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        widget.icon,
                        size: 21,
                        color: LumioColors.primary,
                      ),
                    ),
                  ),
          ),
        ),
      ),
    ),
  );
}

/// Persistent labels wrap independently of input text and never float or clip.
class LumioFieldGroup extends StatelessWidget {
  const LumioFieldGroup({
    super.key,
    required this.label,
    required this.child,
    this.help,
  });
  final String label;
  final String? help;
  final Widget child;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Text(
        label,
        style: LumioTypography.labelMedium.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      const SizedBox(height: 10),
      child,
      if (help != null) ...[
        const SizedBox(height: 9),
        Text(
          help!,
          style: LumioTypography.bodySmall.copyWith(
            color: LumioColors.textSecondary,
          ),
        ),
      ],
    ],
  );
}

/// Branded single-choice tiles with visible and announced selection state.
class LumioFormChoice extends StatelessWidget {
  const LumioFormChoice({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.leading,
    this.compact = false,
  });
  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final Widget? leading;
  final bool compact;
  @override
  Widget build(BuildContext context) => LumioActionSurface(
    label: label,
    selected: selected,
    onTap: onTap,
    background: selected ? LumioColors.primaryContainer : LumioColors.surface,
    foreground: selected ? LumioColors.primaryPressed : LumioColors.textPrimary,
    borderColor: selected ? LumioColors.primary : LumioColors.outlineSubtle,
    borderWidth: selected ? 1.5 : 1,
    radius: BorderRadius.circular(18),
    padding: EdgeInsets.symmetric(
      horizontal: leading != null ? 4 : (compact ? 12 : 16),
      vertical: 14,
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (leading != null) ...[leading!, const SizedBox(height: 8)],
        Text(
          label,
          textAlign: TextAlign.center,
          style:
              (compact
                      ? LumioTypography.headingSmall
                      : LumioTypography.labelMedium)
                  .copyWith(
                    color: selected
                        ? LumioColors.primaryPressed
                        : LumioColors.textPrimary,
                  ),
        ),
      ],
    ),
  );
}
