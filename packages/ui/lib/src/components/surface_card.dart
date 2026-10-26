import 'package:flutter/material.dart';

import '../tokens/spacing.dart';

/// White panel on the zinc canvas: the one container for grouped content.
class SurfaceCard extends StatelessWidget {
  const SurfaceCard({super.key, required this.child, this.padding = const EdgeInsets.all(Space.xl), this.color, this.onTap});

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Card(
        color: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Radii.large)),
        clipBehavior: Clip.antiAlias,
        child: InkWell(onTap: onTap, child: Padding(padding: padding, child: child)),
      );
}
