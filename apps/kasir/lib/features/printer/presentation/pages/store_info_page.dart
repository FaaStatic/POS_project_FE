import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ui/ui.dart';

import '../../../../app/di.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/receipt_settings_cubit.dart';

/// Store name, address, and footer printed on receipts; kept on this device only.
class StoreInfoPage extends StatefulWidget {
  const StoreInfoPage({super.key});

  @override
  State<StoreInfoPage> createState() => _StoreInfoPageState();
}

class _StoreInfoPageState extends State<StoreInfoPage> {
  late final ReceiptSettingsCubit _cubit = getIt<ReceiptSettingsCubit>();
  late final _name = TextEditingController(text: _cubit.state.storeName);
  late final _address = TextEditingController(text: _cubit.state.storeAddress);
  late final _footer = TextEditingController(text: _cubit.state.footer);

  @override
  void dispose() {
    _name.dispose();
    _address.dispose();
    _footer.dispose();
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.storeInfo)),
        body: SingleChildScrollView(
          child: ConstrainedBody(
            padding: const EdgeInsets.all(Space.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppTextField(label: l10n.storeName, controller: _name),
                const SizedBox(height: Space.lg),
                AppTextField(label: l10n.storeAddress, controller: _address, maxLines: 2),
                const SizedBox(height: Space.lg),
                AppTextField(label: l10n.storeFooter, controller: _footer, maxLines: 2),
                const SizedBox(height: Space.xl),
                AppButton(
                  label: l10n.save,
                  large: true,
                  expand: true,
                  onPressed: () async {
                    final messenger = ScaffoldMessenger.of(context);
                    await _cubit.save(_cubit.state.copyWith(storeName: _name.text, storeAddress: _address.text, footer: _footer.text));
                    messenger.showSnackBar(SnackBar(content: Text(l10n.saved2)));
                    if (context.mounted) context.pop();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
