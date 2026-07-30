// lib/features/contacts/presentation/providers/contacts_provider.dart
import 'package:obywatel_plus/features/contacts/data/repositories/contacts_repository_impl.dart';
import 'package:obywatel_plus/features/contacts/domain/models/contact.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'contacts_provider.g.dart';

@riverpod
Stream<List<Contact>> acceptedContacts(Ref ref) {
  final repo = ref.watch(contactsRepositoryProvider);
  return repo.watchAcceptedContacts();
}

@riverpod
Stream<List<Contact>> pendingContacts(Ref ref) {
  final repo = ref.watch(contactsRepositoryProvider);
  return repo.watchPendingContacts();
}

@riverpod
class ContactsSyncNotifier extends _$ContactsSyncNotifier {
  @override
  FutureOr<void> build() {}

  Future<void> sync() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(contactsRepositoryProvider).fetchAndSyncContacts(),
    );
  }
}
