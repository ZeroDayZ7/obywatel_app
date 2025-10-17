import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void login() => state = true;
  void logout() => state = false;
}

final authProvider = NotifierProvider.autoDispose<AuthNotifier, bool>(
  AuthNotifier.new,
);
