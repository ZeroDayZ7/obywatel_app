import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:obywatel_plus/core/design/models/action_item.dart';

part 'settings_section.freezed.dart';

@freezed
sealed class SettingsSection with _$SettingsSection {
  const factory SettingsSection({
    required String title,
    required List<ActionItem> items,
  }) = _SettingsSection;
}
