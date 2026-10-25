import 'package:flutter/painting.dart';

/// Zinc neutrals (shadcn) plus the brand green. Values are fixed brand
/// commitments; Dynamic Color is intentionally not used.
abstract final class Zinc {
  static const c50 = Color(0xFFFAFAFA);
  static const c100 = Color(0xFFF4F4F5);
  static const c200 = Color(0xFFE4E4E7);
  static const c300 = Color(0xFFD4D4D8);
  static const c400 = Color(0xFFA1A1AA);
  static const c500 = Color(0xFF71717A);
  static const c600 = Color(0xFF52525B);
  static const c700 = Color(0xFF3F3F46);
  static const c800 = Color(0xFF27272A);
  static const c900 = Color(0xFF18181B);
  static const c950 = Color(0xFF09090B);
}

abstract final class BrandColors {
  static const greenLight = Color(0xFF15803D);
  static const greenDark = Color(0xFF22C55E);
  static const onGreenDark = Color(0xFF052E16);
  static const greenContainerLight = Color(0xFFDCFCE7);
  static const greenContainerDark = Color(0xFF14532D);

  static const redLight = Color(0xFFB91C1C);
  static const redDark = Color(0xFFF87171);
  static const redContainerLight = Color(0xFFFEE2E2);
  static const redContainerDark = Color(0xFF450A0A);

  static const amberLight = Color(0xFFB45309);
  static const amberDark = Color(0xFFFBBF24);
  static const amberContainerLight = Color(0xFFFEF3C7);
  static const amberContainerDark = Color(0xFF451A03);
}
