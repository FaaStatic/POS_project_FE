import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const host = {'API_BASE_URL': 'https://api.tokoku.id', 'FLAVOR': 'prod'};

  group('API_VERSION', () {
    test('defaults to v1 when missing or empty', () {
      expect(AppConfig.fromEnv(host).apiVersion, 'v1');
      expect(AppConfig.fromEnv({...host, 'API_VERSION': ''}).apiVersion, 'v1');
      expect(AppConfig.fromEnv({...host, 'API_VERSION': '  '}).apiVersion, 'v1');
    });

    test('is read from the env map', () {
      expect(AppConfig.fromEnv({...host, 'API_VERSION': 'v2'}).apiVersion, 'v2');
      expect(AppConfig.fromEnv({...host, 'API_VERSION': ' v12 '}).apiVersion, 'v12');
    });

    test('a malformed version stops startup instead of producing 404s', () {
      for (final bad in ['V1', '1', 'v', 'v1.2', 'api/v1', 'latest']) {
        expect(() => AppConfig.fromEnv({...host, 'API_VERSION': bad}), throwsA(isA<StateError>()), reason: bad);
      }
    });
  });

  group('apiUrl', () {
    test('is the host plus /api/{version}', () {
      expect(AppConfig.fromEnv({...host, 'API_VERSION': 'v3'}).apiUrl, 'https://api.tokoku.id/api/v3');
      expect(const AppConfig(baseUrl: 'http://10.0.2.2:3030', flavor: 'dev').apiUrl, 'http://10.0.2.2:3030/api/v1');
    });

    test('ignores trailing slashes on the host', () {
      expect(const AppConfig(baseUrl: 'https://api.tokoku.id//', flavor: 'dev', apiVersion: 'v2').apiUrl, 'https://api.tokoku.id/api/v2');
    });

    test('the Dio client calls the versioned root', () {
      final dio = ApiClient.createDio(AppConfig.fromEnv({...host, 'API_VERSION': 'v2'}));
      expect(dio.options.baseUrl, 'https://api.tokoku.id/api/v2');
    });
  });

  test('paths follow /{group}/{service} and stay relative to the versioned root', () {
    const paths = [
      ApiPaths.login, ApiPaths.refresh, ApiPaths.logout, ApiPaths.register, ApiPaths.users, ApiPaths.customers,
      ApiPaths.categories, ApiPaths.products, ApiPaths.transactions, ApiPaths.payments, ApiPaths.debts,
      ApiPaths.dashboard, ApiPaths.devices, ApiPaths.fcmRegister,
    ];
    const groups = {'account', 'catalog', 'sales', 'insight'};
    for (final path in paths) {
      expect(path, startsWith('/'));
      expect(path, isNot(startsWith('/api')));
      expect(groups, contains(path.split('/')[1]), reason: path);
    }
  });
}
