import 'package:flutter/material.dart';

import '../tokens/colors.dart';

@immutable
class StatusColors extends ThemeExtension<StatusColors> {
  const StatusColors({
    required this.success,
    required this.successContainer,
    required this.warning,
    required this.warningContainer,
    required this.danger,
    required this.dangerContainer,
  });

  final Color success;
  final Color successContainer;
  final Color warning;
  final Color warningContainer;
  final Color danger;
  final Color dangerContainer;

  static const light = StatusColors(
    success: BrandColors.greenLight,
    successContainer: BrandColors.greenContainerLight,
    warning: BrandColors.amberLight,
    warningContainer: BrandColors.amberContainerLight,
    danger: BrandColors.redLight,
    dangerContainer: BrandColors.redContainerLight,
  );

  static const dark = StatusColors(
    success: BrandColors.greenDark,
    successContainer: BrandColors.greenContainerDark,
    warning: BrandColors.amberDark,
    warningContainer: BrandColors.amberContainerDark,
    danger: BrandColors.redDark,
    dangerContainer: BrandColors.redContainerDark,
  );

  static StatusColors of(BuildContext context) => Theme.of(context).extension<StatusColors>()!;

  @override
  StatusColors copyWith({
    Color? success,
    Color? successContainer,
    Color? warning,
    Color? warningContainer,
    Color? danger,
    Color? dangerContainer,
  }) =>
      StatusColors(
        success: success ?? this.success,
        successContainer: successContainer ?? this.successContainer,
        warning: warning ?? this.warning,
        warningContainer: warningContainer ?? this.warningContainer,
        danger: danger ?? this.danger,
        dangerContainer: dangerContainer ?? this.dangerContainer,
      );

  @override
  StatusColors lerp(StatusColors? other, double t) {
    if (other == null) return this;
    return StatusColors(
      success: Color.lerp(success, other.success, t)!,
      successContainer: Color.lerp(successContainer, other.successContainer, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      warningContainer: Color.lerp(warningContainer, other.warningContainer, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      dangerContainer: Color.lerp(dangerContainer, other.dangerContainer, t)!,
    );
  }
}
