import 'package:flutter/material.dart';

/// Keeps forms and reading text from stretching on wide windows.
class ConstrainedBody extends StatelessWidget {
  const ConstrainedBody({super.key, required this.child, this.maxWidth = 640, this.padding});

  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) => Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: padding == null ? child : Padding(padding: padding!, child: child),
        ),
      );
}
