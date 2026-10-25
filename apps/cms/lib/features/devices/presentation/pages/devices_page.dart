import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:ui/ui.dart';

import '../../../../app/di.dart';
import '../../../../app/shell/cms_page.dart';
import '../../../../common/failure_text.dart';
import '../../../../common/feedback.dart';
import '../../../../common/widgets.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/devices_cubit.dart';

class DevicesPage extends StatelessWidget {
  const DevicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocProvider(
      create: (_) => getIt<DevicesCubit>()..load(),
      child: Builder(builder: (context) {
        final cubit = context.read<DevicesCubit>();
        final state = context.watch<DevicesCubit>().state;
        final Widget body;
        if (state.loading && state.items.isEmpty) {
          body = const LoadingView();
        } else if (state.failure != null) {
          body = ErrorState(message: l10n.loadFailed(failureText(context, state.failure!)), onRetry: () => cubit.load(state.platform));
        } else if (state.items.isEmpty) {
          body = EmptyState(icon: Iconsax.mobile, message: l10n.devicesEmpty);
        } else {
          body = ResponsiveTable<Device>(
            rows: state.items,
            rowKey: (d) => d.id,
            columns: [
              TableColumnSpec(label: l10n.user, flex: 2, cell: (_, d) => Text(d.username ?? l10n.unknownUser)),
              TableColumnSpec(label: l10n.platform, cell: (_, d) => Text(d.platform == DevicePlatform.ios ? 'iOS' : 'Android')),
              TableColumnSpec(label: l10n.lastActive, cell: (c, d) => Text(dateTimeText(c, d.lastUsedAt))),
              TableColumnSpec(label: 'Device ID', secondary: true, cell: (_, d) => Text(d.deviceId)),
            ],
            actions: (context, d) => TextButton(
              style: TextButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.error),
              onPressed: () async {
                final ok = await showConfirmDialog(
                  context,
                  title: l10n.revokeTitle(d.username ?? d.deviceId),
                  message: l10n.revokeHint,
                  confirmLabel: l10n.revoke,
                  destructive: true,
                );
                if (!ok || !context.mounted) return;
                final result = await cubit.revoke(d);
                if (context.mounted) showResult(context, result, l10n.deviceRevoked);
              },
              child: Text(l10n.revoke),
            ),
          );
        }
        return CmsPage(
          title: l10n.devicesTitle,
          body: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [FilterBar(children: [
              SegmentedButton<DevicePlatform?>(
                segments: [
                  ButtonSegment(value: null, label: Text(l10n.allPlatforms)),
                  const ButtonSegment(value: DevicePlatform.android, label: Text('Android')),
                  const ButtonSegment(value: DevicePlatform.ios, label: Text('iOS')),
                ],
                selected: {state.platform},
                onSelectionChanged: (s) => cubit.load(s.first),
              ),
            ]),
            Expanded(child: body),
          ]),
        );
      }),
    );
  }
}
