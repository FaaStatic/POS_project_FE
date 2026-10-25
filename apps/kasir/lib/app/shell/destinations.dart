import 'package:flutter/widgets.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../l10n/app_localizations.dart';

class KasirDestination {
  const KasirDestination(this.label, this.icon);
  final String Function(AppLocalizations) label;
  final IconData icon;
}

/// Order matches the StatefulShellRoute branches in router.dart.
final kasirDestinations = <KasirDestination>[
  KasirDestination((l) => l.navSettings, Iconsax.setting_2),
];
