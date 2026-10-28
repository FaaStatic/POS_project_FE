import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bluetooth_printer/flutter_bluetooth_printer.dart';
import 'package:ui/ui.dart';

import '../../../../app/di.dart';
import '../../../../common/failure_text.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/receipt_settings_cubit.dart';

class PrinterSettingsPage extends StatelessWidget {
  const PrinterSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return BlocProvider(
      create: (_) => getIt<ReceiptSettingsCubit>()..start(),
      child: BlocBuilder<ReceiptSettingsCubit, ReceiptSettings>(
        builder: (context, s) {
          final cubit = context.read<ReceiptSettingsCubit>();
          return Scaffold(
            appBar: AppBar(title: Text(l10n.printerTitle)),
            body: ConstrainedBody(
              child: ListView(
                padding: const EdgeInsets.all(Space.lg),
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(s.printerName ?? l10n.noPrinter),
                    subtitle: s.printerAddress == null ? null : Text(s.printerAddress!),
                  ),
                  AppButton(
                    label: l10n.choosePrinter,
                    variant: AppButtonVariant.outline,
                    expand: true,
                    onPressed: () async {
                      final device = await FlutterBluetoothPrinter.selectDevice(context);
                      if (device != null) {
                        await cubit.save(s.copyWith(printerAddress: device.address, printerName: device.name));
                      }
                    },
                  ),
                  const SizedBox(height: Space.xl),
                  Text(l10n.paperWidth, style: theme.textTheme.titleSmall),
                  const SizedBox(height: Space.sm),
                  AppTabs<PaperWidth>(
                    choices: const [Choice(PaperWidth.mm58, '58 mm'), Choice(PaperWidth.mm80, '80 mm')],
                    value: s.paper,
                    onChanged: (v) => cubit.save(s.copyWith(paper: v)),
                  ),
                  const SizedBox(height: Space.lg),
                  ShadSwitch(
                    label: Text(l10n.autoPrint),
                    value: s.autoPrint,
                    onChanged: (v) => cubit.save(s.copyWith(autoPrint: v)),
                  ),
                  const SizedBox(height: Space.lg),
                  AppButton(
                    label: l10n.testPrint,
                    variant: AppButtonVariant.secondary,
                    expand: true,
                    onPressed: s.printerAddress == null
                        ? null
                        : () async {
                            final messenger = ScaffoldMessenger.of(context);
                            final result = await getIt<PrintReceipt>()(
                              ReceiptDocument([
                                ReceiptLine(
                                  s.storeName.isEmpty ? l10n.storeNameMissing : s.storeName,
                                  align: ReceiptAlign.center,
                                  bold: true,
                                ),
                                ReceiptLine(l10n.testPrint, align: ReceiptAlign.center),
                              ]),
                            );
                            if (!context.mounted) return;
                            messenger.showSnackBar(
                              SnackBar(
                                content: Text(switch (result) {
                                  Ok() => l10n.printed,
                                  Err(:final failure) => failureText(context, failure),
                                }),
                              ),
                            );
                          },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
