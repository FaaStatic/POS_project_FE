import 'package:flutter/painting.dart';

/// White and mint. Mint carries the brand on actions and selection; status hues
/// keep their own meaning. Text pairs are 4.5:1 or better, input borders 3:1.
/// Dynamic Color is intentionally not used.
abstract final class Mint {
  /// Primary on white (5.5:1) and on the canvas (5.1:1).
  static const c700 = Color(0xFF047857);
  static const c800 = Color(0xFF065F46);

  /// Selected navigation and soft tiles; [c800] text on it is 6.8:1.
  static const c100 = Color(0xFFD1FAE5);
  static const c50 = Color(0xFFECFDF5);

  /// Dark theme primary (9.2:1 on the dark card) and its soft fill.
  static const c400 = Color(0xFF34D399);
  static const c200 = Color(0xFFA7F3D0);
  static const c900 = Color(0xFF064E3B);
  static const c950 = Color(0xFF022C22);
}

/// Neutrals carry a slight green tint so grey sits with the mint instead of against it.
abstract final class Neutral {
  static const canvas = Color(0xFFF4F7F5);
  static const subtle = Color(0xFFEEF3F0);
  static const border = Color(0xFFE2E8E5);
  static const input = Color(0xFF7C8D86);
  static const muted = Color(0xFF5B6B64);
  static const foreground = Color(0xFF0B1F17);

  static const canvasDark = Color(0xFF0B1210);
  static const surfaceDark = Color(0xFF111A17);
  static const subtleDark = Color(0xFF1A2622);
  static const borderDark = Color(0xFF23332D);
  static const inputDark = Color(0xFF647770);
  static const mutedDark = Color(0xFF94A39C);
  static const foregroundDark = Color(0xFFE8F1ED);
}

abstract final class BrandColors {
  static const greenLight = Mint.c700;
  static const greenDark = Mint.c400;
  static const greenContainerLight = Mint.c100;
  static const greenContainerDark = Mint.c900;

  static const redLight = Color(0xFFB91C1C);
  static const redDark = Color(0xFFF87171);
  static const redContainerLight = Color(0xFFFEE2E2);
  static const redContainerDark = Color(0xFF450A0A);

  static const amberLight = Color(0xFFB45309);
  static const amberDark = Color(0xFFFBBF24);
  static const amberContainerLight = Color(0xFFFEF3C7);
  static const amberContainerDark = Color(0xFF451A03);

  /// Product tiles (kasir), picked by category. Each pair keeps the initial at 6.7:1 or better.
  static const tilesLight = [
    (Mint.c50, Mint.c800),
    (Color(0xFFFFF4E5), Color(0xFF9A3412)),
    (Color(0xFFEAF2FF), Color(0xFF1E40AF)),
    (Color(0xFFFDECEF), Color(0xFF9F1239)),
    (Color(0xFFF3EEFF), Color(0xFF5B21B6)),
  ];
  static const tilesDark = [
    (Mint.c900, Mint.c200),
    (Color(0xFF431407), Color(0xFFFED7AA)),
    (Color(0xFF172554), Color(0xFFBFDBFE)),
    (Color(0xFF4C0519), Color(0xFFFECDD3)),
    (Color(0xFF2E1065), Color(0xFFDDD6FE)),
  ];
}
