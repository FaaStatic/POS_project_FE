import 'dart:typed_data';

import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:ui/ui.dart';

import '../l10n/app_localizations.dart';
import 'failure_text.dart';
import 'file_picker.dart';

/// The product picture as the CMS asks for it: a WebP, square, at most 500 KB. Sent to the
/// backend as raw base64, so [onChanged] gets that string (empty when removed).
class ProductImageField extends StatelessWidget {
  const ProductImageField({super.key, required this.value, required this.onChanged});
  final String value;
  final ValueChanged<String> onChanged;

  static Future<PickedImage?> _pick() async {
    final file = await pickFile(accept: const ['image/webp', '.webp']);
    return file == null ? null : (name: file.name, bytes: Uint8List.fromList(file.bytes));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ImageUploadField(
      label: l10n.productImage,
      hint: l10n.imageHint,
      value: value,
      pick: _pick,
      validate: (bytes) => validationText(context, ProductImage.validate(bytes)),
      onChanged: onChanged,
    );
  }
}
