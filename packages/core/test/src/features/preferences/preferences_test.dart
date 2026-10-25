import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late PreferencesRepositoryImpl repo;
  setUp(() => repo = PreferencesRepositoryImpl(MemoryStore()));

  test('defaults to system theme and Indonesian', () {
    expect(GetPreferences(repo)(), (ThemePreference.system, AppLanguage.id));
  });

  test('persists theme and language', () async {
    await SetTheme(repo)(ThemePreference.dark);
    await SetLanguage(repo)(AppLanguage.en);
    expect(GetPreferences(repo)(), (ThemePreference.dark, AppLanguage.en));
  });

  test('unknown stored language falls back to Indonesian', () {
    expect(AppLanguage.parse('fr'), AppLanguage.id);
  });

  test('MemoryStore round-trips and removes values', () async {
    final store = MemoryStore();
    await store.setBool('b', true);
    await store.setInt('i', 3);
    expect(store.getBool('b'), isTrue);
    expect(store.getInt('i'), 3);
    await store.remove('b');
    expect(store.getBool('b'), isNull);
  });
}
