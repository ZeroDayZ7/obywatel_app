// lib/features/communication/presentation/providers/add_contact_form_provider.dart
import 'package:obywatel_plus/features/auth/application/session/session_service.dart';
import 'package:obywatel_plus/features/communication/application/contact_invite_error_mapper.dart';
import 'package:obywatel_plus/features/communication/application/contacts_service.dart';
import 'package:obywatel_plus/features/communication/domain/contacts/contact_identifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'add_contact_form_provider.g.dart';

// Zwykła klasa stanu (możesz też zostawić copyWith, albo użyć @freezed)
class AddContactFormState {
  const AddContactFormState({
    this.currentUserId = '',
    this.isSubmitting = false,
    this.error,
  });

  final String currentUserId;
  final bool isSubmitting;
  final String? error;

  AddContactFormState copyWith({
    String? currentUserId,
    bool? isSubmitting,
    String? error,
    bool clearError = false,
  }) {
    return AddContactFormState(
      currentUserId: currentUserId ?? this.currentUserId,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

@riverpod
class AddContactForm extends _$AddContactForm {
  @override
  AddContactFormState build() => const AddContactFormState();

  Future<void> loadCurrentUserId() async {
    final user = await ref.read(sessionServiceProvider).getCachedUser();
    state = state.copyWith(currentUserId: user?.id ?? '');
  }

  Future<bool> submit(String rawInput) async {
    final trimmed = rawInput.trim();
    if (trimmed.isEmpty) {
      state = state.copyWith(error: 'Sprawdź identyfikator użytkownika.');
      return false;
    }

    ContactIdentifier identifier;
    try {
      identifier = ContactIdentifier.parse(trimmed);
    } on FormatException {
      state = state.copyWith(error: 'Sprawdź identyfikator użytkownika.');
      return false;
    }

    state = state.copyWith(clearError: true, isSubmitting: true);

    try {
      await ref.read(contactsServiceProvider).addContact(identifier.normalized);
      state = state.copyWith(isSubmitting: false, clearError: true);
      return true;
    } catch (error) {
      state = state.copyWith(
        isSubmitting: false,
        error: mapContactInviteError(error),
      );
      return false;
    }
  }

  void clearError() {
    if (state.error == null) return;
    state = state.copyWith(clearError: true);
  }
}