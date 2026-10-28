
import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/presentation/bloc/auth_cubit.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/splash_page.dart';
import '../features/auth/presentation/widgets/account_section.dart';
import '../features/categories/presentation/pages/categories_page.dart';
import '../features/customers/presentation/pages/customer_detail_page.dart';
import '../features/customers/presentation/pages/customers_page.dart';
import '../features/devices/presentation/pages/devices_page.dart';
import '../features/products/presentation/pages/bulk_products_page.dart';
import '../features/products/presentation/pages/products_page.dart';
import '../features/settings/presentation/pages/settings_page.dart';
import '../features/dashboard/presentation/pages/dashboard_page.dart';
import '../features/debts/presentation/pages/debts_page.dart';
import '../features/payments/presentation/pages/payments_page.dart';
import '../features/reports/presentation/pages/reports_page.dart';


import '../features/staff/presentation/pages/staff_page.dart';
import '../features/transactions/presentation/pages/transaction_detail_page.dart';
import '../features/transactions/presentation/pages/transactions_page.dart';
import 'di.dart';
import 'shell/cms_shell.dart';

abstract final class Routes {
  static const splash = '/splash';
  static const login = '/login';
  static const dashboard = '/dashboard';
  static const transactions = '/transactions';
  static const payments = '/payments';
  static const debts = '/debts';
  static const reports = '/reports';
  static const products = '/products';
  static const categories = '/categories';
  static const customers = '/customers';
  static const staff = '/staff';
  static const devices = '/devices';
  static const settings = '/settings';
  static const home = dashboard;
}

GoRouter buildRouter(AuthCubit auth, {String? initialLocation}) => GoRouter(
  initialLocation: initialLocation ?? Routes.home,
  // Keeps the requested page across splash and login, so a reload stays put.
  redirect: (context, state) {
    final location = state.matchedLocation;
    final gate = location == Routes.splash || location == Routes.login;
    final from = gate ? state.uri.queryParameters['from'] : state.uri.toString();
    String to(String gatePath) =>
        from == null || from == Routes.home ? gatePath : '$gatePath?from=${Uri.encodeComponent(from)}';
    return switch (auth.state) {
      AuthUnknown() => location == Routes.splash ? null : to(Routes.splash),
      AuthUnauthenticated() => location == Routes.login ? null : to(Routes.login),
      AuthAuthenticated() => gate ? from ?? Routes.home : null,
    };
  },
  routes: [
    GoRoute(path: Routes.splash, builder: (_, _) => const SplashPage()),
    GoRoute(path: Routes.login, builder: (_, _) => const LoginPage()),
    StatefulShellRoute.indexedStack(
      builder: (_, _, shell) => CmsShell(shell: shell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.dashboard,
              builder: (_, _) => DashboardPage(
                onDownloadMonthReport: (context) {
                  final now = DateTime.now();
                  return download(context, now.month, now.year, cubit: getIt());
                },
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.transactions,
              builder: (_, s) => TransactionsPage(
                key: ValueKey(s.uri.toString()),
                conflictsOnly: s.uri.queryParameters['conflicts'] == '1',
              ),
              routes: [
                GoRoute(
                  path: ':id',
                  builder: (_, s) => TransactionDetailPage(transactionId: s.pathParameters['id']!),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.payments,
              builder: (_, s) {
                final today = DateTime.now();
                final q = s.uri.queryParameters;
                return PaymentsPage(
                  key: ValueKey(s.uri.toString()),
                  initial: PaymentQuery(
                    state: q['status'] == null ? null : PaymentState.parse(q['status']!),
                    dateStart: q['today'] == '1' ? DateTime(today.year, today.month, today.day) : null,
                    dateEnd: q['today'] == '1' ? DateTime(today.year, today.month, today.day) : null,
                  ),
                );
              },
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [GoRoute(path: Routes.debts, builder: (_, _) => const DebtsPage())],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.products,
              builder: (_, s) => ProductsPage(openAdd: s.uri.queryParameters['add'] == '1'),
              routes: [GoRoute(path: 'bulk', builder: (_, _) => const BulkProductsPage())],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [GoRoute(path: Routes.categories, builder: (_, _) => const CategoriesPage())],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.customers,
              builder: (_, s) => CustomersPage(openAdd: s.uri.queryParameters['add'] == '1'),
              routes: [
                GoRoute(
                  path: ':id',
                  builder: (_, s) => CustomerDetailPage(customerId: s.pathParameters['id']!),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.staff,
              builder: (_, s) => StaffPage(openAdd: s.uri.queryParameters['add'] == '1'),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [GoRoute(path: Routes.devices, builder: (_, _) => const DevicesPage())],
        ),
        StatefulShellBranch(
          routes: [GoRoute(path: Routes.reports, builder: (_, _) => const ReportsPage())],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.settings,
              builder: (_, _) => const SettingsPage(account: AccountSection()),
            ),
          ],
        ),
      ],
    ),
  ],
);
