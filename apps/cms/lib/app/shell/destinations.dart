import 'package:flutter/widgets.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../l10n/app_localizations.dart';

class CmsDestination {
  const CmsDestination(this.label, this.icon);
  final String Function(AppLocalizations) label;
  final IconData icon;
}

/// Order matches the StatefulShellRoute branches in router.dart.
final cmsDestinations = <CmsDestination>[
  CmsDestination((l) => l.navDashboard, Iconsax.home_2),
  CmsDestination((l) => l.navTransactions, Iconsax.receipt_2),
  CmsDestination((l) => l.navPayments, Iconsax.card_pos),
  CmsDestination((l) => l.navDebts, Iconsax.wallet_money),
  CmsDestination((l) => l.navProducts, Iconsax.box),
  CmsDestination((l) => l.navCategories, Iconsax.category),
  CmsDestination((l) => l.navCustomers, Iconsax.profile_2user),
  CmsDestination((l) => l.navStaff, Iconsax.security_user),
  CmsDestination((l) => l.navDevices, Iconsax.mobile),
  CmsDestination((l) => l.navReports, Iconsax.document_download),
  CmsDestination((l) => l.navSettings, Iconsax.setting_2),
];
