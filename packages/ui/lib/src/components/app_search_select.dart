import 'dart:async';

import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../l10n/ui_localizations.dart';
import '../theme/app_theme.dart';
import 'app_text_field.dart';
import 'options_panel.dart';

/// A text field whose dropdown is filled by [search], for lists too long to hold in memory
/// (customers). Focusing the empty field lists the first results; typing narrows them after a
/// short pause. [onChanged] reports the picked value, and null again as soon as the text is
/// edited away from it, so the caller never holds a pick the field no longer shows.
class AppSearchSelect<T extends Object> extends StatefulWidget {
  const AppSearchSelect({
    super.key,
    required this.label,
    required this.search,
    required this.labelOf,
    required this.onChanged,
    this.hint,
    this.errorText,
    this.autofocus = false,
    this.debounce = const Duration(milliseconds: 300),
  });

  final String label;
  final String? hint;
  final String? errorText;
  final bool autofocus;
  final Duration debounce;

  /// Called with the trimmed text; empty text asks for the first results.
  final Future<List<T>> Function(String query) search;
  final String Function(T option) labelOf;
  final ValueChanged<T?> onChanged;

  @override
  State<AppSearchSelect<T>> createState() => _AppSearchSelectState<T>();
}

class _AppSearchSelectState<T extends Object> extends State<AppSearchSelect<T>> {
  final _focus = FocusNode();
  final _controller = TextEditingController();
  final _group = Object();
  T? _picked;

  /// A newer keystroke or focus makes every earlier search stale.
  int _generation = 0;

  @override
  void dispose() {
    _focus.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<Iterable<T>> _options(TextEditingValue value) async {
    final generation = ++_generation;
    final text = value.text.trim();
    // Typing waits for a pause; opening the empty field does not.
    if (text.isNotEmpty) await Future<void>.delayed(widget.debounce);
    if (!mounted || generation != _generation) return const [];
    final found = await widget.search(text);
    return generation == _generation ? found : const [];
  }

  void _edited(String text) {
    final picked = _picked;
    if (picked != null && text != widget.labelOf(picked)) {
      _picked = null;
      widget.onChanged(null);
    }
  }

  void _toggle() => _focus.hasFocus ? _focus.unfocus() : _focus.requestFocus();

  @override
  Widget build(BuildContext context) {
    final l10n = UiLocalizations.of(context);
    final sizes = AppSizes.of(context);
    return LayoutBuilder(
      builder: (context, constraints) => RawAutocomplete<T>(
        textEditingController: _controller,
        focusNode: _focus,
        displayStringForOption: widget.labelOf,
        optionsBuilder: _options,
        onSelected: (option) {
          _picked = option;
          widget.onChanged(option);
        },
        fieldViewBuilder: (context, controller, focusNode, onSubmitted) => AppTextField(
          label: widget.label,
          hint: widget.hint,
          controller: controller,
          focusNode: focusNode,
          groupId: _group,
          autofocus: widget.autofocus,
          errorText: widget.errorText,
          onChanged: _edited,
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
        optionsViewBuilder: (context, onSelected, options) => OptionsPanel<T>(
          groupId: _group,
          width: constraints.maxWidth,
          options: options.toList(),
          label: widget.labelOf,
          onSelected: onSelected,
        ),
      ),
    );
  }
}
