import 'package:flutter/widgets.dart';

/// Gives [child] at least the full height (so spaceBetween and rails spread out),
/// and scrolls instead when large text or a short window makes it taller.
class FillOrScroll extends StatelessWidget {
  const FillOrScroll({super.key, required this.child, this.padding = EdgeInsets.zero});

  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          padding: padding,
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight - padding.vertical),
            child: IntrinsicHeight(child: child),
          ),
        ),
      );
}
