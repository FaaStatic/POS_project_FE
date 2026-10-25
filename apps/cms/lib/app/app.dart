import 'package:core/core.dart';
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
        child: BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, settings) {
            Intl.defaultLocale = settings.language.name;
            return MaterialApp.router(
              onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
              debugShowCheckedModeBanner: false,
              routerConfig: _router,
              theme: AppTheme.light,
              darkTheme: AppTheme.dark,
              themeMode: themeModeOf(settings.theme),
              locale: Locale(settings.language.name),
              supportedLocales: AppLocalizations.supportedLocales,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                UiLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
            );
          },
        ),
      );
}

ThemeMode themeModeOf(ThemePreference preference) => switch (preference) {
      ThemePreference.system => ThemeMode.system,
      ThemePreference.light => ThemeMode.light,
      ThemePreference.dark => ThemeMode.dark,
    };
