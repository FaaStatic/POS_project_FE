import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:ui/ui.dart';

import '../features/auth/presentation/bloc/auth_cubit.dart';
import '../features/settings/presentation/bloc/settings_cubit.dart';
import '../l10n/app_localizations.dart';
import 'di.dart';
import 'router.dart';

class KasirApp extends StatefulWidget {
  const KasirApp({super.key});

  @override
  State<KasirApp> createState() => _KasirAppState();
}

class _KasirAppState extends State<KasirApp> {
  late final AuthCubit _auth = getIt<AuthCubit>()..restore();
  late final SettingsCubit _settings = getIt<SettingsCubit>();
  late final GoRouter _router = buildRouter(_auth);

  @override
  void dispose() {
    _router.dispose();
    _auth.close();
    _settings.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
    providers: [
      BlocProvider.value(value: _auth),
      BlocProvider.value(value: _settings),
    ],
    // Re-runs the auth redirect on login, logout, and session expiry.
    child: BlocListener<AuthCubit, AuthState>(
      listener: (_, _) => _router.refresh(),
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, settings) {
          Intl.defaultLocale = settings.language.name;
          final mode = ThemeMode.values.byName(settings.theme.name);
          // shadcn wraps Material so both widget sets read one theme (kasir: touch density).
          return ShadApp.custom(
            theme: AppTheme.touch.shadLight,
            darkTheme: AppTheme.touch.shadDark,
            themeMode: mode,
            appBuilder: (context) => MaterialApp.router(
              onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
              // Android recents card, like the web manifest's theme_color.
              color: Mint.c800,
              debugShowCheckedModeBanner: false,
              routerConfig: _router,
              theme: AppTheme.touch.light,
              darkTheme: AppTheme.touch.dark,
              themeMode: mode,
              locale: Locale(settings.language.name),
              supportedLocales: AppLocalizations.supportedLocales,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                UiLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              builder: (context, child) => ShadAppBuilder(child: child),
            ),
          );
        },
      ),
    ),
  );
}
