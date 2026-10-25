import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';

import '../../l10n/ui_localizations.dart';

/// Button showing the picked range; opens the Material date range picker.
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
    final label = value == null ? l10n.pickDates : '${format.format(value!.start)} – ${format.format(value!.end)}';
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: OutlinedButton.icon(
            icon: const Icon(Iconsax.calendar_1, size: 20),
            label: Text(label, overflow: TextOverflow.ellipsis),
            onPressed: () async {
              final now = DateTime.now();
              final picked = await showDateRangePicker(
                context: context,
                firstDate: firstDate ?? DateTime(now.year - 3),
                lastDate: lastDate ?? now,
                initialDateRange: value,
              );
              if (picked != null) onChanged(picked);
            },
          ),
        ),
        if (value != null)
          IconButton(tooltip: l10n.clearDates, icon: const Icon(Iconsax.close_circle), onPressed: () => onChanged(null)),
      ],
    );
  }
}
