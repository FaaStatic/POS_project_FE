import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../components/status_badge.dart';
import '../theme/app_theme.dart';

Widget touchPreviewTheme(Widget child) => Theme(
  data: AppTheme.touch.light,
  child: ShadTheme(data: AppTheme.touch.shadLight, child: Material(child: child)),
);

@Preview(name: 'StatusBadge', group: 'ui', wrapper: touchPreviewTheme)
Widget statusBadgePreview() => const Padding(
  padding: EdgeInsets.all(16),
  child: Wrap(
    spacing: 8,
    runSpacing: 8,
    children: [
      StatusBadge(label: 'Sukses', tone: BadgeTone.success),
      StatusBadge(label: 'Belum lunas', tone: BadgeTone.warning),
      StatusBadge(label: 'Batal', tone: BadgeTone.danger),
      StatusBadge(label: 'Draf'),
    ],
  ),
);
