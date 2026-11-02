import 'package:core/core.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:ui/ui.dart';

import '../l10n/app_localizations.dart';
import 'failure_text.dart';

/// Android filters by `extensions`/`mimeTypes`, iOS by `uniformTypeIdentifiers` (file_selector's README).
const _webp = XTypeGroup(
  label: 'WebP',
  extensions: ['webp'],
  mimeTypes: ['image/webp'],
  uniformTypeIdentifiers: ['org.webmproject.webp'],
);

Future<PickedImage?> _pickWebp() async {
  final file = await openFile(acceptedTypeGroups: const [_webp]);
  return file == null ? null : (name: file.name, bytes: await file.readAsBytes());
}

/// How a picture is chosen. Tests replace it, since there is no system picker to tap.
Future<PickedImage?> Function() pickProductImage = _pickWebp;

/// The product picture as the cashier app asks for it: the same rules and the same raw base64
/// as the CMS (a WebP, square, at most 500 KB). [onChanged] gets the string, empty when removed.
class ProductImageField extends StatelessWidget {
  const ProductImageField({super.key, required this.value, required this.onChanged});
  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ImageUploadField(
      label: l10n.productImage,
      hint: l10n.imageHint,
      value: value,
      // Looked up at tap time, so a replacement set after the page was built still applies.
      pick: () => pickProductImage(),
      validate: (bytes) => validationText(context, ProductImage.validate(bytes)),
      onChanged: onChanged,
    );
  }
}
