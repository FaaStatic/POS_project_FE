import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../features/sync/presentation/bloc/sync_cubit.dart';

/// Pull-to-refresh for the lists backed by the device cache: sends the queued offline
/// sales and re-reads products, categories and customers. Quiet, so a pull never opens
/// a report dialog unless something was actually sent.
class PullRefresh extends StatelessWidget {
  const PullRefresh({super.key, required this.child});
  final Widget child;

  /// A short list still has to be pullable.
  static const physics = AlwaysScrollableScrollPhysics();

  @override
  Widget build(BuildContext context) =>
      RefreshIndicator(onRefresh: () => context.read<SyncCubit>().syncNow(quiet: true), child: child);
}
