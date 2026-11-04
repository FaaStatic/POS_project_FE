import 'package:flutter/widgets.dart';

/// Calls [onShow] when the tab holding [child] is brought to the front. The shell keeps every
/// tab mounted, and an inactive one has its tickers muted, which is what this watches.
class RefreshOnShow extends StatefulWidget {
  const RefreshOnShow({super.key, required this.onShow, required this.child});
  final VoidCallback onShow;
  final Widget child;

  @override
  State<RefreshOnShow> createState() => _RefreshOnShowState();
}

class _RefreshOnShowState extends State<RefreshOnShow> {
  bool _active = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final active = TickerMode.valuesOf(context).enabled;
    if (active && !_active) widget.onShow();
    _active = active;
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
