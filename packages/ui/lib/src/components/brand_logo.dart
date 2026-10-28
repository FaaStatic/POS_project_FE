import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart' show SvgPicture;

enum _Logo { mark, pos, kasir }

/// Brand artwork from `assets/brand`. The wordmarks switch to light text in dark mode.
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
    final (file, label) = switch (_logo) {
      _Logo.mark => ('mark', 'myPOS'),
      _Logo.pos => (dark ? 'mypos_dark' : 'mypos', 'myPOS'),
      _Logo.kasir => (dark ? 'mykasir_dark' : 'mykasir', 'myKasir'),
    };
    return Semantics(
      label: label,
      image: true,
      child: SvgPicture.asset('assets/brand/$file.svg', package: 'ui', height: height, excludeFromSemantics: true),
    );
  }
}
