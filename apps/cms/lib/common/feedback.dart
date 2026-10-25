import 'package:core/core.dart';
import 'package:flutter/material.dart';

import 'failure_text.dart';

/// Toast for an action result: [success] on Ok, the failure text on Err.
void showResult(BuildContext context, Result<Object?> result, String success) {
  final text = switch (result) {
    Ok() => success,
    Err(:final failure) => failureText(context, failure),
  };
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(text)));
}

void toast(BuildContext context, String text) => ScaffoldMessenger.of(context)
  ..hideCurrentSnackBar()
  ..showSnackBar(SnackBar(content: Text(text)));

/// Awaits [action] and shows its toast if the page is still mounted.
Future<void> report(BuildContext context, Future<Result<Object?>> action, String success) async {
  final result = await action;
  if (context.mounted) showResult(context, result, success);
}
