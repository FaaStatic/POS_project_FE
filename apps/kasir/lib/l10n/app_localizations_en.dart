// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'myKasir';

  @override
  String get loginTitle => 'Sign in to Kasir';

  @override
  String get loginSubtitle => 'Use a staff or store admin account.';

  @override
  String get username => 'Username';

  @override
  String get password => 'Password';

  @override
  String get signIn => 'Sign in';

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
  String get navSettings => 'Settings';

  @override
  String get navCheckout => 'Checkout';

  @override
  String get navHistory => 'History';

  @override
  String get navCustomers => 'Customers';

  @override
  String get navProducts => 'Products';

  @override
  String get searchProducts => 'Search name, SKU, or scan a barcode';

  @override
  String get scan => 'Scan';

  @override
  String get allCategories => 'All';

  @override
  String get add => 'Add';

  @override
  String stock(String qty) {
    return 'Stock $qty';
  }

  @override
  String get outOfStock => 'Out of stock';

  @override
  String get noProducts =>
      'No products on this device yet. Connect to the internet and pull to load.';

  @override
  String noProductsMatch(String query) {
    return 'No products match \"$query\".';
  }

  @override
  String get reload => 'Reload';

  @override
  String cartSummary(String count, String total) {
    return '$count items · $total';
  }

  @override
  String get viewCart => 'View cart';

  @override
  String get cartEmpty => 'Cart is empty. Add products from the list.';

  @override
  String get customer => 'Customer';

  @override
  String get chooseCustomer => 'Choose customer (optional)';

  @override
  String get noCustomer => 'No customer';

  @override
  String get changeCustomer => 'Change';

  @override
  String get remove => 'Remove';

  @override
  String get destination => 'Destination number';

  @override
  String get destinationRequired => 'Enter the destination number';

  @override
  String stockShort(String qty) {
    return 'Only $qty left. It may have sold in another tab.';
  }

  @override
  String get total => 'Total';

  @override
  String get method => 'Payment method';

  @override
  String get cash => 'Cash';

  @override
  String get debt => 'Credit';

  @override
  String get qris => 'QRIS';

  @override
  String get va => 'VA';

  @override
  String get needsInternet => 'Needs internet';

  @override
  String get digitalCashOnly => 'Digital products: cash or credit';

  @override
  String get debtNeedsCustomer => 'Choose a customer for credit';

  @override
  String get pay => 'Pay';

  @override
  String payAmount(String total) {
    return 'Pay $total';
  }

  @override
  String get closeTab => 'Close tab';

  @override
  String closeTabTitle(int number, String count) {
    return 'Delete cart of Transaction $number ($count items)?';
  }

  @override
  String get closeTabWaiting =>
      'This transaction is waiting for payment and cannot be closed.';

  @override
  String get waitingQris => 'Waiting for QRIS';

  @override
  String get waitingVa => 'Waiting for VA';

  @override
  String get paid => 'Paid';

  @override
  String get chooseBank => 'Choose VA bank';

  @override
  String get scanQrHint => 'Ask the buyer to scan this QR code.';

  @override
  String get vaHint => 'Ask the buyer to transfer to this VA number.';

  @override
  String vaNumber(String bank) {
    return '$bank VA number';
  }

  @override
  String expiresAt(String time) {
    return 'Valid until $time';
  }

  @override
  String get waitingNote =>
      'Status is checked automatically. You can switch to another tab.';

  @override
  String get checkNow => 'Check now';

  @override
  String get qrUnavailable =>
      'The QR image could not load. Check the connection, then tap Check now.';

  @override
  String chargeFailed(int number) {
    return 'Payment for Transaction $number failed or expired. Choose another method.';
  }

  @override
  String chargePaid(int number) {
    return 'Transaction $number paid.';
  }

  @override
  String scanAdded(String name, int number) {
    return '$name → Transaction $number';
  }

  @override
  String unknownBarcode(String code) {
    return 'Product not registered ($code)';
  }

  @override
  String get assignBarcode => 'Assign barcode to a product';

  @override
  String assignBarcodeTitle(String code) {
    return 'Assign barcode $code';
  }

  @override
  String barcodeAssigned(String name) {
    return 'Barcode assigned to $name.';
  }

  @override
  String get tabLocked => 'This tab is locked while waiting for payment.';

  @override
  String staleDraftsRemoved(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count old transactions removed',
      one: '1 old transaction removed',
    );
    return '$_temp0';
  }

  @override
  String get openTabs => 'Open transactions';

  @override
  String get savedOffline =>
      'Saved on this device. It will be sent when online.';

  @override
  String get saved => 'Transaction saved.';

  @override
  String get timeoutUnknown =>
      'The server did not answer. The sale may already be recorded. Check History before retrying.';

  @override
  String get vEmptyCart => 'The cart is empty.';

  @override
  String get vInvalidQty => 'Quantity must be more than 0.';

  @override
  String get receipt => 'Receipt';

  @override
  String get print => 'Print receipt';

  @override
  String get reprint => 'Reprint';

  @override
  String get setupPrinter => 'Set up printer';

  @override
  String get done => 'Done';

  @override
  String get printed => 'Receipt printed.';

  @override
  String get printFailed =>
      'Printing failed. Make sure the printer is on and connected.';

  @override
  String get receiptNumber => 'No.';

  @override
  String get receiptDate => 'Date';

  @override
  String get receiptCashier => 'Cashier';

  @override
  String get receiptCustomer => 'Customer';

  @override
  String get receiptTotal => 'TOTAL';

  @override
  String get receiptMethod => 'Paid by';

  @override
  String get receiptOfflineNote => 'Temporary number, replaced after sync';

  @override
  String get storeNameMissing => 'Store name not set';

  @override
  String get historyTitle => 'Transaction history';

  @override
  String get historyEmpty => 'No transactions on this device yet.';

  @override
  String get statusPending => 'Not sent';

  @override
  String get statusSynced => 'Sent';

  @override
  String get statusFailed => 'Rejected by server';

  @override
  String get statusCancelled => 'Cancelled';

  @override
  String get stockConflict => 'Stock conflict';

  @override
  String get cancelSale => 'Cancel transaction';

  @override
  String cancelSaleTitle(String number) {
    return 'Cancel $number?';
  }

  @override
  String get cancelReason => 'Reason for cancelling';

  @override
  String get cancelReasonShort => 'At least 3 characters';

  @override
  String get cancelled => 'Transaction cancelled.';

  @override
  String get cancelNeedsInternet =>
      'Sent transactions can only be cancelled online.';

  @override
  String syncError(String error) {
    return 'Reason: $error';
  }

  @override
  String get syncNow => 'Sync now';

  @override
  String syncPending(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count transactions not sent yet',
      one: '1 transaction not sent yet',
      zero: 'All transactions sent',
    );
    return '$_temp0';
  }

  @override
  String syncDone(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count transactions sent',
      one: '1 transaction sent',
      zero: 'Nothing to send',
    );
    return '$_temp0';
  }

  @override
  String get customersTitle => 'Customers';

  @override
  String get searchCustomers => 'Search name or phone';

  @override
  String get customersEmpty => 'No customers yet.';

  @override
  String get addCustomer => 'Add customer';

  @override
  String get customerName => 'Name';

  @override
  String get customerPhone => 'Phone number';

  @override
  String get customerAddress => 'Address';

  @override
  String get save => 'Save';

  @override
  String get customerSaved => 'Customer saved.';

  @override
  String get onlineOnly => 'This needs an internet connection.';

  @override
  String outstanding(String amount) {
    return 'Outstanding $amount';
  }

  @override
  String get debtsTitle => 'Credit';

  @override
  String get noDebts => 'No credit.';

  @override
  String remaining(String amount, String total) {
    return '$amount left of $total';
  }

  @override
  String get receivePayment => 'Receive cash payment';

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
  String get exceedsRemaining => 'More than the remaining credit.';

  @override
  String get productsTitle => 'Products';

  @override
  String get editProduct => 'Edit product';

  @override
  String get productName => 'Product name';

  @override
  String get sku => 'SKU';

  @override
  String get barcode => 'Barcode';

  @override
  String get unit => 'Unit';

  @override
  String get sellingPrice => 'Selling price';

  @override
  String get debtPrice => 'Credit price';

  @override
  String get purchasePrice => 'Purchase price';

  @override
  String get productType => 'Product type';

  @override
  String get physical => 'Physical';

  @override
  String get digital => 'Digital';

  @override
  String get category => 'Category';

  @override
  String get newCategory => 'New category';

  @override
  String get stockAdjust => 'Adjust stock (+/-)';

  @override
  String get productSaved => 'Product saved.';

  @override
  String get superOnly => 'Admin only';

  @override
  String get vPositive => 'Must be more than 0';

  @override
  String get vBarcode => 'Letters, digits, - . _ only (max 64)';

  @override
  String get vSku => 'Max 50 characters';

  @override
  String get vNumber => 'Enter a number';

  @override
  String get storeInfo => 'Store info on receipts';

  @override
  String get storeName => 'Store name';

  @override
  String get storeAddress => 'Store address';

  @override
  String get storeFooter => 'Receipt footer';

  @override
  String get printerTitle => 'Printer';

  @override
  String get choosePrinter => 'Choose Bluetooth printer';

  @override
  String get noPrinter => 'No printer yet';

  @override
  String get paperWidth => 'Paper width';

  @override
  String get autoPrint => 'Print automatically after payment';

  @override
  String get testPrint => 'Test print';

  @override
  String get saved2 => 'Saved.';

  @override
  String logoutBlocked(int number) {
    return 'Transaction $number is still waiting for payment. Finish it or wait until it expires.';
  }

  @override
  String logoutConfirm(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count open transactions',
      one: '1 open transaction',
    );
    return 'Delete $_temp0 and sign out?';
  }

  @override
  String logoutPending(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count unsent transactions will be sent when someone signs in on this phone again.',
      one: '1 unsent transaction will be sent when someone signs in on this phone again.',
    );
    return '$_temp0';
  }

  @override
  String get logoutAnyway => 'Sign out';

  @override
  String get paymentPushSuccess => 'Payment succeeded';

  @override
  String get paymentPushFailed => 'Payment failed';

  @override
  String get open => 'Open';

  @override
  String inCart(String qty) {
    return '$qty in cart';
  }

  @override
  String get cartEmptyShort => 'Cart is empty';

  @override
  String get toPayment => 'Continue to payment';

  @override
  String get payment => 'Payment';

  @override
  String get totalAmount => 'Amount due';

  @override
  String itemsCount(String count) {
    return '$count items';
  }

  @override
  String get cashHint => 'Pay at the counter';

  @override
  String get debtHint => 'Recorded as customer credit';

  @override
  String get qrisHint => 'Buyer scans the QR code';

  @override
  String get vaHint2 => 'Transfer to a virtual account';

  @override
  String get cashReceived => 'Cash received';

  @override
  String get exactAmount => 'Exact amount';

  @override
  String get change => 'Change';

  @override
  String shortBy(String amount) {
    return 'Short by $amount';
  }

  @override
  String get back => 'Back';

  @override
  String get subtotal => 'Subtotal';

  @override
  String cashierLine(String name) {
    return 'Cashier: $name';
  }

  @override
  String get checkoutTitle => 'Checkout';

  @override
  String addItem(String name) {
    return 'Add $name';
  }

  @override
  String get navMore => 'More';
}
