import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../l10n/ui_localizations.dart';
import '../theme/app_theme.dart';

/// shadcn search input with a clear button. Hardware barcode scanners type into
/// it and press Enter, which arrives through [onSubmitted].
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
    final sizes = AppSizes.of(context);
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;
    final iconSize = sizes.compact ? 16.0 : 20.0;
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) => ShadInput(
        controller: _controller,
        focusNode: widget.focusNode,
        autofocus: widget.autofocus,
        textInputAction: TextInputAction.search,
        onChanged: widget.onChanged,
        onSubmitted: widget.onSubmitted,
        placeholder: Text(widget.hint ?? l10n.search),
        leading: Icon(Iconsax.search_normal_1_copy, size: iconSize, color: muted),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_controller.text.isNotEmpty)
              Tooltip(
                message: l10n.clearSearch,
                child: ShadIconButton.ghost(
                  width: sizes.control - 8,
                  height: sizes.control - 8,
                  icon: Icon(Iconsax.close_circle_copy, size: iconSize),
                  onPressed: () {
                    _controller.clear();
                    widget.onChanged('');
                  },
                ),
              ),
            ?widget.trailing,
          ],
        ),
      ),
    );
  }
}
