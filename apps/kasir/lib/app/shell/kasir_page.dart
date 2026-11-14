import 'package:flutter/material.dart';
import 'package:ui/ui.dart';

/// Page frame with a large title. Actions sit on the title row, or in a row
/// under it at large text, so a labelled button never squeezes the title off a
/// phone screen.
class KasirPage extends StatelessWidget {
  const KasirPage({
    super.key,
    required this.title,
    required this.body,
    this.actions = const [],
  });

  final String title;
  final Widget body;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final titleText = Text(
      title,
      style: Theme.of(context).textTheme.headlineMedium,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                Space.lg,
                Space.md,
                Space.lg,
                Space.sm,
              ),
              child: LayoutBuilder(
                builder: (context, box) {
                  // Large text or a narrow pane: actions drop under the title instead of squeezing it.
                  final stacked =
                      actions.isNotEmpty &&
                      (MediaQuery.textScalerOf(context).scale(1) > 1.3 ||
                          box.maxWidth < 440);
                  return stacked
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            titleText,
                            const SizedBox(height: Space.sm),
                            Wrap(
                              spacing: Space.sm,
                              runSpacing: Space.sm,
                              children: actions,
                            ),
                          ],
                        )
                      : Row(
                          children: [
                            Expanded(child: titleText),
                            ...actions,
                          ],
                        );
                },
              ),
            ),
            Expanded(child: body),
          ],
        ),
      ),
    );
  }
}
