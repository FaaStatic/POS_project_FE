import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../tokens/spacing.dart';

/// The dropdown list under an autocomplete field: a bordered surface with one row per option.
class OptionsPanel<T extends Object> extends StatelessWidget {
  const OptionsPanel({
    super.key,
    required this.groupId,
    required this.width,
    required this.options,
    required this.label,
    required this.onSelected,
  });
  final Object groupId;
  final double width;
  final List<T> options;
  final String Function(T option) label;
  final AutocompleteOnSelected<T> onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final highlighted = AutocompleteHighlightedOption.of(context);
    // The panel lives in the overlay, outside the field; without the shared group a mouse press
    // on a row counts as a tap outside, the field drops focus, and the list closes first.
    return TextFieldTapRegion(
      groupId: groupId,
      child: Align(
        alignment: AlignmentDirectional.topStart,
        child: Padding(
          padding: const EdgeInsets.only(top: Space.xs),
          child: Material(
            elevation: 4,
            color: theme.colorScheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                AppSizes.of(context).controlRadius,
              ),
              side: BorderSide(color: theme.colorScheme.outlineVariant),
            ),
            clipBehavior: Clip.antiAlias,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: width, maxHeight: 240),
              child: SizedBox(
                width: width,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: Space.xs),
                  shrinkWrap: true,
                  itemCount: options.length,
                  itemBuilder: (context, i) => InkWell(
                    onTap: () => onSelected(options[i]),
                    child: Container(
                      color: i == highlighted
                          ? theme.colorScheme.primaryContainer
                          : null,
                      constraints: BoxConstraints(
                        minHeight: AppSizes.of(context).control,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: Space.md,
                        vertical: Space.sm,
                      ),
                      alignment: AlignmentDirectional.centerStart,
                      child: Text(
                        label(options[i]),
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
