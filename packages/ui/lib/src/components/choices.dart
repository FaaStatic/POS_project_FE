import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class Choice<T> {
  const Choice(this.value, this.label);
  final T value;
  final String label;
}

/// shadcn select with its label above it. Options are tracked by index, so a
/// null value ("all") is a real choice rather than "nothing picked".
class AppSelect<T> extends StatelessWidget {
  const AppSelect({super.key, required this.label, required this.choices, required this.value, required this.onChanged});

  final String label;
  final List<Choice<T>> choices;
  final T value;
  final ValueChanged<T>? onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selected = choices.indexWhere((c) => c.value == value);
    return MergeSemantics(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(label, style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w500)),
          const SizedBox(height: 6),
          LayoutBuilder(
            builder: (context, constraints) => ShadSelect<int>(
              // Rebuilt when the value changes from outside (filters reset by the cubit).
              key: ValueKey(selected),
              enabled: onChanged != null,
              initialValue: selected < 0 ? null : selected,
              minWidth: constraints.maxWidth.isFinite ? constraints.maxWidth : null,
              placeholder: Text(label),
              selectedOptionBuilder: (context, i) => Text(choices[i].label, overflow: TextOverflow.ellipsis),
              options: [for (final (i, c) in choices.indexed) ShadOption(value: i, child: Text(c.label))],
              onChanged: (i) {
                if (i != null) onChanged?.call(choices[i].value);
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// shadcn tabs used as a segmented filter (Aktif / Nonaktif / Semua). Each tab
/// sizes to its label so the bar sits inline with other filters.
class AppTabs<T> extends StatelessWidget {
  const AppTabs({super.key, required this.choices, required this.value, required this.onChanged});

  final List<Choice<T>> choices;
  final T value;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    final selected = choices.indexWhere((c) => c.value == value);
    return ShadTabs<int>(
      key: ValueKey(selected),
      value: selected < 0 ? 0 : selected,
      scrollable: true,
      onChanged: (i) => onChanged(choices[i].value),
      tabs: [for (final (i, c) in choices.indexed) ShadTab(value: i, child: Text(c.label))],
    );
  }
}
