import 'package:flutter/material.dart';

import '../tokens/spacing.dart';
import 'data_image.dart';

/// The server-rendered Code128 for a product, from its `barcode_image` data URI.
/// Drawn on white in both themes so a scanner can read it. Empty or unreadable
/// data draws nothing. Decoding goes through [imageProviderFor], so the bytes are
/// kept between builds and a form rebuilt on every keystroke does not decode again.
class BarcodeImage extends StatelessWidget {
  const BarcodeImage({super.key, required this.dataUri, required this.semanticLabel, this.height = 96});

  final String dataUri;
  final String semanticLabel;
  final double height;

  @override
  Widget build(BuildContext context) {
    final image = dataUri.startsWith('data:image/') ? imageProviderFor(dataUri) : null;
    if (image == null) return const SizedBox.shrink();
    return DecoratedBox(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(Radii.small)),
      child: Padding(
        padding: const EdgeInsets.all(Space.sm),
        child: Image(
          image: image,
          height: height,
          fit: BoxFit.contain,
          semanticLabel: semanticLabel,
          errorBuilder: (_, _, _) => const SizedBox.shrink(),
        ),
      ),
    );
  }
}
