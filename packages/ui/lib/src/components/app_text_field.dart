import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../l10n/ui_localizations.dart';
import '../theme/app_theme.dart';
import '../tokens/spacing.dart';

/// shadcn input with its label above it. [password] adds a show/hide toggle with an accessible label.
class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    required this.label,
    this.controller,
    this.initialValue,
    this.hint,
    this.helper,
    this.errorText,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.autofillHints,
    this.password = false,
    this.enabled = true,
    this.autofocus = false,
    this.maxLines = 1,
    this.prefixIcon,
    this.focusNode,
  });

  final String label;
  final TextEditingController? controller;
  final String? initialValue;
  final String? hint;
  final String? helper;
  final String? errorText;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final Iterable<String>? autofillHints;
  final bool password;
  final bool enabled;
  final bool autofocus;
  final int maxLines;
  final IconData? prefixIcon;
  final FocusNode? focusNode;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool _obscured = true;

  @override
  Widget build(BuildContext context) {
    final l10n = UiLocalizations.of(context);
    final theme = Theme.of(context);
    final sizes = AppSizes.of(context);
    final iconSize = sizes.compact ? 16.0 : 20.0;
    final validator = widget.validator;
    return MergeSemantics(
      child: ShadInputFormField(
        label: Text(widget.label, style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w500)),
        description: widget.helper == null ? null : Text(widget.helper!),
        forceErrorText: widget.errorText,
        validator: validator == null ? null : (v) => validator(v),
        controller: widget.controller,
        initialValue: widget.controller == null ? widget.initialValue : null,
        focusNode: widget.focusNode,
        enabled: widget.enabled,
        autofocus: widget.autofocus,
        obscureText: widget.password && _obscured,
        maxLines: widget.password ? 1 : widget.maxLines,
        keyboardType: widget.keyboardType,
        textInputAction: widget.textInputAction,
        inputFormatters: widget.inputFormatters,
        autofillHints: widget.autofillHints,
        onChanged: widget.onChanged,
        onSubmitted: widget.onSubmitted,
        placeholder: widget.hint == null ? null : Text(widget.hint!),
        // The toggle lays out at control - 4; 2 above and below keeps the field as tall as the others.
        padding: widget.password ? const EdgeInsets.fromLTRB(Space.md, 2, 2, 2) : null,
        leading: widget.prefixIcon == null ? null : Icon(widget.prefixIcon, size: iconSize, color: theme.colorScheme.onSurfaceVariant),
        trailing: widget.password
            ? Tooltip(
                message: _obscured ? l10n.showPassword : l10n.hidePassword,
                child: ShadIconButton.ghost(
                  width: sizes.control - 8,
                  height: sizes.control - 8,
                  icon: Icon(_obscured ? Iconsax.eye_copy : Iconsax.eye_slash_copy, size: iconSize),
                  onPressed: () => setState(() => _obscured = !_obscured),
                ),
              )
            : null,
      ),
    );
  }
}
