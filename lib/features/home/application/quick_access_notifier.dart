import 'package:obywatel_plus/features/home/domain/models/quick_access_item.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'quick_access_notifier.g.dart';

@riverpod
class QuickAccessNotifier extends _$QuickAccessNotifier {
  @override
  List<QuickAccessItem> build() {
    return QuickAccessItem.defaultItems();
  }
}
