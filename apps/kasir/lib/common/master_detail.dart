import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ui/ui.dart';

import '../l10n/app_localizations.dart';
import 'tablet_layout.dart';

/// Opens [id] in the detail pane when the list sits inside a [MasterDetail], otherwise pushes [path].
void openDetail(BuildContext context, String id, String path) {
  final scope = context.getInheritedWidgetOfExactType<_PaneScope>();
  if (scope == null) {
    context.push(path);
  } else {
    scope.select(id);
  }
}

/// True for a page shown in a [MasterDetail] right pane, where "back" and "done" have nowhere to go.
bool inDetailPane(BuildContext context) => context.getInheritedWidgetOfExactType<_InPane>() != null;

/// List on the left and the picked item's page on the right where the window is wide enough (the same
/// rule as the checkout's order panel); narrower windows keep the single list and push a route.
class MasterDetail extends StatefulWidget {
  const MasterDetail({super.key, required this.list, required this.detail, required this.icon, required this.hint});

  final Widget list;
  final Widget Function(String id) detail;
  final IconData icon;
  final String Function(AppLocalizations l10n) hint;

  @override
  State<MasterDetail> createState() => _MasterDetailState();
}

class _MasterDetailState extends State<MasterDetail> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    if (!splitPaneFits(MediaQuery.sizeOf(context))) return widget.list;
    final selected = _selected;
    return Row(
      children: [
        SizedBox(
          width: 380,
          child: _PaneScope(select: (id) => setState(() => _selected = id), child: widget.list),
        ),
        VerticalDivider(width: 1, color: Theme.of(context).colorScheme.outlineVariant),
        Expanded(
          child: selected == null
              ? EmptyState(icon: widget.icon, message: widget.hint(AppLocalizations.of(context)))
              : _InPane(child: KeyedSubtree(key: ValueKey(selected), child: widget.detail(selected))),
        ),
      ],
    );
  }
}

class _InPane extends InheritedWidget {
  const _InPane({required super.child});

  @override
  bool updateShouldNotify(_InPane old) => false;
}

class _PaneScope extends InheritedWidget {
  const _PaneScope({required this.select, required super.child});

  final ValueChanged<String> select;

  @override
  bool updateShouldNotify(_PaneScope old) => false;
}
