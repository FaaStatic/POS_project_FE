abstract final class Space {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 24.0;
  static const xxl = 32.0;
  static const xxxl = 48.0;
}

abstract final class Radii {
  static const small = 6.0;

  /// Buttons, inputs, icon tiles.
  static const control = 12.0;
  static const medium = 16.0;

  /// Large grouping panels (dashboard sections).
  static const large = 24.0;
  static const full = 999.0;
}

abstract final class TapSize {
  static const min = 48.0;
  static const primary = 56.0;
}

/// Window-width breakpoints from the PRD (compact < 600 <= medium <= 1024 < expanded).
abstract final class Breakpoints {
  static const medium = 600.0;
  static const expanded = 1024.0;
}
