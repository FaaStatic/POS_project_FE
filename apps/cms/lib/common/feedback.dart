import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:ui/ui.dart';

import 'failure_text.dart';

/// Info dialog for an action result: [success] on Ok, the failure text on Err.
void showResult(BuildContext context, Result<Object?> result, String success) {
  switch (result) {
    case Ok():
      showInfoDialog(context, success, kind: InfoKind.success);
    case Err(:final failure):
      showInfoDialog(context, failureText(context, failure), kind: InfoKind.error);
  }
}

void toast(BuildContext context, String text, {InfoKind kind = InfoKind.success}) =>
    showInfoDialog(context, text, kind: kind);

/// Awaits [action] and shows its toast if the page is still mounted.
Future<void> report(BuildContext context, Future<Result<Object?>> action, String success) async {
  final result = await action;
  if (context.mounted) showResult(context, result, success);
}
