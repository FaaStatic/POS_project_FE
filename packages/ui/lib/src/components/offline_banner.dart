import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../l10n/ui_localizations.dart';
import '../theme/status_colors.dart';
import '../tokens/spacing.dart';

/// Kasir offline banner with the pending transaction count and an optional sync action.
class OfflineBanner extends StatelessWidget {
  const OfflineBanner({
    super.key,
    required this.offline,
    required this.pendingCount,
    this.syncLabel,
    this.onSync,
    this.syncing = false,
  });

  final bool offline;
  final int pendingCount;
  final String? syncLabel;
  final VoidCallback? onSync;
  final bool syncing;

  @override
  Widget build(BuildContext context) {
    if (!offline && pendingCount == 0) return const SizedBox.shrink();
    final l10n = UiLocalizations.of(context);
    final status = StatusColors.of(context);
    final theme = Theme.of(context);
    final parts = [if (offline) l10n.offlineBanner, if (pendingCount > 0) l10n.pendingCount(pendingCount)];
    return Semantics(
      liveRegion: true,
      container: true,
      child: Material(
        color: status.warningContainer,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Space.lg, vertical: Space.xs),
          child: Row(
            children: [
              Icon(offline ? Iconsax.cloud_cross : Iconsax.cloud_change, color: status.warning),
              const SizedBox(width: Space.sm),
              Expanded(child: Text(parts.join(' · '), style: theme.textTheme.bodyMedium)),
              if (syncLabel != null && pendingCount > 0)
                TextButton(
                  onPressed: syncing ? null : onSync,
                  child: syncing
                      ? const SizedBox.square(dimension: 18, child: CircularProgressIndicator(strokeWidth: 2))
                      : Text(syncLabel!),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
