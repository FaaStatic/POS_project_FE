import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:ui/ui.dart';

import '../../../../app/di.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/usecases/logout_usecases.dart';
import '../bloc/auth_cubit.dart';

/// Signed-in user and sign-out. Sign-out is blocked while a tab waits for
/// QRIS/VA and asks before discarding open tabs.
class AccountSection extends StatelessWidget {
  const AccountSection({super.key, required this.beforeLogout});

  /// Unregisters the push token; returns it so the backend can drop it too.
  final Future<String?> Function() beforeLogout;

  Future<void> _logout(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final auth = context.read<AuthCubit>();
    final check = await getIt<CheckLogout>()();
    if (!context.mounted) return;
    if (check.blocked) {
      await showInfoDialog(context, l10n.logoutBlocked(check.awaitingTab!), kind: InfoKind.info);
      return;
    }
    if (check.needsConfirmation) {
      final ok = await showConfirmDialog(
        context,
        title: check.openTabs > 0 ? l10n.logoutConfirm(check.openTabs) : l10n.logout,
        message: check.pendingSales > 0 ? l10n.logoutPending(check.pendingSales) : null,
        confirmLabel: l10n.logoutAnyway,
        destructive: check.openTabs > 0,
      );
      if (!ok) return;
    }
    await getIt<DiscardDrafts>()();
    final token = await beforeLogout();
    await auth.logout(fcmToken: token);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final auth = context.watch<AuthCubit>().state;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (auth case AuthAuthenticated(:final Session session))
          Text(l10n.signedInAs(session.username), style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: Space.md),
        // Danger tonal: red text on a soft red fill, full width, so sign-out is findable but never the loudest thing.
        FilledButton.tonalIcon(
          onPressed: () => _logout(context),
          icon: const Icon(Iconsax.logout_copy),
          label: Text(l10n.logout),
          style: FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(TapSize.min),
            backgroundColor: Theme.of(context).colorScheme.errorContainer,
            foregroundColor: Theme.of(context).colorScheme.onErrorContainer,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.of(context).controlRadius)),
          ),
        ),
      ],
    );
  }
}
