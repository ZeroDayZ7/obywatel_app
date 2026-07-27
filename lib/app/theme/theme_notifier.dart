import 'package:obywatel_plus/app/theme/app_theme.dart';
import 'package:obywatel_plus/core/logger/logger_provider.dart';
import 'package:obywatel_plus/core/storage/shared_preferences_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme_notifier.g.dart';

const _themeKey = 'app_theme_type';

@riverpod
class ThemeNotifier extends _$ThemeNotifier {
  SharedPreferencesService get _prefs => ref.read(activePrefsProvider);

  @override
  AppThemeType build() {
    try {
      final saved = _prefs.read(_themeKey);
      if (saved != null) {
        return AppThemeType.values.firstWhere(
          (type) => type.name == saved,
          orElse: () => AppThemeType.system,
        );
      }
    } catch (e, s) {
      ref
          .read(appLoggerProvider)
          .e('Failed to load initial theme', error: e, stackTrace: s);
    }
    return AppThemeType.system;
  }

  Future<void> setTheme(AppThemeType type) async {
    state = type;
    try {
      await _prefs.write(_themeKey, type.name);
      ref.read(appLoggerProvider).i('Theme persisted: ${type.name}');
    } catch (e, s) {
      ref
          .read(appLoggerProvider)
          .e('Failed to save theme', error: e, stackTrace: s);
    }
  }
}
