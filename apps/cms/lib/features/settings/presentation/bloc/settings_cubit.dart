import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings_cubit.freezed.dart';

@freezed
abstract class SettingsState with _$SettingsState {
  const factory SettingsState({required ThemePreference theme, required AppLanguage language}) = _SettingsState;
}

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit(GetPreferences get, this._setTheme, this._setLanguage)
    : super(() {
        final (theme, language) = get();
        return SettingsState(theme: theme, language: language);
      }());

  final SetTheme _setTheme;
  final SetLanguage _setLanguage;

  Future<void> setTheme(ThemePreference theme) async {
    emit(state.copyWith(theme: theme));
    await _setTheme(theme);
  }

  Future<void> setLanguage(AppLanguage language) async {
    emit(state.copyWith(language: language));
    await _setLanguage(language);
  }
}
