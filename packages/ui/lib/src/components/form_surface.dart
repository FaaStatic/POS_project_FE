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
      constraints: const BoxConstraints(maxWidth: 560, maxHeight: 720),
      scrollable: true,
      child: child,
    ),
  );
}
