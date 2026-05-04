import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:obywatel_plus/features/payments/domain/enums/quick_action_type.dart';

part 'quick_action.freezed.dart';

@freezed
sealed class QuickAction with _$QuickAction {
  const factory QuickAction({
    required String id,
    required String label,
    required QuickActionType type,
    required IconData icon,
    required String colorKey,
  }) = _QuickAction;
}
