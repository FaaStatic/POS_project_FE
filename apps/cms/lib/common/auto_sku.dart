import 'package:flutter/widgets.dart';

/// A SKU field that follows a generator until the user types their own. The input also reports
/// text set from code, so [typed] tells the generator's echo from real typing.
class AutoSku {
  AutoSku(this.controller);
  final TextEditingController controller;

  /// True once the user has typed a SKU; the generator then leaves the field alone.
  bool touched = false;
  String _auto = '';

  /// Puts the generated SKU in the field, or an empty one when there is not enough to build it.
  void set(String value) {
    _auto = value;
    controller.text = value;
  }

  /// For the field's onChanged. False when the text is the generator's own echo. Otherwise records
  /// whether the user now owns the SKU, and a cleared field hands it back, then returns true.
  bool typed(String text) {
    if (text.isNotEmpty && text == _auto) return false;
    touched = text.trim().isNotEmpty;
    return true;
  }
}
