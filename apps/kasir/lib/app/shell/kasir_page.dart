import 'package:flutter/material.dart';

class KasirPage extends StatelessWidget {
  const KasirPage({super.key, required this.title, required this.body, this.actions = const [], this.bottom});

  final String title;
  final Widget body;
  final List<Widget> actions;
  final PreferredSizeWidget? bottom;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(title), actions: [...actions, const SizedBox(width: 8)], bottom: bottom),
        body: body,
      );
}
