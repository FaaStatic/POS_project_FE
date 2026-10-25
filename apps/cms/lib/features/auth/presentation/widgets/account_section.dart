import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui/ui.dart';

import '../../../../l10n/app_localizations.dart';
import '../bloc/auth_cubit.dart';

class AccountSection extends StatelessWidget {
  const AccountSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final auth = context.watch<AuthCubit>().state;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (auth case AuthAuthenticated(:final session)) Text(l10n.signedInAs(session.username), style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: Space.md),
        AppButton(label: l10n.logout, variant: AppButtonVariant.outline, onPressed: () => context.read<AuthCubit>().logout()),
      ],
    );
  }
}
