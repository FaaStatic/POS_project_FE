import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../l10n/ui_localizations.dart';

/// Search input with a clear button. Hardware barcode scanners type into it and
/// press Enter, which arrives through [onSubmitted].
class SearchField extends StatefulWidget {
  const SearchField({
    super.key,
    required this.onChanged,
    this.onSubmitted,
    this.hint,
    this.controller,
    this.focusNode,
    this.autofocus = false,
    this.trailing,
  });

  final ValueChanged<String> onChanged;
  final ValueChanged<String>? onSubmitted;
  final String? hint;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool autofocus;
  final Widget? trailing;

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  late final TextEditingController _controller = widget.controller ?? TextEditingController();

  @override
  void dispose() {
    if (widget.controller == null) _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = UiLocalizations.of(context);
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) => TextField(
        controller: _controller,
        focusNode: widget.focusNode,
        autofocus: widget.autofocus,
        textInputAction: TextInputAction.search,
        onChanged: widget.onChanged,
        onSubmitted: widget.onSubmitted,
        style: Theme.of(context).textTheme.bodyLarge,
        decoration: InputDecoration(
          hintText: widget.hint ?? l10n.search,
          prefixIcon: const Icon(Iconsax.search_normal_1),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_controller.text.isNotEmpty)
                IconButton(
                  tooltip: l10n.clearSearch,
                  icon: const Icon(Iconsax.close_circle),
                  onPressed: () {
                    _controller.clear();
                    widget.onChanged('');
                  },
                ),
              ?widget.trailing,
            ],
          ),
        ),
      ),
    );
  }
}
