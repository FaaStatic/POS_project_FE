import 'package:flutter/widgets.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../l10n/app_localizations.dart';

class KasirDestination {
  const KasirDestination(this.label, this.icon);
  final String Function(AppLocalizations) label;
  final IconData icon;
}

/// Index of the checkout tab in [kasirDestinations].
const kasirCheckoutIndex = 0;

/// Order matches the StatefulShellRoute branches in router.dart.
final kasirDestinations = <KasirDestination>[
  // The cart icon belongs to the open carts ("Semua" in the tab strip); the cashier tab is the calculator.
  KasirDestination((l) => l.navCheckout, Iconsax.calculator_copy),
  KasirDestination((l) => l.navHistory, Iconsax.receipt_2_copy),
  KasirDestination((l) => l.navCustomers, Iconsax.profile_2user_copy),
  // Products and settings are rare for a cashier, so they share "Lainnya" (Square POS "More").
  KasirDestination((l) => l.navMore, Iconsax.menu_1_copy),
];
