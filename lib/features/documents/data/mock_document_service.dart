import '../domain/models/document_model.dart';

class MockDocumentService {
  static DocumentModel getMockIdCard() {
    return const DocumentModel(
      id: '1',
      title: 'Dowód osobisty',
      category: DocumentCategory.identity,
      iconName: 'badge',
      colorHex: 'FF2196F3',
      qrData: 'USER_SECURE_TOKEN_123',
      isVerified: true,
      fields: [
        DocumentField(label: 'Imię', value: 'Jan', iconName: 'person'),
        DocumentField(label: 'Nazwisko', value: 'Kowalski', iconName: 'badge'),
        DocumentField(
          label: 'PESEL',
          value: '90010112345',
          iconName: 'fingerprint',
          isSensitive: true,
        ),
      ],
      expiryDate: '12.05.2030',
    );
  }

  static DocumentModel getMockStudentCard() {
    return const DocumentModel(
      id: '2',
      title: 'Legitymacja studencka',
      category: DocumentCategory.education,
      iconName: 'school',
      colorHex: 'FF3F51B5',
      qrData: 'STUDENT_AUTH_TOKEN_99',
      fields: [
        DocumentField(
          label: 'Uczelnia',
          value: 'Politechnika Warszawska',
          iconName: 'school',
        ),
        DocumentField(label: 'Nr Albumu', value: '302192', iconName: 'numbers'),
      ],
      expiryDate: '31.10.2026',
    );
  }
}
