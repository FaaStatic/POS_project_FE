import 'package:flutter/material.dart';

/// Calls [onEnd] whenever the vertical list below is within [threshold] of its end, both while
/// scrolling and when a layout leaves the list short. [onEnd] must ignore repeats: it fires on
/// every notification near the end until more rows arrive.
class LoadMoreOnScroll extends StatelessWidget {
  const LoadMoreOnScroll({super.key, required this.onEnd, required this.child, this.threshold = 600});

  final VoidCallback onEnd;
  final Widget child;
  final double threshold;

  @override
  Widget build(BuildContext context) => NotificationListener<Notification>(
    onNotification: (n) {
      // Depth 0 is the page's own vertical scroll; horizontal chip rows and nested lists are not.
      final metrics = switch (n) {
        ScrollNotification(:final metrics, depth: 0) => metrics,
        ScrollMetricsNotification(:final metrics, depth: 0) => metrics,
        _ => null,
      };
      if (metrics != null && metrics.axis == Axis.vertical && metrics.extentAfter < threshold) onEnd();
      return false;
    },
    child: child,
  );
}
