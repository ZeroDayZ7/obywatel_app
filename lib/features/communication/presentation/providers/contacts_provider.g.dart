// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contacts_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(acceptedContacts)
final acceptedContactsProvider = AcceptedContactsProvider._();

final class AcceptedContactsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Contact>>,
          List<Contact>,
          Stream<List<Contact>>
        >
    with $FutureModifier<List<Contact>>, $StreamProvider<List<Contact>> {
  AcceptedContactsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'acceptedContactsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$acceptedContactsHash();

  @$internal
  @override
  $StreamProviderElement<List<Contact>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Contact>> create(Ref ref) {
    return acceptedContacts(ref);
  }
}

String _$acceptedContactsHash() => r'ab0621586a8d452bf0a1ff48032b2db8b78aa4be';

@ProviderFor(pendingContacts)
final pendingContactsProvider = PendingContactsProvider._();

final class PendingContactsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Contact>>,
          List<Contact>,
          Stream<List<Contact>>
        >
    with $FutureModifier<List<Contact>>, $StreamProvider<List<Contact>> {
  PendingContactsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pendingContactsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pendingContactsHash();

  @$internal
  @override
  $StreamProviderElement<List<Contact>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Contact>> create(Ref ref) {
    return pendingContacts(ref);
  }
}

String _$pendingContactsHash() => r'216f26dbaa7aa29a486f7af2ca1d7d227a4686c5';

@ProviderFor(ContactsSyncNotifier)
final contactsSyncProvider = ContactsSyncNotifierProvider._();

final class ContactsSyncNotifierProvider
    extends $AsyncNotifierProvider<ContactsSyncNotifier, void> {
  ContactsSyncNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'contactsSyncProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$contactsSyncNotifierHash();

  @$internal
  @override
  ContactsSyncNotifier create() => ContactsSyncNotifier();
}

String _$contactsSyncNotifierHash() =>
    r'35f43cb60c9768a4b2a073efe8cedf6552386b3c';

abstract class _$ContactsSyncNotifier extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
