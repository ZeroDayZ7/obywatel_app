import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/features/auth/application/session/session_service.dart';
import 'package:obywatel_plus/features/communication/application/contact_invite_error_mapper.dart';
import 'package:obywatel_plus/features/communication/application/contacts_service.dart';
import 'package:obywatel_plus/features/communication/domain/contacts/contact_identifier.dart';

const Object _sentinel = Object();

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
    Object? error = _sentinel,
  }) {
    final resolvedError = error == _sentinel ? this.error : error as String?;

    return AddContactFormState(
      currentUserId: currentUserId ?? this.currentUserId,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      error: resolvedError,
    );
  }
}

final addContactFormProvider =
    NotifierProvider<AddContactFormNotifier, AddContactFormState>(
      AddContactFormNotifier.new,
    );

class AddContactFormNotifier extends Notifier<AddContactFormState> {
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

    state = state.copyWith(error: null, isSubmitting: true);

    try {
      await ref.read(contactsServiceProvider).addContact(identifier.normalized);
      state = state.copyWith(isSubmitting: false, error: null);
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
    state = state.copyWith(error: null);
  }
}
