import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ui/ui.dart';

import '../../../../app/di.dart';
import '../../../../app/shell/cms_page.dart';
import '../../../../common/feedback.dart';
import '../../../../common/file_saver.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/reports_cubit.dart';

/// Monthly PDF (sales, credit sales, manual credit, credit payments per day).
/// Per-transaction receipts are downloaded from the transaction detail.
class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  late int _month = DateTime.now().month;
  late int _year = DateTime.now().year;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final now = DateTime.now();
    return BlocProvider(
      create: (_) => getIt<ReportsCubit>(),
      child: BlocBuilder<ReportsCubit, bool>(
        builder: (context, busy) => CmsPage(
          title: l10n.reportsTitle,
          body: ConstrainedBody(
            padding: const EdgeInsets.all(Space.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.monthlyReport, style: theme.textTheme.titleLarge),
                const SizedBox(height: Space.sm),
                Text(l10n.monthlyReportHint, style: theme.textTheme.bodyLarge),
                const SizedBox(height: Space.xl),
                Wrap(spacing: Space.lg, runSpacing: Space.lg, crossAxisAlignment: WrapCrossAlignment.end, children: [
                  SizedBox(
                    width: 200,
                    child: DropdownButtonFormField<int>(
                      isExpanded: true,
                      initialValue: _month,
                      decoration: InputDecoration(labelText: l10n.month),
                      items: [for (var m = 1; m <= 12; m++) DropdownMenuItem(value: m, child: Text(DateFormat.MMMM(locale).format(DateTime(2000, m))))],
                      onChanged: (m) => setState(() => _month = m ?? _month),
                    ),
                  ),
                  SizedBox(
                    width: 140,
                    child: DropdownButtonFormField<int>(
                      isExpanded: true,
                      initialValue: _year,
                      decoration: InputDecoration(labelText: l10n.year),
                      items: [for (var y = now.year; y >= now.year - 4; y--) DropdownMenuItem(value: y, child: Text('$y'))],
                      onChanged: (y) => setState(() => _year = y ?? _year),
                    ),
                  ),
                  AppButton(
                    label: l10n.download,
                    loading: busy,
                    onPressed: () => download(context, _month, _year),
                  ),
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Shared with the dashboard's "Unduh laporan bulan ini" action.
Future<void> download(BuildContext context, int month, int year, {ReportsCubit? cubit}) async {
  final l10n = AppLocalizations.of(context);
  final result = await (cubit ?? context.read<ReportsCubit>()).monthly(month, year);
  if (!context.mounted) return;
  if (result case Ok(value: (final bytes, final name))) saveFile(bytes, name);
  showResult(context, result, l10n.downloaded);
}
