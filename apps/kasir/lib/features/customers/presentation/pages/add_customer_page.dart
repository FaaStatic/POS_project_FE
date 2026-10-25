import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ui/ui.dart';

import '../../../../app/di.dart';
import '../../../../common/failure_text.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/customers_cubit.dart';

class AddCustomerPage extends StatefulWidget {
  const AddCustomerPage({super.key});

  @override
  State<AddCustomerPage> createState() => _AddCustomerPageState();
}

class _AddCustomerPageState extends State<AddCustomerPage> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _address = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _address.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocProvider(
      create: (_) => getIt<AddCustomerCubit>(),
      child: BlocConsumer<AddCustomerCubit, CustomerFormState>(
        listenWhen: (a, b) => b.saved != null && a.saved == null,
        listener: (context, s) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.customerSaved)));
          context.pop(s.saved);
        },
        builder: (context, state) => Scaffold(
          appBar: AppBar(title: Text(l10n.addCustomer)),
          body: SingleChildScrollView(
            child: ConstrainedBody(
              padding: const EdgeInsets.all(Space.lg),
              child: Form(
                key: _form,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppTextField(
                      label: l10n.customerName,
                      controller: _name,
                      autofocus: true,
                      validator: (v) => validationText(context, Validators.required(v)),
                    ),
                    const SizedBox(height: Space.lg),
                    AppTextField(label: l10n.customerPhone, controller: _phone, keyboardType: TextInputType.phone),
                    const SizedBox(height: Space.lg),
                    AppTextField(label: l10n.customerAddress, controller: _address, maxLines: 2),
                    if (state.failure != null) ...[
                      const SizedBox(height: Space.lg),
                      Text(
                        failureText(context, state.failure!),
                        style: TextStyle(color: Theme.of(context).colorScheme.error),
                      ),
                    ],
                    const SizedBox(height: Space.xl),
                    Text(l10n.onlineOnly, style: Theme.of(context).textTheme.bodySmall),
                    const SizedBox(height: Space.sm),
                    AppButton(
                      label: l10n.save,
                      large: true,
                      expand: true,
                      loading: state.saving,
                      onPressed: () {
                        if (!_form.currentState!.validate()) return;
                        context.read<AddCustomerCubit>().save(
                          CustomerInput(name: _name.text, phone: _phone.text, address: _address.text),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
