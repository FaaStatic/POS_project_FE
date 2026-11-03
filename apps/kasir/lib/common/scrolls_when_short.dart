import 'dart:math';

import 'package:flutter/material.dart';

/// Lays [child] out at least [minHeight] tall and scrolls when the viewport is shorter, so a
/// phone in landscape with the keyboard open shows a scrollable page instead of an overflow.
/// The widget tree is the same at every height, which keeps the search field focused while
/// the keyboard animates in.
class ScrollsWhenShort extends StatelessWidget {
  const ScrollsWhenShort({super.key, required this.child, this.minHeight = 240});

  final Widget child;
  final double minHeight;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) => SingleChildScrollView(
      child: SizedBox(height: max(constraints.maxHeight, minHeight), child: child),
    ),
  );
}
