import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';

typedef FakeHandler = FakeReply Function(RequestOptions options);

class FakeReply {
  const FakeReply(this.status, [this.body, this.headers = const {}]);
  final int status;
  final Object? body;

  /// Extra response headers, e.g. the paging headers of a file download.
  final Map<String, String> headers;
}

/// Scripted HTTP adapter: route by "METHOD path", record every request.
class FakeAdapter implements HttpClientAdapter {
  final routes = <String, FakeHandler>{};
  final requests = <RequestOptions>[];

  /// Raw bytes of each streamed request body (multipart uploads), in request order.
  /// Dio finalizes a FormData before the adapter runs, so this is the only place to read it.
  final streamedBodies = <List<int>>[];

  void on(String method, String path, FakeHandler handler) => routes['$method $path'] = handler;

  @override
  Future<ResponseBody> fetch(RequestOptions options, Stream<Uint8List>? requestStream, Future<void>? cancelFuture) async {
    requests.add(options);
    if (requestStream != null) streamedBodies.add([for (final chunk in await requestStream.toList()) ...chunk]);
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
        for (final h in reply.headers.entries) h.key: [h.value],
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
