import 'dart:js_interop';
import 'dart:typed_data';

import 'package:web/web.dart' as web;

final savedFiles = <String>[];

/// Triggers a browser download for bytes fetched with the bearer token.
void saveFile(List<int> bytes, String name, {String mime = 'application/pdf'}) {
  final blob = web.Blob([Uint8List.fromList(bytes).toJS].toJS, web.BlobPropertyBag(type: mime));
  final url = web.URL.createObjectURL(blob);
  final anchor = web.HTMLAnchorElement()
    ..href = url
    ..download = name;
  anchor.click();
  web.URL.revokeObjectURL(url);
  savedFiles.add(name);
}

/// Opens an external page without leaving the CMS; noopener keeps it from reaching back.
void openInNewTab(String url) => web.window.open(url, '_blank', 'noopener');
