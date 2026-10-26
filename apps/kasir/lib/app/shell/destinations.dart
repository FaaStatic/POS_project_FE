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
  KasirDestination((l) => l.navCheckout, Iconsax.shopping_cart),
  KasirDestination((l) => l.navHistory, Iconsax.receipt_2),
  KasirDestination((l) => l.navCustomers, Iconsax.profile_2user),
  // Products and settings are rare for a cashier, so they share "Lainnya" (Square POS "More").
  KasirDestination((l) => l.navMore, Iconsax.menu_1),
];
