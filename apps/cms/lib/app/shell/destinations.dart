import 'package:flutter/widgets.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../l10n/app_localizations.dart';

class CmsDestination {
  const CmsDestination(this.label, this.icon, [this.group]);
  final String Function(AppLocalizations) label;
  final IconData icon;

  /// Sidebar section; null sits above the sections (Dashboard).
  final String Function(AppLocalizations)? group;
}

String _sales(AppLocalizations l) => l.navGroupSales;
String _catalog(AppLocalizations l) => l.navGroupCatalog;
String _people(AppLocalizations l) => l.navGroupPeople;
String _other(AppLocalizations l) => l.navGroupOther;

/// Order matches the StatefulShellRoute branches in router.dart; a section's
/// items are consecutive so the sidebar can group them without reordering.
final cmsDestinations = <CmsDestination>[
  CmsDestination((l) => l.navDashboard, Iconsax.home_2_copy),
  CmsDestination((l) => l.navTransactions, Iconsax.receipt_2_copy, _sales),
  CmsDestination((l) => l.navPayments, Iconsax.card_pos_copy, _sales),
  CmsDestination((l) => l.navDebts, Iconsax.wallet_money_copy, _sales),
  CmsDestination((l) => l.navProducts, Iconsax.box_copy, _catalog),
  CmsDestination((l) => l.navCategories, Iconsax.category_copy, _catalog),
  CmsDestination((l) => l.navCustomers, Iconsax.profile_2user_copy, _people),
  CmsDestination((l) => l.navStaff, Iconsax.security_user_copy, _people),
  CmsDestination((l) => l.navDevices, Iconsax.mobile_copy, _people),
  CmsDestination((l) => l.navReports, Iconsax.document_download_copy, _other),
  CmsDestination((l) => l.navSettings, Iconsax.setting_2_copy, _other),
];
