import 'package:flutter/material.dart';
import 'package:obywatel_plus/features/documents/domain/models/document_model.dart';

class MockDocumentService {
  static DocumentModel getMockIdCard() {
    return DocumentModel(
      id: '1',
      title: 'Dowód osobisty',
      type: DocumentType.identity,
      qrData: 'USER_SECURE_TOKEN_123',
      themeColor: Colors.blue,
      fields: [
        DocumentField(label: 'Imię', value: 'Jan', icon: Icons.person),
        DocumentField(label: 'Nazwisko', value: 'Kowalski', icon: Icons.badge),
        DocumentField(
          label: 'PESEL',
          value: '90010112345',
          icon: Icons.fingerprint,
          isSensitive: true,
        ),
      ],
      expiryDate: '12.05.2030',
    );
  }

  static DocumentModel getMockStudentCard() {
    return DocumentModel(
      id: '2',
      title: 'Legitymacja studencka',
      type: DocumentType.education,
      qrData: 'STUDENT_AUTH_TOKEN_99',
      themeColor: Colors.indigo,
      fields: [
        DocumentField(
          label: 'Uczelnia',
          value: 'Politechnika Warszawska',
          icon: Icons.school,
        ),
        DocumentField(label: 'Nr Albumu', value: '302192', icon: Icons.numbers),
      ],
      expiryDate: '31.10.2026',
    );
  }
}
