import 'package:flutter_test/flutter_test.dart';
import 'package:obywatel_plus/app/theme/app_theme.dart';
import 'package:obywatel_plus/app/theme/extensions/status_colors_theme.dart';

void main() {
  test('App theme exposes semantic status colors for all supported themes', () {
    final light = AppTheme.buildTheme(AppThemeType.light);
    final dark = AppTheme.buildTheme(AppThemeType.dark);
    final matrix = AppTheme.buildTheme(AppThemeType.matrix);

    expect(light.extension<StatusColorsTheme>()?.success, isNotNull);
    expect(light.extension<StatusColorsTheme>()?.warning, isNotNull);
    expect(light.extension<StatusColorsTheme>()?.info, isNotNull);
    expect(dark.extension<StatusColorsTheme>()?.success, isNotNull);
    expect(matrix.extension<StatusColorsTheme>()?.success, isNotNull);
  });
}
