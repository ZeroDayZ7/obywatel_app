import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:obywatel_plus/features/home/domain/models/quick_access_item.dart';

part 'quick_access_state.freezed.dart';

@freezed
sealed class QuickAccessState with _$QuickAccessState {
  const factory QuickAccessState({
    @Default(<QuickAccessItem>[]) List<QuickAccessItem> items,
  }) = _QuickAccessState;
}
