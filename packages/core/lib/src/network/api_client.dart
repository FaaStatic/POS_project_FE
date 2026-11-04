import 'package:dio/dio.dart';

import '../config/app_config.dart';
import 'platform_adapter_stub.dart' if (dart.library.js_interop) 'platform_adapter_web.dart';

export 'platform_adapter_stub.dart' if (dart.library.js_interop) 'platform_adapter_web.dart' show isWebClient;

/// Thin wrapper over Dio that unwraps the backend envelope `{success, message, data}`.
class ApiClient {
  ApiClient(this.dio);

  factory ApiClient.create(AppConfig config, {List<Interceptor> interceptors = const []}) =>
      ApiClient(createDio(config)..interceptors.addAll(interceptors));

  final Dio dio;

  static Dio createDio(AppConfig config) {
    final dio = Dio(
      BaseOptions(
        baseUrl: config.apiUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 20),
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
      ),
    );
    configurePlatformAdapter(dio);
    return dio;
  }

  Future<dynamic> get(String path, {Map<String, dynamic>? query}) async =>
      _data(await dio.get<dynamic>(path, queryParameters: _clean(query)));

  Future<dynamic> post(String path, {Object? body, Map<String, dynamic>? query}) async =>
      _data(await dio.post<dynamic>(path, data: body, queryParameters: _clean(query)));

  Future<dynamic> put(String path, {Object? body}) async => _data(await dio.put<dynamic>(path, data: body));

  Future<dynamic> patch(String path, {Object? body}) async => _data(await dio.patch<dynamic>(path, data: body));

  Future<dynamic> delete(String path, {Object? body}) async => _data(await dio.delete<dynamic>(path, data: body));

  /// Raw bytes for PDF downloads.
  Future<List<int>> bytes(String path) async => (await download(path)).$1;

  /// Raw bytes plus the response headers (lower-case names), for downloads that report paging
  /// in headers. The browser only exposes the ones the server lists in Access-Control-Expose-Headers.
  Future<(List<int>, Map<String, String>)> download(String path, {Map<String, dynamic>? query}) async {
    final res = await dio.get<List<int>>(path, queryParameters: _clean(query), options: Options(responseType: ResponseType.bytes));
    return (res.data ?? const <int>[], {for (final e in res.headers.map.entries) e.key.toLowerCase(): e.value.join(',')});
  }

  static dynamic _data(Response<dynamic> res) {
    final body = res.data;
    return body is Map ? body['data'] : body;
  }

  static Map<String, dynamic>? _clean(Map<String, dynamic>? query) {
    if (query == null) return null;
    return {
      for (final e in query.entries)
        if (e.value != null && e.value != '') e.key: e.value,
    };
  }
}
