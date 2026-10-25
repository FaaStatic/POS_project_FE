abstract final class ApiPaths {
  static const login = '/auth/login';
  static const refresh = '/auth/refresh';
  static const logout = '/api/auth/logout';
  static const register = '/api/auth/register';

  static const users = '/api/users';
  static String user(String id) => '/api/users/$id';
  static String userRestore(String id) => '/api/users/$id/restore';
  static String userPurge(String id) => '/api/users/$id/permanent';

  static const customers = '/api/customers';
  static String customer(String id) => '/api/customers/$id';
  static String customerRestore(String id) => '/api/customers/$id/restore';
  static String customerPurge(String id) => '/api/customers/$id/permanent';
  static String customerTransactions(String id) => '/api/customers/$id/transactions';

  static const categories = '/api/categories';
  static String category(String id) => '/api/categories/$id';

  static const products = '/api/products';
  static const productsBulk = '/api/products/bulk';
  static const productsStock = '/api/products/stock';
  static String product(String id) => '/api/products/$id';

  static const transactions = '/api/transactions';
  static const transactionsSync = '/api/transactions/sync';
  static const reportMonth = '/api/transactions/report/month';
  static const reportTransaction = '/api/transactions/report/transaction';
  static String transaction(String id) => '/api/transactions/$id';
  static String transactionConflictReview(String id) => '/api/transactions/$id/conflict-review';

  static const payments = '/api/payments';
  static const paymentQris = '/api/payments/qris';
  static const paymentVa = '/api/payments/va';
  static String paymentStatus(String orderId) => '/api/payments/$orderId/status';

  static const debts = '/api/debts';
  static const debtPay = '/api/debts/pay';
  static String debt(String id) => '/api/debts/$id';

  static const dashboard = '/api/dashboard/summary';

  static const fcmRegister = '/api/fcm/register';
  static const fcmLogout = '/api/fcm/logout';
  static const devices = '/api/fcm/devices';
  static String device(String id) => '/api/fcm/devices/$id';

  /// Paths that must never trigger a token refresh on 401.
  static const authPaths = {login, refresh};
}
