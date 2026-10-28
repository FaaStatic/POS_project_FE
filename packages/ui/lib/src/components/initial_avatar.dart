import 'package:flutter/material.dart';

import '../tokens/colors.dart';
import '../tokens/spacing.dart';

/// Product or person initials on a soft tile, or the image when [imageUrl] loads.
/// [colorKey] (a category id) picks a stable pastel so a shelf of products reads
/// in groups; the name still carries the meaning, color only helps scanning.
class InitialAvatar extends StatelessWidget {
  const InitialAvatar({super.key, required this.name, this.imageUrl, this.size = 44, this.square = true, this.colorKey});

  final String name;
  final String? imageUrl;
  final double size;
  final String? colorKey;

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
    final dark = Theme.of(context).brightness == Brightness.dark;
    final tiles = dark ? BrandColors.tilesDark : BrandColors.tilesLight;
    // Sum of code units, not hashCode: a category keeps its color across app restarts.
    final key = colorKey;
    final (bg, fg) = key == null ? tiles.first : tiles[key.codeUnits.fold(0, (a, c) => a + c) % tiles.length];
    final radius = BorderRadius.circular(square ? Radii.control : size);
    final fallback = Center(
      child: Text(
        initials(name),
        style: TextStyle(
          fontFamily: 'Inter',
          package: 'ui',
          fontWeight: FontWeight.w700,
          fontSize: size * 0.36,
          color: fg,
        ),
      ),
    );
    return ExcludeSemantics(
      child: Container(
        width: size,
        height: size,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(color: bg, borderRadius: radius),
        child: imageUrl == null || imageUrl!.isEmpty
            ? fallback
            : Image.network(imageUrl!, fit: BoxFit.cover, errorBuilder: (_, _, _) => fallback),
      ),
    );
  }
}
