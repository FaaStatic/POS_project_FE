import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/presentation/bloc/auth_cubit.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/splash_page.dart';
import '../features/auth/presentation/widgets/account_section.dart';
import '../features/checkout/presentation/pages/checkout_page.dart';
import '../features/checkout/presentation/pages/scanner_page.dart';
import '../features/customers/presentation/pages/add_customer_page.dart';
import '../features/customers/presentation/pages/customer_detail_page.dart';
import '../features/customers/presentation/pages/customers_page.dart';
import '../features/debts/presentation/pages/debt_payment_page.dart';
import '../features/history/presentation/pages/history_page.dart';
import '../features/history/presentation/pages/sale_detail_page.dart';
import '../features/printer/presentation/pages/printer_settings_page.dart';
import '../features/printer/presentation/pages/store_info_page.dart';
import '../features/products/presentation/pages/product_edit_page.dart';
import '../features/products/presentation/pages/products_page.dart';
import '../features/push/data/push_service.dart';
import '../features/settings/presentation/pages/settings_page.dart';
import 'di.dart';
import 'shell/kasir_shell.dart';
import 'shell/session_scope.dart';

abstract final class Routes {
  static const splash = '/splash';
  static const login = '/login';
  static const checkout = '/checkout';
  static const history = '/history';
  static const customers = '/customers';
  static const settings = '/settings';
  static const home = checkout;
}

GoRouter buildRouter(AuthCubit auth) => GoRouter(
      initialLocation: Routes.home,
      // Keeps the requested page across splash and login, so a reload stays put.
      redirect: (context, state) {
        final location = state.matchedLocation;
        final gate = location == Routes.splash || location == Routes.login;
        final from = gate ? state.uri.queryParameters['from'] : state.uri.toString();
        String to(String gatePath) => from == null || from == Routes.home ? gatePath : '$gatePath?from=${Uri.encodeComponent(from)}';
        return switch (auth.state) {
          AuthUnknown() => location == Routes.splash ? null : to(Routes.splash),
          AuthUnauthenticated() => location == Routes.login ? null : to(Routes.login),
          AuthAuthenticated() => gate ? from ?? Routes.home : null,
        };
      },
      routes: [
        GoRoute(path: Routes.splash, builder: (_, _) => const SplashPage()),
        // Routes default to no transition here; this fade gives the splash logo time to fly.
        GoRoute(
          path: Routes.login,
          pageBuilder: (_, state) => CustomTransitionPage<void>(
            key: state.pageKey,
            transitionDuration: Durations.medium4,
            transitionsBuilder: (_, animation, _, child) => FadeTransition(opacity: animation, child: child),
            child: const LoginPage(),
          ),
        ),
        ShellRoute(
          builder: (_, _, child) => SessionScope(child: child),
          routes: [
            StatefulShellRoute.indexedStack(
              builder: (_, _, shell) => KasirShell(shell: shell, banner: const SyncBanner()),
              branches: [
                StatefulShellBranch(routes: [GoRoute(path: Routes.checkout, builder: (_, _) => const CheckoutPage())]),
                StatefulShellBranch(routes: [GoRoute(path: Routes.history, builder: (_, _) => const HistoryPage())]),
                StatefulShellBranch(routes: [
                  GoRoute(
                    path: Routes.customers,
                    builder: (_, _) => const CustomersPage(),
                    routes: [
                      GoRoute(path: 'new', builder: (_, _) => const AddCustomerPage()),
                      GoRoute(path: ':id', builder: (_, s) => CustomerDetailPage(customerId: s.pathParameters['id']!)),
                    ],
                  ),
                ]),
                StatefulShellBranch(routes: [
                  GoRoute(
                    path: Routes.settings,
                    builder: (_, _) => SettingsPage(
                      account: AccountSection(beforeLogout: () async {
                        final push = getIt<PushService>();
                        final token = push.token;
                        await push.unregister();
                        return token;
                      }),
                      sync: const SyncTile(),
                    ),
                    routes: [
                      GoRoute(path: 'printer', builder: (_, _) => const PrinterSettingsPage()),
                      GoRoute(path: 'store', builder: (_, _) => const StoreInfoPage()),
                      GoRoute(
                        path: 'products',
                        builder: (_, _) => const ProductsPage(),
                        routes: [
                          GoRoute(path: ':id', builder: (_, s) => ProductEditPage(productId: s.pathParameters['id']!)),
                        ],
                      ),
                    ],
                  ),
                ]),
              ],
            ),
            GoRoute(path: '/scan', builder: (_, _) => const ScannerPage()),
            GoRoute(
              path: '/sale/:ref',
              builder: (_, s) => SaleDetailPage(clientRef: s.pathParameters['ref']!, autoPrint: s.uri.queryParameters['print'] == '1'),
            ),
            GoRoute(path: '/debts/:id/pay', builder: (_, s) => DebtPaymentPage(debtId: s.pathParameters['id']!)),
          ],
        ),
      ],
    );
