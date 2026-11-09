import 'package:flutter/material.dart';
import '../../gen/assets.gen.dart';

enum _Logo { mark, pos, kasir }

/// Brand artwork from `assets/brand`, through the generated [Assets]. The wordmarks switch to light text in dark mode.
class BrandLogo extends StatelessWidget {
  /// Square mark only (rail, collapsed spaces).
  const BrandLogo.mark({super.key, this.height = 32}) : _logo = _Logo.mark;

  /// myPOS wordmark (CMS).
  const BrandLogo.pos({super.key, this.height = 36}) : _logo = _Logo.pos;

  /// myKasir wordmark (kasir).
  const BrandLogo.kasir({super.key, this.height = 36}) : _logo = _Logo.kasir;

  final _Logo _logo;
  final double height;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final (art, label) = switch (_logo) {
      _Logo.mark => (Assets.brand.mark, 'myPOS'),
      _Logo.pos => (dark ? Assets.brand.myposDark : Assets.brand.mypos, 'myPOS'),
      _Logo.kasir => (dark ? Assets.brand.mykasirDark : Assets.brand.mykasir, 'myKasir'),
    };
    return Semantics(
      label: label,
      image: true,
      child: art.svg(height: height, excludeFromSemantics: true),
    );
  }
}
