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
        child: BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, settings) {
            Intl.defaultLocale = settings.language.name;
            return MaterialApp.router(
              onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
              debugShowCheckedModeBanner: false,
              routerConfig: _router,
              theme: _kasirTheme(AppTheme.light),
              darkTheme: _kasirTheme(AppTheme.dark),
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

/// Kasir-only: segmented controls as shadcn toggles (ink selection, no check mark).
/// The CMS keeps the shared theme unchanged.
ThemeData _kasirTheme(ThemeData base) {
  final scheme = base.colorScheme;
  return base.copyWith(
    segmentedButtonTheme: SegmentedButtonThemeData(
      selectedIcon: const SizedBox.shrink(),
      style: SegmentedButton.styleFrom(
        selectedBackgroundColor: scheme.primary,
        selectedForegroundColor: scheme.onPrimary,
        backgroundColor: scheme.surface,
        side: BorderSide(color: scheme.outlineVariant),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Radii.control)),
      ),
    ),
  );
}
