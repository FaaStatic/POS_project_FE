import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../l10n/ui_localizations.dart';
import '../tokens/spacing.dart';

/// Attribution for the Dribbble shot a screen's design follows. Each app opens
/// the link its own way (web window vs. url_launcher), so it passes [onOpen].
class DesignCredit extends StatelessWidget {
  const DesignCredit({super.key, required this.title, required this.author, required this.onOpen});

  final String title;
  final String author;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = theme.colorScheme.onSurfaceVariant;
    final text = UiLocalizations.of(context).designCredit(title, author);
    return Semantics(
      link: true,
      label: text,
      excludeSemantics: true,
      child: InkWell(
        onTap: onOpen,
        borderRadius: BorderRadius.circular(Radii.small),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Space.sm, vertical: Space.md),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Iconsax.dribbble_copy, size: 16, color: muted),
              const SizedBox(width: Space.sm),
              Flexible(
                child: Text(
                  text,
                  style: theme.textTheme.bodySmall?.copyWith(color: muted, decoration: TextDecoration.underline, decorationColor: muted),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
