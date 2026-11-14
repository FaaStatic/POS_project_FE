import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../theme/app_theme.dart';

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
    if (!AppSizes.of(context).compact) return _SegmentedTrack<T>(choices: choices, selected: selected, onChanged: onChanged);
    return ShadTabs<int>(
      key: ValueKey(selected),
      value: selected < 0 ? 0 : selected,
      scrollable: true,
      onChanged: (i) => onChanged(choices[i].value),
      tabs: [for (final (i, c) in choices.indexed) ShadTab(value: i, child: Text(c.label))],
    );
  }
}

/// Touch density: equal-width segments in a tonal track, the picked one filled. Each segment is a
/// full-height tap target.
class _SegmentedTrack<T> extends StatelessWidget {
  const _SegmentedTrack({required this.choices, required this.selected, required this.onChanged});

  final List<Choice<T>> choices;
  final int selected;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final sizes = AppSizes.of(context);
    final label = Theme.of(context).textTheme.labelLarge;
    return DecoratedBox(
      decoration: BoxDecoration(color: scheme.surfaceContainer, borderRadius: BorderRadius.circular(sizes.controlRadius + 4)),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Row(
          children: [
            for (final (i, c) in choices.indexed)
              Expanded(
                child: Semantics(
                  button: true,
                  selected: i == selected,
                  child: Material(
                    color: i == selected ? scheme.primaryContainer : Colors.transparent,
                    borderRadius: BorderRadius.circular(sizes.controlRadius),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(sizes.controlRadius),
                      onTap: () => onChanged(c.value),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minHeight: sizes.control - 8),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                            child: Text(
                              c.label,
                              textAlign: TextAlign.center,
                              style: label?.copyWith(
                                fontWeight: i == selected ? FontWeight.w700 : FontWeight.w500,
                                color: i == selected ? scheme.onPrimaryContainer : scheme.onSurface,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class SymbolChoice<T> {
  const SymbolChoice(this.value, this.label, {this.icon, this.selectedIcon, this.text});

  final T value;

  /// Spoken and shown as a tooltip; the button itself shows only the symbol.
  final String label;
  final IconData? icon;

  /// Filled glyph for the picked state (Material: outlined when off, filled when on).
  final IconData? selectedIcon;

  /// A short code (ID, EN) when there is no icon.
  final String? text;
}

/// Touch density single-choice toggle made of symbols only: an icon or a short code per option, the
/// picked one on a tonal fill. Every option keeps a 48dp target, a tooltip, and a spoken label.
class SymbolToggle<T> extends StatelessWidget {
  const SymbolToggle({super.key, required this.choices, required this.value, required this.onChanged});

  final List<SymbolChoice<T>> choices;
  final T value;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final sizes = AppSizes.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 4,
      children: [
        for (final c in choices)
          Builder(builder: (context) {
            final on = c.value == value;
            final color = on ? scheme.onPrimaryContainer : scheme.onSurfaceVariant;
            return Tooltip(
              message: c.label,
              child: Semantics(
                button: true,
                selected: on,
                label: c.label,
                excludeSemantics: true,
                child: Material(
                  color: on ? scheme.primaryContainer : Colors.transparent,
                  borderRadius: BorderRadius.circular(sizes.controlRadius),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(sizes.controlRadius),
                    onTap: () => onChanged(c.value),
                    child: SizedBox.square(
                      dimension: sizes.control,
                      child: Center(
                        child: c.icon != null
                            ? Icon(on ? (c.selectedIcon ?? c.icon) : c.icon, color: color, size: 22)
                            : Text(
                                c.text ?? '',
                                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                      color: color,
                                      fontWeight: on ? FontWeight.w700 : FontWeight.w500,
                                    ),
                              ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
      ],
    );
  }
}
