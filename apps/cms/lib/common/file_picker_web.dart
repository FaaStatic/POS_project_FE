import 'dart:async';
import 'dart:js_interop';

import 'package:web/web.dart' as web;

import 'picked_file.dart';

export 'picked_file.dart';

/// Opens the browser's file dialog. Completes with null when cancelled.
Future<PickedFile?> pickFile({required List<String> accept}) {
  final done = Completer<PickedFile?>();
  final input = web.HTMLInputElement()
    ..type = 'file'
    ..accept = accept.join(',');

  void read(web.File file) {
    file.arrayBuffer().toDart.then(
          (buffer) => done.complete(PickedFile(file.name, buffer.toDart.asUint8List())),
          onError: done.completeError,
        );
  }

  input.addEventListener(
    'change',
    ((web.Event _) {
      final file = input.files?.item(0);
      file == null ? done.complete(null) : read(file);
    }).toJS,
  );
  input.addEventListener(
    'cancel',
    ((web.Event _) {
      if (!done.isCompleted) done.complete(null);
    }).toJS,
  );
  input.click();
  return done.future;
}
