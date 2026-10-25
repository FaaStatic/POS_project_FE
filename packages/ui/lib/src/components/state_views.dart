import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../l10n/ui_localizations.dart';
import '../tokens/spacing.dart';
import 'app_button.dart';

/// Empty state: names the cause and offers at most one action.
class EmptyState extends StatelessWidget {
  const EmptyState({super.key, required this.message, this.actionLabel, this.onAction, this.icon});

  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final IconData? icon;

  @override
  Widget build(BuildContext context) => _StateBody(
        icon: icon,
        message: message,
        action: actionLabel == null
            ? null
            : AppButton(label: actionLabel!, onPressed: onAction, variant: AppButtonVariant.outline),
      );
}

/// Error state: says what failed and how to retry.
class ErrorState extends StatelessWidget {
  const ErrorState({super.key, required this.message, this.onRetry});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) => _StateBody(
        icon: Iconsax.warning_2,
        iconColor: Theme.of(context).colorScheme.error,
        message: message,
        action: onRetry == null
            ? null
            : AppButton(
                label: UiLocalizations.of(context).retry,
                onPressed: onRetry,
                variant: AppButtonVariant.outline,
              ),
      );
}

class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) => Center(
        child: Semantics(
          label: UiLocalizations.of(context).loading,
          child: const CircularProgressIndicator(),
        ),
      );
}

class _StateBody extends StatelessWidget {
  const _StateBody({required this.message, this.icon, this.iconColor, this.action});

  final String message;
  final IconData? icon;
  final Color? iconColor;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(Space.xl),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 40, color: iconColor ?? theme.colorScheme.onSurfaceVariant),
                const SizedBox(height: Space.md),
              ],
              Text(message, textAlign: TextAlign.center, style: theme.textTheme.bodyLarge),
              if (action != null) ...[const SizedBox(height: Space.lg), action!],
            ],
          ),
        ),
      ),
    );
  }
}
