class AppConfig {
  const AppConfig({required this.baseUrl, required this.flavor});

  /// Reads API_BASE_URL and FLAVOR from a parsed .env map.
  factory AppConfig.fromEnv(Map<String, String> env) {
    final baseUrl = env['API_BASE_URL'];
    if (baseUrl == null || baseUrl.isEmpty) {
      throw StateError('API_BASE_URL is missing from the .env file');
    }
    return AppConfig(baseUrl: baseUrl, flavor: env['FLAVOR'] ?? 'dev');
  }

  final String baseUrl;
  final String flavor;

  bool get isProd => flavor == 'prod';
}
