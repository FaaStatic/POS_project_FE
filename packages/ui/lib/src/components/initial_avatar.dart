import 'package:flutter/material.dart';

import '../tokens/spacing.dart';

/// Product or person initials on the brand mint, or the image when [imageUrl] loads.
/// One color for every item: color is not used to tell categories apart.
class InitialAvatar extends StatelessWidget {
  const InitialAvatar({super.key, required this.name, this.imageUrl, this.size = 44, this.square = true});

  final String name;
  final String? imageUrl;
  final double size;

  /// Rounded square for products, circle for people.
  final bool square;

  static String initials(String name) {
    // Sizes like "600ml" or "10rb" are not initials.
    final words = name.trim().split(RegExp(r'\s+')).where((w) => w.isNotEmpty && RegExp(r'^[A-Za-z]').hasMatch(w)).toList();
    if (words.isEmpty) return '?';
    final letters = words.length == 1 ? words.first.substring(0, words.first.length.clamp(0, 2)) : '${words[0][0]}${words[1][0]}';
    return letters.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final radius = BorderRadius.circular(square ? Radii.medium : size);
    final fallback = Center(
      child: Text(
        initials(name),
        style: TextStyle(
          fontFamily: 'Inter',
          package: 'ui',
          fontWeight: FontWeight.w700,
          fontSize: size * 0.36,
          color: scheme.onPrimaryContainer,
        ),
      ),
    );
    return ExcludeSemantics(
      child: Container(
        width: size,
        height: size,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(color: scheme.primaryContainer, borderRadius: radius),
        child: imageUrl == null || imageUrl!.isEmpty
            ? fallback
            : Image.network(imageUrl!, fit: BoxFit.cover, errorBuilder: (_, _, _) => fallback),
      ),
    );
  }
}
