/// Endpoint paths as `/{group}/{service}/...`, relative to the API root `{API_BASE_URL}/api/{API_VERSION}`
/// that `AppConfig.apiUrl` sets as the Dio base URL. Groups follow the backend: account, catalog, sales, insight.
abstract final class ApiPaths {
  static const login = '/account/auth/login';
  static const refresh = '/account/auth/refresh';
  static const logout = '/account/auth/logout';
  static const register = '/account/auth/register';

  static const users = '/account/users';
  static String user(String id) => '/account/users/$id';
  static String userRestore(String id) => '/account/users/$id/restore';
  static String userPurge(String id) => '/account/users/$id/permanent';

  static const customers = '/sales/customers';
  static String customer(String id) => '/sales/customers/$id';
  static String customerRestore(String id) => '/sales/customers/$id/restore';
  static String customerPurge(String id) => '/sales/customers/$id/permanent';
  static String customerTransactions(String id) => '/sales/customers/$id/transactions';

  static const categories = '/catalog/categories';
  static String category(String id) => '/catalog/categories/$id';

  static const products = '/catalog/products';
  static const productsBulk = '/catalog/products/bulk';
  static const productsStock = '/catalog/products/stock';
  static const productsTemplate = '/catalog/products/template';
  static const productsExportBarcodes = '/catalog/products/export/barcodes';
  static String product(String id) => '/catalog/products/$id';

  static const transactions = '/sales/transactions';
  static const transactionsSync = '/sales/transactions/sync';
  static const reportMonth = '/sales/transactions/report/month';
  static const reportTransaction = '/sales/transactions/report/transaction';
  static String transaction(String id) => '/sales/transactions/$id';
  static String transactionConflictReview(String id) => '/sales/transactions/$id/conflict-review';

  static const payments = '/sales/payments';
  static const paymentQris = '/sales/payments/qris';
  static const paymentVa = '/sales/payments/va';
  static String paymentStatus(String orderId) => '/sales/payments/$orderId/status';

  static const debts = '/sales/debts';
  static const debtPay = '/sales/debts/pay';
  static const debtPayments = '/sales/debts/payments';
  static const debtPaymentsReport = '/sales/debts/payments/report';
  static String debtPaymentReceipt(String id) => '/sales/debts/payments/$id/receipt';

  static const dashboard = '/insight/dashboard/summary';

  static const fcmRegister = '/account/fcm/register';
  static const fcmLogout = '/account/fcm/logout';
  static const devices = '/account/fcm/devices';
  static String device(String id) => '/account/fcm/devices/$id';

  /// Paths that must never trigger a token refresh on 401.
  static const authPaths = {login, refresh};

  // The file name may not start with a dot, so `..` cannot climb out of the reports folder.
  static final _reportFile = RegExp(r'^/api/v[0-9]+(/insight/reports/[^/.][^/]*)$');

  /// The `url_pdf` the server returns is absolute (`/api/v1/insight/reports/x.pdf`). This gives its
  /// path relative to the API root, or null when [urlPdf] is not a report path. The version is not
  /// compared: the client's base URL decides which version is called.
  static String? reportFile(String urlPdf) => _reportFile.firstMatch(urlPdf)?.group(1);
}
