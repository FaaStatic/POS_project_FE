import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../tokens/spacing.dart';

/// Opens a form as a full page below 600 wide and as a dialog above (PRD §7).
Future<R?> showFormSurface<R>(BuildContext context, {required String title, required Widget child}) {
  final width = MediaQuery.sizeOf(context).width;
  if (width < Breakpoints.medium) {
    return Navigator.of(context).push<R>(MaterialPageRoute(
      fullscreenDialog: true,
      builder: (_) => Scaffold(
        appBar: AppBar(title: Text(title)),
        body: SingleChildScrollView(padding: const EdgeInsets.all(Space.lg), child: child),
      ),
    ));
  }
  return showShadDialog<R>(
    context: context,
    builder: (_) => ShadDialog(
      title: Text(title),
      // Tall forms get most of a tall window before they scroll; short windows keep a margin.
      constraints: BoxConstraints(maxWidth: 560, maxHeight: (MediaQuery.sizeOf(context).height - 64).clamp(480.0, 800.0)),
      scrollable: true,
      child: child,
    ),
  );
}
