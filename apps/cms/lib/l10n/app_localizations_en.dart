// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Shop CMS';

  @override
  String get loginTitle => 'Sign in to CMS';

  @override
  String get loginSubtitle =>
      'Store admins only. Cashiers use the Kasir phone app.';

  @override
  String get username => 'Username';

  @override
  String get password => 'Password';

  @override
  String get signIn => 'Sign in';

  @override
  String get cmsAdminOnly =>
      'The CMS is for store admins only. Staff accounts sign in through the Kasir app.';

  @override
  String get errorNetwork => 'No connection. Check the internet and try again.';

  @override
  String get errorTimeout => 'The server took too long to respond. Try again.';

  @override
  String get sessionExpired => 'Your session ended. Please sign in again.';

  @override
  String get errorUnknown => 'Something went wrong. Try again.';

  @override
  String get vRequired => 'Required';

  @override
  String get vUsernameLength => 'Username must be 3–100 characters';

  @override
  String get vPasswordLength => 'Password must be at least 6 characters';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get theme => 'Theme';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get logout => 'Sign out';

  @override
  String signedInAs(String name) {
    return 'Signed in as $name';
  }

  @override
  String get openMenu => 'Open menu';

  @override
  String get navSettings => 'Settings';

  @override
  String get navDashboard => 'Dashboard';

  @override
  String get navTransactions => 'Transactions';

  @override
  String get navProducts => 'Products';

  @override
  String get navCategories => 'Categories';

  @override
  String get navCustomers => 'Customers';

  @override
  String get navDebts => 'Credit';

  @override
  String get navStaff => 'Staff';

  @override
  String get navPayments => 'Payments';

  @override
  String get navDevices => 'Devices';

  @override
  String get navReports => 'Reports';

  @override
  String get active => 'Active';

  @override
  String get inactive => 'Inactive';

  @override
  String get search => 'Search';

  @override
  String get actions => 'Actions';

  @override
  String get save => 'Save';

  @override
  String get saved => 'Saved.';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get restore => 'Restore';

  @override
  String get deactivate => 'Deactivate';

  @override
  String get purge => 'Delete permanently';

  @override
  String get retry => 'Try again';

  @override
  String get createdAt => 'Created';

  @override
  String get role => 'Role';

  @override
  String get roleSuper => 'Admin';

  @override
  String get roleStaff => 'Staff';

  @override
  String get staffTitle => 'Staff';

  @override
  String get addStaff => 'Add staff';

  @override
  String get staffEmpty => 'No staff yet. Add the first one.';

  @override
  String get staffInactiveEmpty => 'No inactive staff.';

  @override
  String get resetPassword => 'Reset password';

  @override
  String get newPassword => 'New password';

  @override
  String get resetPasswordHint =>
      'Every session of this staff will be signed out.';

  @override
  String get passwordReset => 'Password changed. Their sessions were revoked.';

  @override
  String get staffAdded => 'Staff added.';

  @override
  String get staffDeactivated =>
      'Staff deactivated. Sessions and push tokens revoked.';

  @override
  String get staffRestored => 'Staff restored.';

  @override
  String purgeTitle(String name) {
    return 'Delete $name permanently?';
  }

  @override
  String get purgeStaffHint =>
      'Staff without transactions are deleted. Staff with history are anonymised so old reports stay intact.';

  @override
  String purgeTypeName(String name) {
    return 'Type $name to confirm';
  }

  @override
  String get purgeMismatch => 'The name does not match.';

  @override
  String get purgedDeleted => 'Deleted permanently.';

  @override
  String get purgedAnonymized =>
      'Has transaction history, so it was anonymised.';

  @override
  String get customersTitle => 'Customers';

  @override
  String get addCustomer => 'Add customer';

  @override
  String get editCustomer => 'Edit customer';

  @override
  String get customersEmpty => 'No customers yet. Add the first one.';

  @override
  String get customersInactiveEmpty => 'No inactive customers.';

  @override
  String get customerName => 'Name';

  @override
  String get customerPhone => 'Phone number';

  @override
  String get customerAddress => 'Address';

  @override
  String get customerHasDebt =>
      'This customer still has active credit and cannot be deleted.';

  @override
  String get purgeCustomerHint =>
      'Customers with transactions are anonymised; others are deleted.';

  @override
  String get customerDeactivated => 'Customer deactivated.';

  @override
  String get customerRestored => 'Customer restored.';

  @override
  String get customerDetail => 'Customer details';

  @override
  String get transactionsTitle => 'Transactions';

  @override
  String get noTransactions => 'No transactions yet.';

  @override
  String get debtsTitle => 'Credit';

  @override
  String get noDebts => 'No credit.';

  @override
  String get categoriesTitle => 'Categories';

  @override
  String get addCategory => 'Add category';

  @override
  String get rename => 'Rename';

  @override
  String get categoryName => 'Category name';

  @override
  String get categoriesEmpty => 'No categories yet. Add the first one.';

  @override
  String productCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count products',
      one: '1 product',
      zero: 'Not used',
    );
    return '$_temp0';
  }

  @override
  String categoryInUse(int count) {
    return 'Used by $count products. Move them first.';
  }

  @override
  String get categoryDuplicate => 'That category already exists.';

  @override
  String get categoryDeleted => 'Category deleted.';

  @override
  String deleteCategoryTitle(String name) {
    return 'Delete category $name?';
  }

  @override
  String get productsTitle => 'Products';

  @override
  String get addProduct => 'Add product';

  @override
  String get bulkAdd => 'Add in bulk';

  @override
  String get editProduct => 'Edit product';

  @override
  String get productsEmpty => 'No products yet. Add the first one.';

  @override
  String get productsNoMatch => 'No products match.';

  @override
  String get productName => 'Product name';

  @override
  String get sku => 'SKU';

  @override
  String get barcode => 'Barcode';

  @override
  String get barcodeHint => 'Optional. A USB scanner can fill it in.';

  @override
  String get unit => 'Unit';

  @override
  String get productType => 'Type';

  @override
  String get physical => 'Physical';

  @override
  String get digital => 'Digital';

  @override
  String get purchasePrice => 'Purchase price';

  @override
  String get sellingPrice => 'Selling price';

  @override
  String get debtPrice => 'Credit price';

  @override
  String get stock => 'Stock';

  @override
  String get category => 'Category';

  @override
  String get categoryNewHint => 'Pick a category or type a new name';

  @override
  String get imageUrl => 'Image URL (optional)';

  @override
  String get allCategories => 'All categories';

  @override
  String get adjustStock => 'Adjust stock';

  @override
  String get stockDelta => 'Add or remove (e.g. 10 or -2)';

  @override
  String get stockUpdated => 'Stock updated.';

  @override
  String get productDeleted => 'Product deleted.';

  @override
  String deleteProductTitle(String name) {
    return 'Delete product $name?';
  }

  @override
  String get productSaved => 'Product saved.';

  @override
  String get bulkTitle => 'Add products in bulk';

  @override
  String get bulkHint => 'One product per row. Existing SKUs are updated.';

  @override
  String get addRow => 'Add row';

  @override
  String get removeRow => 'Remove row';

  @override
  String get uploadBulk => 'Save all';

  @override
  String bulkResult(int inserted, int updated) {
    return '$inserted added, $updated updated.';
  }

  @override
  String bulkRowError(int line, String message) {
    return 'Row $line: $message';
  }

  @override
  String bulkDuplicate(String skus) {
    return 'Duplicate SKUs in the form: $skus';
  }

  @override
  String row(int n) {
    return 'Row $n';
  }

  @override
  String get devicesTitle => 'Devices';

  @override
  String get devicesEmpty => 'No signed-in devices.';

  @override
  String get allPlatforms => 'All platforms';

  @override
  String get user => 'User';

  @override
  String get platform => 'Platform';

  @override
  String get lastActive => 'Last active';

  @override
  String get revoke => 'Revoke';

  @override
  String revokeTitle(String name) {
    return 'Revoke device $name?';
  }

  @override
  String get revokeHint => 'This device stops receiving payment notifications.';

  @override
  String get deviceRevoked => 'Device revoked.';

  @override
  String get unknownUser => '(no user)';

  @override
  String get vPositive => 'Must be more than 0';

  @override
  String get vNumber => 'Enter a number';

  @override
  String get vBarcode => 'Letters, digits, - . _ only (max 64)';

  @override
  String get vSku => 'Max 50 characters';

  @override
  String get vCategoryLength => 'Max 100 characters';

  @override
  String get vZero => 'Enter a value other than 0';

  @override
  String loadFailed(String reason) {
    return 'Could not load data. $reason';
  }

  @override
  String get debtPaid => 'Paid';

  @override
  String get debtUnpaid => 'Unpaid';
}
