// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contacts_api_client.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(contactsApiClient)
final contactsApiClientProvider = ContactsApiClientProvider._();

final class ContactsApiClientProvider
    extends
        $FunctionalProvider<
          ContactsApiClient,
          ContactsApiClient,
          ContactsApiClient
        >
    with $Provider<ContactsApiClient> {
  ContactsApiClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'contactsApiClientProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$contactsApiClientHash();

  @$internal
  @override
  $ProviderElement<ContactsApiClient> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ContactsApiClient create(Ref ref) {
    return contactsApiClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ContactsApiClient value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ContactsApiClient>(value),
    );
  }
}

String _$contactsApiClientHash() => r'434a65d40b4e5a3ae9393157d424a285703af2bf';
