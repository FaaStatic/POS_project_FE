import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';

typedef FakeHandler = FakeReply Function(RequestOptions options);

class FakeReply {
  const FakeReply(this.status, [this.body]);
  final int status;
  final Object? body;
}

/// Scripted HTTP adapter: route by "METHOD path", record every request.
class FakeAdapter implements HttpClientAdapter {
  final routes = <String, FakeHandler>{};
  final requests = <RequestOptions>[];

  void on(String method, String path, FakeHandler handler) => routes['$method $path'] = handler;

  @override
  Future<ResponseBody> fetch(RequestOptions options, Stream<Uint8List>? requestStream, Future<void>? cancelFuture) async {
    requests.add(options);
    final handler = routes['${options.method} ${options.path}'];
    if (handler == null) {
      throw DioException.connectionError(requestOptions: options, reason: 'no route ${options.method} ${options.path}');
    }
    final reply = handler(options);
    return ResponseBody.fromString(
      jsonEncode(reply.body ?? {}),
      reply.status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

Map<String, dynamic> envelope(Object? data, {String message = 'ok'}) => {'success': true, 'message': message, 'data': data};

Map<String, dynamic> errorBody(String message, [String? error]) => {
      'success': false,
      'message': message,
      'error': ?error,
    };

Dio fakeDio(FakeAdapter adapter) => Dio(BaseOptions(baseUrl: 'http://api.test'))..httpClientAdapter = adapter;
