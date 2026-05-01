import 'package:flutter/material.dart';

enum DocumentType { identity, education, transport, license }

class DocumentField {
  final String label;
  final String value;
  final IconData icon;
  final bool isSensitive;

  DocumentField({
    required this.label,
    required this.value,
    required this.icon,
    this.isSensitive = false,
  });
}

class DocumentModel {
  final String id;
  final String title;
  final DocumentType type;
  final String qrData;
  final Color themeColor;
  final List<DocumentField> fields;
  final String? status;
  final String? expiryDate;

  DocumentModel({
    required this.id,
    required this.title,
    required this.type,
    required this.qrData,
    required this.themeColor,
    required this.fields,
    this.status,
    this.expiryDate,
  });
}
