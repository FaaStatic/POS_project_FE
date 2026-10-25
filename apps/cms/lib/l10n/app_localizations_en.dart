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

  @override
  String get transactionsEmpty => 'No transactions match these filters.';

  @override
  String get allMethods => 'All methods';

  @override
  String get invoice => 'Invoice no.';

  @override
  String get searchInvoice => 'Search invoice no.';

  @override
  String get date => 'Date';

  @override
  String get method => 'Method';

  @override
  String get total => 'Total';

  @override
  String get profit => 'Gross profit';

  @override
  String get conflictOnly => 'Stock conflicts';

  @override
  String get conflict => 'Stock conflict';

  @override
  String get reviewed => 'Reviewed';

  @override
  String get markReviewed => 'Mark as reviewed';

  @override
  String get markedReviewed => 'Marked as reviewed.';

  @override
  String get conflictHint =>
      'Server stock stopped at 0 when this offline sale arrived. Correct the product stock, then mark it reviewed.';

  @override
  String get transactionDetail => 'Transaction details';

  @override
  String get items => 'Items';

  @override
  String get qty => 'Qty';

  @override
  String get price => 'Price';

  @override
  String get subtotal => 'Subtotal';

  @override
  String get cancelTransaction => 'Cancel transaction';

  @override
  String cancelTitle(String invoice) {
    return 'Cancel $invoice?';
  }

  @override
  String get cancelReason => 'Reason for cancelling';

  @override
  String get cancelReasonShort => 'At least 3 characters';

  @override
  String get cancelledOk => 'Transaction cancelled.';

  @override
  String get downloadReceipt => 'Download receipt PDF';

  @override
  String get downloaded => 'File downloaded.';

  @override
  String get cash => 'Cash';

  @override
  String get debt => 'Credit';

  @override
  String get qris => 'QRIS';

  @override
  String get va => 'VA';

  @override
  String get noCashierFilter =>
      'The backend does not support a cashier filter yet.';

  @override
  String get paymentsTitle => 'QRIS/VA payments';

  @override
  String get paymentsEmpty => 'No payments match these filters.';

  @override
  String get allStatuses => 'All statuses';

  @override
  String get status => 'Status';

  @override
  String get orderId => 'Order ID';

  @override
  String get amount => 'Amount';

  @override
  String get fee => 'Fee';

  @override
  String get paidAt => 'Paid';

  @override
  String get checkStatus => 'Check status';

  @override
  String statusChecked(String status) {
    return 'Latest status: $status';
  }

  @override
  String get psPending => 'Pending';

  @override
  String get psSettling => 'Settling';

  @override
  String get psSuccess => 'Succeeded';

  @override
  String get psFailed => 'Failed';

  @override
  String get psExpired => 'Expired';

  @override
  String get debtsEmpty => 'No credit matches these filters.';

  @override
  String get unpaidOnly => 'Unpaid only';

  @override
  String get searchCustomer => 'Search customer name';

  @override
  String get remaining => 'Remaining';

  @override
  String get addManualDebt => 'Add manual credit';

  @override
  String get receivePayment => 'Receive payment';

  @override
  String get paymentAmount => 'Amount paid';

  @override
  String payFull(String amount) {
    return 'Pay off $amount';
  }

  @override
  String paymentRecorded(String amount) {
    return 'Payment recorded. $amount left.';
  }

  @override
  String get debtAdded => 'Credit added.';

  @override
  String get dueDate => 'Due date (optional)';

  @override
  String get pickCustomer => 'Choose customer';

  @override
  String get exceedsRemaining => 'More than the remaining credit.';

  @override
  String get reportsTitle => 'Reports';

  @override
  String get monthlyReport => 'Monthly report';

  @override
  String get monthlyReportHint =>
      'Sales, credit sales, manual credit, and credit payments per day.';

  @override
  String get month => 'Month';

  @override
  String get year => 'Year';

  @override
  String get download => 'Download PDF';

  @override
  String get downloadThisMonth => 'Download this month\'s report';

  @override
  String get dashboardTitle => 'Dashboard';

  @override
  String get needsAction => 'Needs action';

  @override
  String get nothingToDo => 'Nothing needs follow-up today.';

  @override
  String openConflicts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count unreviewed stock conflicts',
      one: '1 unreviewed stock conflict',
    );
    return '$_temp0';
  }

  @override
  String get oldestDebts => 'Oldest unpaid credit';

  @override
  String failedPayments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count QRIS/VA payments failed or expired today',
      one: '1 QRIS/VA payment failed or expired today',
    );
    return '$_temp0';
  }

  @override
  String get revenue => 'Revenue';

  @override
  String get grossProfit => 'Gross profit';

  @override
  String get transactionCount => 'Transactions';

  @override
  String get activeReceivables => 'Active receivables';

  @override
  String get rangeToday => 'Today';

  @override
  String get range7 => '7 days';

  @override
  String get range30 => '30 days';

  @override
  String get rangeMonth => 'This month';

  @override
  String get rangeCustom => 'Custom';

  @override
  String dailyChartTitle(String range) {
    return 'Daily revenue and gross profit, $range';
  }

  @override
  String get topProducts => 'Top 5 products';

  @override
  String get paymentMix => 'Payment method split';

  @override
  String get debtFlow => 'New and paid credit';

  @override
  String get newDebt => 'New credit';

  @override
  String get paidDebt => 'Paid';

  @override
  String get devicesOnline => 'Signed-in devices';

  @override
  String get noData => 'No data in this range yet.';

  @override
  String get quickAddProduct => 'Add product';

  @override
  String get quickAddStaff => 'Add staff';

  @override
  String get quickAddCustomer => 'Add customer';

  @override
  String get quickMonthReport => 'Download this month\'s report';

  @override
  String sold(String qty) {
    return '$qty sold';
  }

  @override
  String get chartTable => 'View as table';

  @override
  String get importTitle => 'Import from an Excel or CSV file';

  @override
  String get importHint =>
      'Required columns: sku, product_name, purchase_price, selling_price, selling_price_debt. Optional: barcode, unit (pcs, gram, kg, liter, kardus, ikat), stock, category, image, product_type (physical or digital). Up to 10,000 rows, 25 MB. Existing SKUs are updated.';

  @override
  String get pickFile => 'Choose an .xlsx or .csv file';

  @override
  String get downloadTemplate => 'Download CSV template';

  @override
  String importing(String name) {
    return 'Importing $name…';
  }

  @override
  String get manualTitle => 'Or fill in by hand';

  @override
  String get importFormat => 'Only .xlsx or .csv files.';

  @override
  String get importEmpty => 'The file is empty.';

  @override
  String get importTooLarge => 'The file is larger than 25 MB.';

  @override
  String get loginPanelLine =>
      'Sales, stock, and customer credit in one place.';

  @override
  String get loginPanelNote =>
      'Sales are recorded from the Kasir app, even offline.';

  @override
  String get summaryTitle => 'Summary';

  @override
  String vsPrevious(String range) {
    return 'vs previous $range';
  }

  @override
  String get recentTransactions => 'Recent transactions';

  @override
  String get seeAll => 'See all';

  @override
  String get statusDone => 'Completed';

  @override
  String get range => 'Range';

  @override
  String get account => 'Account';

  @override
  String get switchLanguage => 'Change language';

  @override
  String get rangeTodayShort => 'today';

  @override
  String get periodBefore => 'period';
}
