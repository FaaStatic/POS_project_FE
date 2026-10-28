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

class CmsApp extends StatefulWidget {
  const CmsApp({super.key, this.initialLocation});

  /// Lets tests start on a specific page.
  final String? initialLocation;

  @override
  State<CmsApp> createState() => _CmsAppState();
}

class _CmsAppState extends State<CmsApp> {
  late final AuthCubit _auth = getIt<AuthCubit>()..restore();
  late final SettingsCubit _settings = getIt<SettingsCubit>();
  late final GoRouter _router = buildRouter(_auth, initialLocation: widget.initialLocation);

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
          // shadcn wraps Material so both widget sets read one theme (CMS: compact density).
          return ShadApp.custom(
            theme: AppTheme.compact.shadLight,
            darkTheme: AppTheme.compact.shadDark,
            themeMode: mode,
            appBuilder: (context) => MaterialApp.router(
              onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
              debugShowCheckedModeBanner: false,
              routerConfig: _router,
              theme: AppTheme.compact.light,
              darkTheme: AppTheme.compact.dark,
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
