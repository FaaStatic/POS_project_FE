/// Web-safe exports for both apps. Native-only pieces live in `mobile.dart`.
library;

export 'src/common/failure.dart';
export 'src/common/guard.dart';
export 'src/common/result.dart';
export 'src/config/app_config.dart';
export 'src/constants/api_paths.dart';
export 'src/constants/payment_method.dart';
export 'src/constants/roles.dart';
export 'src/features/auth/data/datasources/auth_remote_datasource.dart';
export 'src/features/auth/data/repositories/auth_repository_impl.dart';
export 'src/features/auth/domain/entities/session.dart';
export 'src/features/auth/domain/repositories/auth_repository.dart';
export 'src/features/auth/domain/usecases/auth_usecases.dart';
export 'src/features/preferences/data/repositories/preferences_repository_impl.dart';
export 'src/features/preferences/domain/entities/preferences.dart';
export 'src/features/preferences/domain/repositories/preferences_repository.dart';
export 'src/features/preferences/domain/usecases/preferences_usecases.dart';
export 'src/format/formatters.dart';
export 'src/network/api_client.dart';
export 'src/network/auth_interceptor.dart';
export 'src/network/token_store.dart';
export 'src/storage/key_value_store.dart';
export 'src/validation/validators.dart';
