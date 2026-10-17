// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_contact_form_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AddContactForm)
final addContactFormProvider = AddContactFormProvider._();

final class AddContactFormProvider
    extends $NotifierProvider<AddContactForm, AddContactFormState> {
  AddContactFormProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'addContactFormProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$addContactFormHash();

  @$internal
  @override
  AddContactForm create() => AddContactForm();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AddContactFormState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AddContactFormState>(value),
    );
  }
}

String _$addContactFormHash() => r'2379186798da689a2c04fe1fd84e9112897a0b33';

abstract class _$AddContactForm extends $Notifier<AddContactFormState> {
  AddContactFormState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AddContactFormState, AddContactFormState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AddContactFormState, AddContactFormState>,
              AddContactFormState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
