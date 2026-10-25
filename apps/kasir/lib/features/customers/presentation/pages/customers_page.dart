import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:ui/ui.dart';

import '../../../../app/di.dart';
import '../../../../app/shell/kasir_page.dart';
import '../../../../common/catalog/catalog_cubits.dart';
import '../../../../l10n/app_localizations.dart';

class CustomersPage extends StatelessWidget {
  const CustomersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocProvider(
      create: (_) => getIt<CustomersCubit>()..search(''),
      child: Builder(builder: (context) {
        final state = context.watch<CustomersCubit>().state;
        return KasirPage(
          title: l10n.customersTitle,
          actions: [
            TextButton.icon(
              onPressed: () => context.push('/customers/new'),
              icon: const Icon(Iconsax.user_add),
              label: Text(l10n.addCustomer),
            ),
          ],
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(Space.lg),
                child: SearchField(hint: l10n.searchCustomers, onChanged: context.read<CustomersCubit>().search),
              ),
              Expanded(
                child: state.loading
                    ? const LoadingView()
                    : state.customers.isEmpty
                        ? EmptyState(
                            icon: Iconsax.profile_2user,
                            message: l10n.customersEmpty,
                            actionLabel: l10n.addCustomer,
                            onAction: () => context.push('/customers/new'),
                          )
                        : ListView.separated(
                            itemCount: state.customers.length,
                            separatorBuilder: (_, _) => const Divider(indent: Space.lg),
                            itemBuilder: (context, i) {
                              final c = state.customers[i];
                              return ListTile(
                                key: ValueKey(c.id),
                                title: Text(c.name),
                                subtitle: c.phone.isEmpty ? null : Text(c.phone),
                                trailing: const Icon(Iconsax.arrow_right_3),
                                onTap: () => context.push('/customers/${c.id}'),
                              );
                            },
                          ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
