import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../l10n/ui_localizations.dart';
import '../theme/app_theme.dart';
import '../tokens/spacing.dart';

/// shadcn range picker: a button with the picked range that opens a calendar popover.
/// [onChanged] fires once both ends are picked, or with null when cleared.
class DateRangeField extends StatelessWidget {
  const DateRangeField({super.key, required this.value, required this.onChanged, this.firstDate, this.lastDate});

  final DateTimeRange? value;
  final ValueChanged<DateTimeRange?> onChanged;
  final DateTime? firstDate;
  final DateTime? lastDate;

  @override
  Widget build(BuildContext context) {
    final l10n = UiLocalizations.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final format = DateFormat.yMMMd(locale);
    final sizes = AppSizes.of(context);
    final now = DateTime.now();
    // Phones and large text: the button fills the row and the range wraps instead of overflowing.
    final wrap = MediaQuery.sizeOf(context).width < Breakpoints.medium || MediaQuery.textScalerOf(context).scale(1) > 1.3;
    return Row(
      mainAxisSize: wrap ? MainAxisSize.max : MainAxisSize.min,
      children: [
        Flexible(
          child: ShadDatePicker.range(
            // A new key resets the picker when the range is cleared from outside.
            key: ValueKey(value),
            // 0 sizes the button to the range text instead of shadcn's fixed width;
            // height 0 lets wrapped text grow it past the control height.
            width: 0,
            height: wrap ? 0 : sizes.control,
            expands: wrap,
            buttonPadding: wrap ? const EdgeInsets.symmetric(horizontal: Space.lg, vertical: Space.sm) : null,
            selected: value == null ? null : ShadDateTimeRange(start: value!.start, end: value!.end),
            fromMonth: firstDate ?? DateTime(now.year - 3),
            toMonth: lastDate ?? now,
            selectableDayPredicate: (day) => !day.isAfter(lastDate ?? now) && !day.isBefore(firstDate ?? DateTime(now.year - 3)),
            placeholder: Text(l10n.pickDates),
            // The year once when both ends share it: "1 Okt – 25 Okt 2026".
            formatDateRange: (r) {
              final sameYear = r.end == null || r.start!.year == r.end!.year;
              final start = (sameYear ? DateFormat.MMMd(locale) : format).format(r.start!);
              return '$start – ${r.end == null ? '…' : format.format(r.end!)}';
            },
            onRangeChanged: (r) {
              if (r?.start != null && r?.end != null) onChanged(DateTimeRange(start: r!.start!, end: r.end!));
            },
          ),
        ),
        if (value != null)
          Tooltip(
            message: l10n.clearDates,
            child: ShadIconButton.ghost(
              width: sizes.control,
              height: sizes.control,
              icon: Icon(Iconsax.close_circle_copy, size: sizes.compact ? 16 : 20),
              onPressed: () => onChanged(null),
            ),
          ),
      ],
    );
  }
}
