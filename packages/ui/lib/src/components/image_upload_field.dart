import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../l10n/ui_localizations.dart';
import '../theme/app_theme.dart';
import '../tokens/spacing.dart';
import 'app_button.dart';
import 'data_image.dart';

/// A file the user chose: its name and bytes.
typedef PickedImage = ({String name, Uint8List bytes});

/// Picks one image, checks it, and reports it as raw base64, the form the backend stores.
///
/// The app supplies how to pick ([pick], a file dialog on the web, the system picker on a
/// phone) and the rules ([validate], returning a translated message or null), so the CMS and the
/// cashier run the same flow with their own wording. A rejected file is never reported: the
/// previous [value] stays and the reason shows under the field until the next pick.
///
/// [value] is what is stored now: base64, a legacy URL, or empty. [onChanged] gets new base64 on
/// a valid pick and an empty string when the image is removed.
class ImageUploadField extends StatefulWidget {
  const ImageUploadField({
    super.key,
    required this.label,
    required this.hint,
    required this.pick,
    required this.validate,
    required this.onChanged,
    this.value = '',
  });

  final String label;

  /// The rules in one line, shown while there is no error ("WebP, rasio 1:1, maks 500 KB").
  final String hint;
  final String value;
  final Future<PickedImage?> Function() pick;
  final String? Function(Uint8List bytes) validate;
  final ValueChanged<String> onChanged;

  @override
  State<ImageUploadField> createState() => _ImageUploadFieldState();
}

class _ImageUploadFieldState extends State<ImageUploadField> {
  static const _size = 72.0;

  /// The file just picked, shown at once instead of decoding the base64 it was turned into.
  PickedImage? _picked;
  String? _error;

  Future<void> _choose() async {
    final file = await widget.pick();
    if (file == null || !mounted) return;
    final error = widget.validate(file.bytes);
    setState(() {
      _error = error;
      if (error == null) _picked = file;
    });
    if (error == null) widget.onChanged(base64Encode(file.bytes));
  }

  void _remove() {
    setState(() {
      _picked = null;
      _error = null;
    });
    widget.onChanged('');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = UiLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final sizes = AppSizes.of(context);
    final has = widget.value.isNotEmpty;
    const size = _size;
    final picked = _picked;
    // A file just picked is drawn from its own bytes, so its base64 is not decoded for nothing.
    final tile = Center(child: Icon(Iconsax.gallery_copy, size: size * 0.4, color: scheme.onSurfaceVariant));
    final stored = has && picked == null
        ? storedImageFor(widget.value, cacheWidth: (size * MediaQuery.devicePixelRatioOf(context)).ceil(), fallback: tile)
        : null;

    return MergeSemantics(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(widget.label, style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w500)),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: Space.lg,
            children: [
              // Square on purpose: the upload rule is 1:1, so what is drawn is what will be shown.
              Container(
                width: size,
                height: size,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: scheme.surfaceContainerLow,
                  border: Border.all(color: scheme.outlineVariant),
                  borderRadius: BorderRadius.circular(sizes.controlRadius),
                ),
                child: ExcludeSemantics(
                  child: !has
                      ? tile
                      : picked != null
                          ? Image.memory(picked.bytes, fit: BoxFit.cover, cacheWidth: (size * 2).ceil(), errorBuilder: (_, _, _) => tile)
                          : stored ?? tile,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: Space.sm,
                  children: [
                    Wrap(
                      spacing: Space.sm,
                      runSpacing: Space.sm,
                      children: [
                        AppButton(
                          label: has ? l10n.changeImage : l10n.pickImage,
                          icon: Iconsax.document_upload_copy,
                          variant: AppButtonVariant.outline,
                          onPressed: _choose,
                        ),
                        if (has) AppButton(label: l10n.removeImage, variant: AppButtonVariant.destructiveGhost, onPressed: _remove),
                      ],
                    ),
                    if (picked != null) Text(picked.name, style: theme.textTheme.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                    if (_error == null)
                      Text(widget.hint, style: theme.textTheme.bodySmall)
                    else
                      Semantics(
                        liveRegion: true,
                        child: Text(_error!, style: theme.textTheme.bodySmall?.copyWith(color: scheme.error)),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
