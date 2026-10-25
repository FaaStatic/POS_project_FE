import 'package:core/core.dart';
import 'package:get_it/get_it.dart';

import '../features/auth/presentation/bloc/auth_cubit.dart';
import '../features/settings/presentation/bloc/settings_cubit.dart';

final getIt = GetIt.instance;

/// [api] lets tests inject a client backed by a fake adapter.
void setupDependencies({
  required AppConfig config,
  required KeyValueStore store,
  ApiClient? api,
  ApiClient? bare,
  bool usesCookie = isWebClient,
}) {
  final tokens = MemoryTokenStore();
  final mainClient = api ?? ApiClient.create(config);
  final bareClient = bare ?? ApiClient.create(config);
  final auth = AuthRepositoryImpl(
    remote: AuthRemoteDatasource(api: mainClient, bare: bareClient),
    tokens: tokens,
    usesCookie: usesCookie,
  );
  mainClient.dio.interceptors.add(AuthInterceptor(
    tokens: tokens,
    refresh: auth.refreshAccessToken,
    retryDio: bareClient.dio,
    onSessionExpired: auth.expire,
  ));

  getIt
    ..registerSingleton<AppConfig>(config)
    ..registerSingleton<ApiClient>(mainClient)
    ..registerSingleton<AuthRepository>(auth)
    ..registerLazySingleton<PreferencesRepository>(() => PreferencesRepositoryImpl(store))
    ..registerFactory(() => Login(getIt()))
    ..registerFactory(() => RestoreSession(getIt()))
    ..registerFactory(() => Logout(getIt()))
    ..registerFactory(() => WatchSessionExpired(getIt()))
    ..registerFactory(() => GetPreferences(getIt()))
    ..registerFactory(() => SetTheme(getIt()))
    ..registerFactory(() => SetLanguage(getIt()))
    ..registerFactory(() => AuthCubit(getIt(), getIt(), getIt(), getIt()))
    ..registerFactory(() => SettingsCubit(getIt(), getIt(), getIt()));
}
