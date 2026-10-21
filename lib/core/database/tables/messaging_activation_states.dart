import 'package:drift/drift.dart';

@DataClassName('MessagingActivationStateRow')
class MessagingActivationStates extends Table {
  TextColumn get userId => text()();

  TextColumn get deviceId => text()();

  BoolColumn get consentAccepted =>
      boolean().withDefault(const Constant(false))();

  TextColumn get status => text().withDefault(const Constant('not_started'))();

  TextColumn get termsVersion => text().withDefault(const Constant(''))();

  TextColumn get currentTermsVersion =>
      text().withDefault(const Constant(''))();

  BoolColumn get requiresTermsAcceptance =>
      boolean().withDefault(const Constant(false))();

  TextColumn get keyRegistrationStatus =>
      text().withDefault(const Constant('not_started'))();

  TextColumn get lastError => text().nullable()();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {userId, deviceId};
}
