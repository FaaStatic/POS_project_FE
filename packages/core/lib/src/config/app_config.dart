class AppConfig {
  const AppConfig({required this.baseUrl, required this.flavor, this.apiVersion = defaultApiVersion});

  static const defaultApiVersion = 'v1';
  static final _versionPattern = RegExp(r'^v[0-9]+$');

  /// Reads API_BASE_URL, FLAVOR and API_VERSION from a parsed .env map. API_VERSION (v1, v2, ...)
  /// must match the backend's `server.api_version`; CI/CD rewrites it before the build and rebuilds
  /// the app whenever the server version goes up. Missing or empty means v1.
  factory AppConfig.fromEnv(Map<String, String> env) {
    final baseUrl = env['API_BASE_URL'];
    if (baseUrl == null || baseUrl.isEmpty) {
      throw StateError('API_BASE_URL is missing from the .env file');
    }
    final version = env['API_VERSION']?.trim();
    if (version != null && version.isNotEmpty && !_versionPattern.hasMatch(version)) {
      throw StateError('API_VERSION must look like v1 or v2, got "$version"');
    }
    return AppConfig(
      baseUrl: baseUrl,
      flavor: env['FLAVOR'] ?? 'dev',
      apiVersion: version == null || version.isEmpty ? defaultApiVersion : version,
    );
  }

  /// Host only, e.g. https://api.tokoku.id.
  final String baseUrl;
  final String flavor;
  final String apiVersion;

  /// Root every [ApiPaths] entry hangs off: `{baseUrl}/api/{apiVersion}`.
  String get apiUrl => '${baseUrl.replaceFirst(RegExp(r'/+$'), '')}/api/$apiVersion';

  bool get isProd => flavor == 'prod';
}
