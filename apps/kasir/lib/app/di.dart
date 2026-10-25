import 'package:core/core.dart';
import 'package:core/mobile.dart';
import 'package:get_it/get_it.dart';

import '../common/catalog/catalog_cubits.dart';
import '../features/auth/domain/usecases/logout_usecases.dart';
import '../features/auth/presentation/bloc/auth_cubit.dart';
import '../features/checkout/domain/usecases/checkout_usecases.dart';
import '../features/checkout/presentation/bloc/assign_barcode_cubit.dart';
import '../features/checkout/presentation/bloc/checkout_bloc.dart';
import '../features/customers/presentation/bloc/customers_cubit.dart';
import '../features/debts/presentation/bloc/debt_payment_cubit.dart';
import '../features/history/domain/usecases/history_usecases.dart';
import '../features/history/presentation/bloc/history_cubit.dart';
import '../features/printer/data/bluetooth_receipt_printer.dart';
import '../features/printer/presentation/bloc/receipt_settings_cubit.dart';
import '../features/products/presentation/bloc/products_cubit.dart';
import '../features/push/data/push_service.dart';
import '../features/settings/presentation/bloc/settings_cubit.dart';
import '../features/sync/data/connectivity_network_status.dart';
import '../features/sync/data/sync_scheduler.dart';
import '../features/sync/domain/usecases/sync_usecases.dart';
import '../features/sync/presentation/bloc/sync_cubit.dart';

final getIt = GetIt.instance;

/// Tests pass an in-memory database, stores, a fake network, and a client
/// backed by a fake adapter; production wires the real platform services.
void setupDependencies({
  required AppConfig config,
  required KeyValueStore store,
  AppDatabase? database,
  TokenStore? tokens,
  NetworkStatus? network,
  ApiClient? api,
  ApiClient? bare,
  ReceiptPrinter? printer,
  Future<void> Function()? scheduleSync,
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
  final db = database ?? AppDatabase();

  getIt
    // Infrastructure
    ..registerSingleton<AppConfig>(config)
    ..registerSingleton<KeyValueStore>(store)
    ..registerSingleton<ApiClient>(mainClient)
    ..registerSingleton<AppDatabase>(db)
    ..registerSingleton<NetworkStatus>(network ?? ConnectivityNetworkStatus())
    ..registerSingleton<AuthRepository>(auth)
    ..registerLazySingleton<PreferencesRepository>(() => PreferencesRepositoryImpl(store))
    ..registerLazySingleton<ProductRepository>(() => ProductRepositoryImpl(ProductRemoteDatasource(getIt())))
    ..registerLazySingleton<CategoryRepository>(() => CategoryRepositoryImpl(CategoryRemoteDatasource(getIt())))
    ..registerLazySingleton<CustomerRepository>(() => CustomerRepositoryImpl(CustomerRemoteDatasource(getIt())))
    ..registerLazySingleton<TransactionRepository>(() => TransactionRepositoryImpl(TransactionRemoteDatasource(getIt())))
    ..registerLazySingleton<PaymentRepository>(() => PaymentRepositoryImpl(PaymentRemoteDatasource(getIt())))
    ..registerLazySingleton<DebtRepository>(() => DebtRepositoryImpl(DebtRemoteDatasource(getIt())))
    ..registerLazySingleton<DeviceRepository>(() => DeviceRepositoryImpl(getIt()))
    ..registerLazySingleton<CatalogCache>(() => DriftCatalogCache(db))
    ..registerLazySingleton<SalesLog>(() => DriftSalesLog(db, store))
    ..registerLazySingleton<DraftRepository>(() => DriftDraftRepository(db))
    ..registerLazySingleton<ReceiptSettingsRepository>(() => ReceiptSettingsRepositoryImpl(store))
    ..registerLazySingleton<ReceiptPrinter>(() => printer ?? const BluetoothReceiptPrinter())
    ..registerLazySingleton(() => PushService(getIt(), getIt(), store))
    // Use cases
    ..registerFactory(() => Login(getIt()))
    ..registerFactory(() => RestoreSession(getIt()))
    ..registerFactory(() => Logout(getIt()))
    ..registerFactory(() => WatchSessionExpired(getIt()))
    ..registerFactory(() => GetCurrentSession(getIt()))
    ..registerFactory(() => GetPreferences(getIt()))
    ..registerFactory(() => SetTheme(getIt()))
    ..registerFactory(() => SetLanguage(getIt()))
    ..registerFactory(() => RefreshCatalog(getIt(), getIt(), getIt(), getIt()))
    ..registerFactory(() => GetProduct(getIt()))
    ..registerFactory(() => UpdateProduct(getIt()))
    ..registerFactory(() => AdjustStock(getIt()))
    ..registerFactory(() => AssignBarcode(getIt()))
    ..registerFactory(() => CreateCustomer(getIt()))
    ..registerFactory(() => GetCustomer(getIt()))
    ..registerFactory(() => GetDebt(getIt()))
    ..registerFactory(() => PayDebt(getIt()))
    ..registerFactory(() => ChargeQris(getIt()))
    ..registerFactory(() => ChargeVa(getIt()))
    ..registerFactory(() => CheckPaymentStatus(getIt()))
    ..registerFactory(() => CancelTransaction(getIt()))
    ..registerFactory(() => RegisterPushToken(getIt()))
    ..registerFactory(() => GetReceiptSettings(getIt()))
    ..registerFactory(() => SaveReceiptSettings(getIt()))
    ..registerFactory(() => PrintReceipt(getIt(), getIt()))
    ..registerFactory(() => OpenDraft(getIt()))
    ..registerFactory(() => CloseDraft(getIt()))
    ..registerFactory(() => AddItem(getIt()))
    ..registerFactory(() => ScanBarcode(getIt(), getIt()))
    ..registerFactory(() => PurgeStaleDrafts(getIt()))
    ..registerFactory(() => FindStockShortfalls(getIt()))
    ..registerFactory(() => CheckoutTransaction(
          transactions: getIt(), sales: getIt(), drafts: getIt(), cache: getIt(), network: getIt(), session: getIt()))
    ..registerFactory(() => StartCharge(qris: getIt(), va: getIt(), drafts: getIt(), network: getIt(), session: getIt()))
    ..registerFactory(() => ResolveCharge(
          status: getIt(), transactions: getIt(), sales: getIt(), drafts: getIt(), cache: getIt(), session: getIt()))
    ..registerFactory(() => SyncPendingTransactions(getIt(), getIt(), getIt()))
    ..registerFactory(() => WatchSales(getIt()))
    ..registerFactory(() => GetSale(getIt()))
    ..registerFactory(() => CancelSale(getIt(), getIt(), getIt()))
    ..registerFactory(() => CheckLogout(getIt(), getIt()))
    ..registerFactory(() => DiscardDrafts(getIt()))
    // Presentation
    ..registerFactory(() => AuthCubit(getIt(), getIt(), getIt(), getIt()))
    ..registerFactory(() => SettingsCubit(getIt(), getIt(), getIt()))
    ..registerFactory(() => CheckoutBloc(
          drafts: getIt(),
          network: getIt(),
          openDraft: getIt(),
          closeDraft: getIt(),
          addItem: getIt(),
          scan: getIt(),
          purge: getIt(),
          checkout: getIt(),
          startCharge: getIt(),
          resolveCharge: getIt(),
          shortfalls: getIt(),
        ))
    ..registerFactory(() => SyncCubit(
          sync: getIt(),
          refreshCatalog: getIt(),
          sales: getIt(),
          network: getIt(),
          scheduleNext: scheduleSync ?? const SyncScheduler().scheduleNext,
        ))
    ..registerFactory(() => ProductsCubit(getIt()))
    ..registerFactory(() => CustomersCubit(getIt()))
    ..registerFactory(() => AddCustomerCubit(getIt(), getIt(), getIt()))
    ..registerFactory(() => CustomerDetailCubit(getIt(), getIt()))
    ..registerFactory(() => DebtPaymentCubit(getIt(), getIt(), getIt()))
    ..registerFactory(() => ProductEditCubit(getIt(), getIt(), getIt(), getIt()))
    ..registerFactory(() => AssignBarcodeCubit(getIt(), getIt()))
    ..registerFactory(() => HistoryCubit(getIt()))
    ..registerFactory(() => SaleDetailCubit(getIt(), getIt(), getIt()))
    ..registerFactory(() => ReceiptSettingsCubit(getIt(), getIt()));
}
