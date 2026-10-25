import 'package:core/core.dart';
import 'package:core/mobile.dart';
import 'package:get_it/get_it.dart';

import '../features/auth/presentation/bloc/auth_cubit.dart';
import '../features/settings/presentation/bloc/settings_cubit.dart';

final getIt = GetIt.instance;

/// Tests pass in-memory stores and a client backed by a fake adapter.
void setupDependencies({
  required AppConfig config,
  required KeyValueStore store,
  TokenStore? tokens,
  ApiClient? api,
  ApiClient? bare,
}) {
  final tokenStore = tokens ?? SecureTokenStore();
  final mainClient = api ?? ApiClient.create(config);
  final bareClient = bare ?? ApiClient.create(config);
  final auth = AuthRepositoryImpl(
    remote: AuthRemoteDatasource(api: mainClient, bare: bareClient),
    tokens: tokenStore,
    usesCookie: false,
  );
  mainClient.dio.interceptors.add(AuthInterceptor(
    tokens: tokenStore,
    refresh: auth.refreshAccessToken,
    retryDio: bareClient.dio,
    onSessionExpired: auth.expire,
  ));

  getIt
    ..registerSingleton<AppConfig>(config)
    ..registerSingleton<KeyValueStore>(store)
    ..registerSingleton<ApiClient>(mainClient)
    ..registerSingleton<AuthRepository>(auth)
    ..registerLazySingleton<PreferencesRepository>(() => PreferencesRepositoryImpl(store))
    ..registerFactory(() => Login(getIt()))
    ..registerFactory(() => RestoreSession(getIt()))
    ..registerFactory(() => Logout(getIt()))
    ..registerFactory(() => WatchSessionExpired(getIt()))
    ..registerFactory(() => GetCurrentSession(getIt()))
    ..registerFactory(() => GetPreferences(getIt()))
    ..registerFactory(() => SetTheme(getIt()))
    ..registerFactory(() => SetLanguage(getIt()))
    ..registerFactory(() => AuthCubit(getIt(), getIt(), getIt(), getIt()))
    ..registerFactory(() => SettingsCubit(getIt(), getIt(), getIt()));
}
