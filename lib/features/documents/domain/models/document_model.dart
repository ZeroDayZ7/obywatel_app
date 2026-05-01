import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'document_model.freezed.dart';
part 'document_model.g.dart';

enum DocumentCategory { identity, work, education, transport }

@freezed
sealed class DocumentField with _$DocumentField {
  const factory DocumentField({
    required String label,
    required String value,
    required String iconName,
    @Default(false) bool isSensitive,
  }) = _DocumentField;

  const DocumentField._();

  factory DocumentField.fromJson(Map<String, dynamic> json) =>
      _$DocumentFieldFromJson(json);

  IconData get icon => _getIconData(iconName);
}

@freezed
sealed class DocumentModel with _$DocumentModel {
  const factory DocumentModel({
    required String id,
    required String title,
    required String iconName,
    required String colorHex,
    required DocumentCategory category,
    required List<DocumentField> fields,
    String? qrData,
    String? status,
    @Default(false) bool isVerified,
    String? subtitle,
    String? expiryDate,
  }) = _DocumentModel;

  const DocumentModel._();

  factory DocumentModel.fromJson(Map<String, dynamic> json) =>
      _$DocumentModelFromJson(json);

  Color get themeColor =>
      Color(int.parse(colorHex.replaceFirst('#', ''), radix: 16));

  IconData get icon => _getIconData(iconName);
}

IconData _getIconData(String name) {
  switch (name) {
    case 'badge':
      return Icons.badge;
    case 'directions_car':
      return Icons.directions_car;
    case 'description':
      return Icons.description;
    case 'fingerprint':
      return Icons.fingerprint;
    case 'person':
      return Icons.person;
    case 'school':
      return Icons.school;
    case 'numbers':
      return Icons.numbers;
    case 'card_membership':
      return Icons.card_membership;
    default:
      return Icons.info_outline;
  }
}
