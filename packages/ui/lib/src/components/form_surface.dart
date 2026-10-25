import 'package:flutter/material.dart';

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
  return showDialog<R>(
    context: context,
    builder: (_) => Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560, maxHeight: 720),
        child: Padding(
          padding: const EdgeInsets.all(Space.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: Space.lg),
              Flexible(child: SingleChildScrollView(child: child)),
            ],
          ),
        ),
      ),
    ),
  );
}
