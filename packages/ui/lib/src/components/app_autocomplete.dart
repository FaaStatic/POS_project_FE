import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../l10n/ui_localizations.dart';
import '../theme/app_theme.dart';
import 'app_text_field.dart';
import 'options_panel.dart';

/// A text field with a dropdown of [options] that narrows as you type. An empty field lists
/// every option, so it works as a select that can also be searched.
///
/// With [createLabel] the typed text that matches no option is offered as its own row
/// ("Buat \"Snack\""), for fields that may introduce a new value. Without it the field is a pick
/// from [options], and the caller's [validator] decides whether other text is acceptable.
class AppAutocomplete extends StatefulWidget {
  const AppAutocomplete({
    super.key,
    required this.label,
    required this.controller,
    required this.options,
    this.hint,
    this.validator,
    this.createLabel,
  });

  final String label;
  final TextEditingController controller;
  final List<String> options;
  final String? hint;
  final FormFieldValidator<String>? validator;
  final String Function(String text)? createLabel;

  @override
  State<AppAutocomplete> createState() => _AppAutocompleteState();
}

class _AppAutocompleteState extends State<AppAutocomplete> {
  final _focus = FocusNode();
  final _group = Object();

  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  bool _isOption(String text) => widget.options.any((o) => o.toLowerCase() == text.trim().toLowerCase());

  Iterable<String> _optionsFor(TextEditingValue value) {
    final query = value.text.trim().toLowerCase();
    final matches = widget.options.where((o) => o.toLowerCase().contains(query)).toList();
    final create = widget.createLabel != null && query.isNotEmpty && !_isOption(value.text);
    return [...matches, if (create) value.text.trim()];
  }

  // Closing is losing focus; the options reopen when focus returns.
  void _toggle() => _focus.hasFocus ? _focus.unfocus() : _focus.requestFocus();

  @override
  Widget build(BuildContext context) {
    final l10n = UiLocalizations.of(context);
    final sizes = AppSizes.of(context);
    return LayoutBuilder(
      builder: (context, constraints) => RawAutocomplete<String>(
        textEditingController: widget.controller,
        focusNode: _focus,
        optionsBuilder: _optionsFor,
        fieldViewBuilder: (context, controller, focusNode, onSubmitted) => AppTextField(
          label: widget.label,
          hint: widget.hint,
          controller: controller,
          focusNode: focusNode,
          groupId: _group,
          validator: widget.validator,
          // Enter picks the highlighted option; without this the field swallows it.
          onSubmitted: (_) => onSubmitted(),
          suffix: Tooltip(
            message: l10n.showOptions,
            child: ShadIconButton.ghost(
              width: sizes.control - 8,
              height: sizes.control - 8,
              icon: Icon(Iconsax.arrow_down_1_copy, size: sizes.compact ? 16 : 20),
              onPressed: _toggle,
            ),
          ),
        ),
        optionsViewBuilder: (context, onSelected, options) => OptionsPanel<String>(
          groupId: _group,
          width: constraints.maxWidth,
          options: options.toList(),
          label: (o) => widget.options.contains(o) ? o : widget.createLabel!(o),
          onSelected: onSelected,
        ),
      ),
    );
  }
}
