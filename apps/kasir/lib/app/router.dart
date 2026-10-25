import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/presentation/bloc/auth_cubit.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/splash_page.dart';
import '../features/settings/presentation/pages/settings_page.dart';
import 'shell/kasir_shell.dart';

abstract final class Routes {
  static const splash = '/splash';
  static const login = '/login';
  static const settings = '/settings';
  static const home = settings;
}

GoRouter buildRouter(AuthCubit auth) => GoRouter(
      initialLocation: Routes.home,
      refreshListenable: _StreamListenable(auth.stream),
      redirect: (context, state) {
        final location = state.matchedLocation;
        return switch (auth.state) {
          AuthUnknown() => location == Routes.splash ? null : Routes.splash,
          AuthUnauthenticated() => location == Routes.login ? null : Routes.login,
          AuthAuthenticated() => location == Routes.login || location == Routes.splash ? Routes.home : null,
        };
      },
      routes: [
        GoRoute(path: Routes.splash, builder: (_, _) => const SplashPage()),
        GoRoute(path: Routes.login, builder: (_, _) => const LoginPage()),
        StatefulShellRoute.indexedStack(
          builder: (_, _, shell) => KasirShell(shell: shell),
          branches: [
            StatefulShellBranch(routes: [
              GoRoute(path: Routes.settings, builder: (_, _) => const SettingsPage()),
            ]),
          ],
        ),
      ],
    );

class _StreamListenable extends ChangeNotifier {
  _StreamListenable(Stream<Object?> stream) {
    _sub = stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<Object?> _sub;

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}
