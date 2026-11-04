import 'package:flutter/painting.dart';

/// Blue on a warm canvas. Azure carries the brand on actions and selection; status
/// hues keep their own meaning. Text pairs are 4.5:1 or better, input borders 3:1.
/// Dynamic Color is intentionally not used.
abstract final class Azure {
  /// Primary on white (5.9:1) and on the canvas (5.3:1).
  static const c700 = Color(0xFF0A66C2);
  static const c800 = Color(0xFF004182);

  /// Selected navigation and soft tiles; [c800] text on it is 9:1 or better.
  static const c100 = Color(0xFFE8F3FF);
  static const c50 = Color(0xFFF6FBFF);

  /// Dark theme primary (7:1 or better on the dark card) and its soft fill.
  static const c400 = Color(0xFF71B7FB);
  static const c200 = Color(0xFFAAD6FF);
  static const c900 = Color(0xFF053059);
  static const c950 = Color(0xFF0A2037);
}

/// Neutrals are warm in the light theme and carry a slight blue tint in the dark one.
abstract final class Neutral {
  static const canvas = Color(0xFFF4F2EE);
  static const subtle = Color(0xFFECE9E4);
  static const border = Color(0xFFE2E0DC);
  static const input = Color(0xFF858585);
  static const muted = Color(0xFF666666);
  static const foreground = Color(0xFF1A1A1A);

  static const canvasDark = Color(0xFF0B1118);
  static const surfaceDark = Color(0xFF121A24);
  static const subtleDark = Color(0xFF1B2532);
  static const borderDark = Color(0xFF2A3644);
  static const inputDark = Color(0xFF6E7E90);
  static const mutedDark = Color(0xFF9DAABA);
  static const foregroundDark = Color(0xFFE9EEF4);
}

abstract final class BrandColors {
  static const greenLight = Color(0xFF01754F);
  static const greenDark = Color(0xFF4FD1A1);
  static const greenContainerLight = Color(0xFFE1F3EA);
  static const greenContainerDark = Color(0xFF0B3A2A);

  static const redLight = Color(0xFFCB112D);
  static const redDark = Color(0xFFF58A9B);
  static const redContainerLight = Color(0xFFFDE8EB);
  static const redContainerDark = Color(0xFF45101A);

  static const amberLight = Color(0xFF915907);
  static const amberDark = Color(0xFFF9C982);
  static const amberContainerLight = Color(0xFFFDF0DE);
  static const amberContainerDark = Color(0xFF402B0C);

  /// Product tiles (kasir), picked by category. Each pair keeps the initial at 6.7:1 or better.
  static const tilesLight = [
    (Azure.c50, Azure.c800),
    (Color(0xFFFDF0DE), Color(0xFF5C3B09)),
    (Color(0xFFE1F3EA), Color(0xFF014D34)),
    (Color(0xFFFDE8EB), Color(0xFF8A0D20)),
    (Color(0xFFF1F3E5), Color(0xFF414335)),
  ];
  static const tilesDark = [
    (Azure.c900, Azure.c200),
    (Color(0xFF402B0C), Color(0xFFF9C982)),
    (Color(0xFF0B3A2A), Color(0xFFA8E6CC)),
    (Color(0xFF45101A), Color(0xFFFAC0C9)),
    (Color(0xFF2F3027), Color(0xFFE2E7CA)),
  ];
}
