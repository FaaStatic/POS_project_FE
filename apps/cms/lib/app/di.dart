import 'package:core/core.dart';
import 'package:get_it/get_it.dart';

import '../features/auth/presentation/bloc/auth_cubit.dart';
import '../features/categories/presentation/bloc/categories_cubit.dart';
import '../features/customers/presentation/bloc/customers_cubit.dart';
import '../features/devices/presentation/bloc/devices_cubit.dart';
import '../features/products/presentation/bloc/bulk_products_cubit.dart';
import '../features/products/presentation/bloc/products_cubit.dart';
import '../features/settings/presentation/bloc/settings_cubit.dart';
import '../features/staff/presentation/bloc/staff_cubit.dart';

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
    ..registerLazySingleton<StaffRepository>(() => StaffRepositoryImpl(getIt()))
    ..registerLazySingleton<CustomerRepository>(() => CustomerRepositoryImpl(CustomerRemoteDatasource(getIt())))
    ..registerLazySingleton<CategoryRepository>(() => CategoryRepositoryImpl(CategoryRemoteDatasource(getIt())))
    ..registerLazySingleton<ProductRepository>(() => ProductRepositoryImpl(ProductRemoteDatasource(getIt())))
    ..registerLazySingleton<TransactionRepository>(() => TransactionRepositoryImpl(TransactionRemoteDatasource(getIt())))
    ..registerLazySingleton<DeviceRepository>(() => DeviceRepositoryImpl(getIt()))
    ..registerFactory(() => Login(getIt()))
    ..registerFactory(() => RestoreSession(getIt()))
    ..registerFactory(() => Logout(getIt()))
    ..registerFactory(() => WatchSessionExpired(getIt()))
    ..registerFactory(() => GetPreferences(getIt()))
    ..registerFactory(() => SetTheme(getIt()))
    ..registerFactory(() => SetLanguage(getIt()))
    ..registerFactory(() => AuthCubit(getIt(), getIt(), getIt(), getIt()))
    ..registerFactory(() => SettingsCubit(getIt(), getIt(), getIt()))
    ..registerFactory(() => GetStaff(getIt()))
    ..registerFactory(() => RegisterStaff(getIt()))
    ..registerFactory(() => ResetStaffPassword(getIt()))
    ..registerFactory(() => DeactivateStaff(getIt()))
    ..registerFactory(() => RestoreStaff(getIt()))
    ..registerFactory(() => PurgeStaff(getIt()))
    ..registerFactory(() => StaffCubit(getIt(), getIt(), getIt(), getIt(), getIt(), getIt()))
    ..registerFactory(() => GetCustomers(getIt()))
    ..registerFactory(() => GetCustomer(getIt()))
    ..registerFactory(() => CreateCustomer(getIt()))
    ..registerFactory(() => UpdateCustomer(getIt()))
    ..registerFactory(() => DeactivateCustomer(getIt()))
    ..registerFactory(() => RestoreCustomer(getIt()))
    ..registerFactory(() => PurgeCustomer(getIt()))
    ..registerFactory(() => GetCustomerTransactions(getIt()))
    ..registerFactory(() => CustomersCubit(getIt(), getIt(), getIt(), getIt(), getIt(), getIt()))
    ..registerFactory(() => CustomerDetailCubit(getIt(), getIt()))
    ..registerFactory(() => GetCategories(getIt()))
    ..registerFactory(() => CreateCategory(getIt()))
    ..registerFactory(() => RenameCategory(getIt()))
    ..registerFactory(() => DeleteCategory(getIt()))
    ..registerFactory(() => CategoriesCubit(getIt(), getIt(), getIt(), getIt()))
    ..registerFactory(() => GetProducts(getIt()))
    ..registerFactory(() => CreateProduct(getIt()))
    ..registerFactory(() => UpdateProduct(getIt()))
    ..registerFactory(() => AdjustStock(getIt()))
    ..registerFactory(() => DeleteProduct(getIt()))
    ..registerFactory(() => BulkCreateProducts(getIt()))
    ..registerFactory(() => ProductsCubit(getIt(), getIt(), getIt(), getIt(), getIt(), getIt()))
    ..registerFactory(() => BulkProductsCubit(getIt()))
    ..registerFactory(() => GetDevices(getIt()))
    ..registerFactory(() => RevokeDevice(getIt()))
    ..registerFactory(() => DevicesCubit(getIt(), getIt()));
}
