// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contacts_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(contactsService)
final contactsServiceProvider = ContactsServiceProvider._();

final class ContactsServiceProvider
    extends
        $FunctionalProvider<ContactsService, ContactsService, ContactsService>
    with $Provider<ContactsService> {
  ContactsServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'contactsServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$contactsServiceHash();

  @$internal
  @override
  $ProviderElement<ContactsService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ContactsService create(Ref ref) {
    return contactsService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ContactsService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ContactsService>(value),
    );
  }
}

String _$contactsServiceHash() => r'd300ab779994f95cab8d0e8d4ef6e3ec8ea7906c';
