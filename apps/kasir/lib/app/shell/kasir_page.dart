import 'package:flutter/material.dart';
import 'package:ui/ui.dart';

/// Page frame with a title bar. At large text the actions move to a row under
/// the bar, so a labelled button never squeezes the title off a phone screen.
class KasirPage extends StatelessWidget {
  const KasirPage({super.key, required this.title, required this.body, this.actions = const [], this.bottom});

  final String title;
  final Widget body;
  final List<Widget> actions;
  final PreferredSizeWidget? bottom;

  @override
  Widget build(BuildContext context) {
    final stacked = actions.isNotEmpty && MediaQuery.textScalerOf(context).scale(1) > 1.3;
    return Scaffold(
      appBar: AppBar(title: Text(title), actions: stacked ? null : [...actions, const SizedBox(width: Space.sm)], bottom: bottom),
      body: stacked
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(Space.lg, 0, Space.lg, Space.sm),
                  child: Wrap(spacing: Space.sm, runSpacing: Space.sm, children: actions),
                ),
                Expanded(child: body),
              ],
            )
          : body,
    );
  }
}
