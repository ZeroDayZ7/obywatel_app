import 'dart:convert';

import 'package:obywatel_plus/core/storage/shared_preferences_provider.dart';
import 'package:obywatel_plus/features/home/domain/models/quick_access_item.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'quick_access_notifier.g.dart';

@riverpod
class QuickAccessNotifier extends _$QuickAccessNotifier {
  static const _storageKey = 'home.quick_access.items';

  SharedPreferencesService get _prefs => ref.read(activePrefsProvider);

  @override
  List<QuickAccessItem> build() {
    final stored = _prefs.read(_storageKey);
    if (stored == null || stored.isEmpty) {
      final defaults = QuickAccessItem.defaultItems();
      Future.microtask(() => _persist(defaults));
      return defaults;
    }

    try {
      final decoded = jsonDecode(stored) as List<dynamic>;
      final items = decoded
          .whereType<Map<String, dynamic>>()
          .map(QuickAccessItem.fromMap)
          .toList()
        ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

      if (items.isEmpty) {
        final defaults = QuickAccessItem.defaultItems();
        Future.microtask(() => _persist(defaults));
        return defaults;
      }

      return items;
    } catch (_) {
      final defaults = QuickAccessItem.defaultItems();
      Future.microtask(() => _persist(defaults));
      return defaults;
    }
  }

  Future<void> _persist(List<QuickAccessItem> items) async {
    await _prefs.write(
      _storageKey,
      jsonEncode(items.map((item) => item.toMap()).toList()),
    );
  }

  Future<void> toggleEnabled(String id) async {
    final current = [...state];
    final index = current.indexWhere((item) => item.id == id);
    if (index == -1) return;

    final updated = current
        .map(
          (item) => item.id == id ? item.copyWith(isEnabled: !item.isEnabled) : item,
        )
        .toList();

    state = updated;
    await _persist(updated);
  }

  Future<void> updateItem(
    String id, {
    String? title,
    String? subtitle,
    String? iconName,
    QuickAccessAccent? accent,
    bool? isEnabled,
    int? sortOrder,
    int? visualOffsetX,
    int? visualOffsetY,
    double? widthScale,
  }) async {
    final updated = state
        .map(
          (item) => item.id == id
              ? item.copyWith(
                  title: title ?? item.title,
                  subtitle: subtitle ?? item.subtitle,
                  iconName: iconName ?? item.iconName,
                  accent: accent ?? item.accent,
                  isEnabled: isEnabled ?? item.isEnabled,
                  sortOrder: sortOrder ?? item.sortOrder,
                  visualOffsetX: visualOffsetX ?? item.visualOffsetX,
                  visualOffsetY: visualOffsetY ?? item.visualOffsetY,
                  widthScale: widthScale ?? item.widthScale,
                )
              : item,
        )
        .toList()
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

    state = updated;
    await _persist(updated);
  }

  Future<void> reorder(String id, int newIndex) async {
    final items = [...state];
    final oldIndex = items.indexWhere((item) => item.id == id);
    if (oldIndex == -1 || oldIndex == newIndex) return;

    final item = items.removeAt(oldIndex);
    final targetIndex = newIndex.clamp(0, items.length);
    items.insert(targetIndex, item);

    final reordered = List.generate(items.length, (index) {
      return items[index].copyWith(sortOrder: index);
    });

    state = reordered;
    await _persist(reordered);
  }

  Future<void> restoreDefaults() async {
    final defaults = QuickAccessItem.defaultItems();
    state = defaults;
    await _persist(defaults);
  }
}
