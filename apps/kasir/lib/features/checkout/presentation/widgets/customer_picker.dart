import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:ui/ui.dart';

import '../../../../app/di.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../common/catalog/catalog_cubits.dart';

/// Returns the picked customer, a record of nulls for "no customer", or null when dismissed.
Future<({String? id, String? name})?> showCustomerPicker(BuildContext context) =>
    showModalBottomSheet<({String? id, String? name})>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => BlocProvider(create: (_) => getIt<CustomersCubit>()..search(''), child: const _CustomerPicker()),
    );

class _CustomerPicker extends StatelessWidget {
  const _CustomerPicker();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = context.watch<CustomersCubit>().state;
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.85,
      builder: (context, controller) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Space.lg),
            child: SearchField(
              hint: l10n.searchCustomers,
              autofocus: true,
              onChanged: context.read<CustomersCubit>().search,
            ),
          ),
          ListTile(
            leading: const Icon(Iconsax.user_remove),
            title: Text(l10n.noCustomer),
            onTap: () => Navigator.pop(context, (id: null, name: null)),
          ),
          const Divider(),
          Expanded(
            child: state.loading
                ? const LoadingView()
                : state.customers.isEmpty
                ? EmptyState(message: l10n.customersEmpty)
                : ListView.builder(
                    controller: controller,
                    itemCount: state.customers.length,
                    itemBuilder: (context, i) {
                      final Customer c = state.customers[i];
                      return ListTile(
                        key: ValueKey(c.id),
                        title: Text(c.name),
                        subtitle: c.phone.isEmpty ? null : Text(c.phone),
                        onTap: () => Navigator.pop(context, (id: c.id, name: c.name)),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
