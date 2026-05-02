
import 'package:obywatel_plus/features/documents/domain/models/document_model.dart';

class MockDocumentService {
  static List<DocumentModel> getAllDocuments() {
    return [
      getMockIdCard(),
      getMockPassport(),
      getMockDrivingLicense(),
      getMockLargeFamilyCard(),
      getMockPensionerCard(),
      getMockWeaponPermit(),
      getMockStudentCard(),
      getMockZtmTicket(),
      getMockPkpCard(),
      getMockFlightTicket(),
    ];
  }

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
        DocumentField(
          label: 'Imię (Imiona)',
          value: 'Jan Paweł',
          iconName: 'person',
        ),
        DocumentField(label: 'Nazwisko', value: 'Kowalski', iconName: 'badge'),
        DocumentField(
          label: 'Obywatelstwo',
          value: 'POLSKIE',
          iconName: 'public',
        ),
        DocumentField(
          label: 'PESEL',
          value: '90010112345',
          iconName: 'fingerprint',
          isSensitive: true,
        ),
        DocumentField(
          label: 'Miejsce urodzenia',
          value: 'Warszawa',
          iconName: 'location_city',
        ),
      ],
      expiryDate: '12.05.2030',
    );
  }

  static DocumentModel getMockPassport() {
    return const DocumentModel(
      id: 'p1',
      title: 'Paszport',
      category: DocumentCategory.identity,
      iconName: 'public',
      colorHex: 'FFB71C1C',
      qrData: 'PASSPORT_DATA_9988',
      fields: [
        DocumentField(
          label: 'Numer paszportu',
          value: 'EA1234567',
          iconName: 'numbers',
        ),
        DocumentField(label: 'Płeć', value: 'M', iconName: 'male'),
      ],
      expiryDate: '10.10.2034',
    );
  }

  static DocumentModel getMockDrivingLicense() {
    return const DocumentModel(
      id: '3',
      title: 'Prawo jazdy',
      category: DocumentCategory.permissions,
      iconName: 'directions_car',
      colorHex: 'FF4CAF50',
      fields: [
        DocumentField(
          label: 'Kategorie',
          value: 'A, B, B1',
          iconName: 'category',
        ),
        DocumentField(
          label: 'Numer dokumentu',
          value: '9988/22/1234',
          iconName: 'description',
        ),
      ],
      expiryDate: '15.02.2035',
    );
  }

  static DocumentModel getMockLargeFamilyCard() {
    return const DocumentModel(
      id: '4',
      title: 'Karta Dużej Rodziny',
      category: DocumentCategory.permissions,
      iconName: 'family_restroom',
      colorHex: 'FFFF9800',
      fields: [
        DocumentField(
          label: 'Numer karty',
          value: '12345678901234567',
          iconName: 'credit_card',
        ),
      ],
      expiryDate: 'Bezterminowo',
    );
  }

  static DocumentModel getMockPensionerCard() {
    return const DocumentModel(
      id: '5',
      title: 'Legitymacja emeryta',
      category: DocumentCategory.permissions,
      iconName: 'elderly',
      colorHex: 'FF008080',
      fields: [
        DocumentField(
          label: 'Nr legitymacji',
          value: 'E/998877',
          iconName: 'numbers',
        ),
      ],
    );
  }

  static DocumentModel getMockWeaponPermit() {
    return const DocumentModel(
      id: '6',
      title: 'Pozwolenie na broń',
      category: DocumentCategory.permissions,
      iconName: 'security',
      colorHex: 'FF607D8B',
      fields: [
        DocumentField(label: 'Cel', value: 'Sportowy', iconName: 'target'),
        DocumentField(
          label: 'Nr pozwolenia',
          value: 'W/123/ABC',
          iconName: 'gavel',
        ),
      ],
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
        DocumentField(
          label: 'Wydział',
          value: 'Elektroniki i Technik Informacyjnych',
          iconName: 'apartment',
        ),
        DocumentField(label: 'Nr Albumu', value: '302192', iconName: 'numbers'),
      ],
      expiryDate: '31.10.2026',
    );
  }

  static DocumentModel getMockZtmTicket() {
    return const DocumentModel(
      id: 't1',
      title: 'Bilet okresowy ZTM',
      category: DocumentCategory.transport,
      iconName: 'directions_bus',
      colorHex: 'FFF44336',
      fields: [
        DocumentField(
          label: 'Rodzaj',
          value: '90-dniowy',
          iconName: 'calendar_today',
        ),
        DocumentField(label: 'Strefa', value: '1+2', iconName: 'map'),
      ],
      expiryDate: '15.06.2026',
    );
  }

  static DocumentModel getMockPkpCard() {
    return const DocumentModel(
      id: 't2',
      title: 'Karta lojalnościowa PKP',
      category: DocumentCategory.transport,
      iconName: 'train',
      colorHex: 'FFE65100',
      fields: [
        DocumentField(
          label: 'Program',
          value: 'Intercity Premium',
          iconName: 'star',
        ),
        DocumentField(label: 'Punkty', value: '1240 pkt', iconName: 'loyalty'),
      ],
    );
  }

  static DocumentModel getMockFlightTicket() {
    return const DocumentModel(
      id: 't3',
      title: 'Bilet lotniczy: WAW -> JFK',
      category: DocumentCategory.transport,
      iconName: 'flight_takeoff',
      colorHex: 'FF1565C0',
      fields: [
        DocumentField(
          label: 'Data lotu',
          value: '24 Maj 2026',
          iconName: 'event',
        ),
        DocumentField(
          label: 'Linia',
          value: 'LOT Polish Airlines',
          iconName: 'corporate_fare',
        ),
        DocumentField(
          label: 'Miejsce',
          value: '12A (Economy)',
          iconName: 'event_seat',
        ),
      ],
    );
  }
}
