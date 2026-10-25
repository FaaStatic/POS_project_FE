import 'package:dio/dio.dart';
import 'package:dio_web_adapter/dio_web_adapter.dart';

const isWebClient = true;

/// Sends cookies cross-origin so the HttpOnly refresh cookie reaches /auth/refresh.
void configurePlatformAdapter(Dio dio) {
  dio.httpClientAdapter = BrowserHttpClientAdapter(withCredentials: true);
  dio.options.headers['X-Client'] = 'web';
}
