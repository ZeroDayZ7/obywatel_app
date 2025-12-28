# 🔥 Do czego używać Riverpoda 3

Riverpod to **zarządzanie stanem + logiką aplikacji**, a NIE UI.

Używaj go do:

* 🔐 auth (login, 2FA, PIN)
* 🌐 komunikacji z API
* 🧠 logiki biznesowej
* ⏳ stanów async (loading / success / error)
* 🌍 stanu globalnego (session, user, locale)

❌ **Nie do**:

* walidacji pól tekstowych (to UI)
* animacji
* lokalnych toggle w jednym widżecie

---

# 🧠 Model myślowy (najważniejsze)

Zawsze myśl tak:

```
UI
 ↓ obserwuje
Provider
 ↓ deleguje
Notifier (logika)
 ↓ modyfikuje
State (freezed)
```

UI **nigdy** nie robi logiki.

---

# 🗂️ Struktura katalogów (clean + skalowalna)

Przykład dla feature: `login`

```
features/
 └── auth/
     └── login/
         ├── application/
         │   ├── login_notifier.dart   <-- LOGIKA
         │   └── login_provider.dart   <-- PROVIDER
         ├── domain/
         │   └── login_state.dart      <-- STATE (freezed)
         └── presentation/
             └── login_page.dart       <-- UI
```

👉 **Nie mieszamy** tych warstw.

---

# 🧱 1️⃣ State – `login_state.dart`

📍 **Odpowiedzialność**: tylko dane + stany

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_state.freezed.dart';

@freezed
class LoginState with _$LoginState {
  const factory LoginState.idle() = _Idle;
  const factory LoginState.loading() = _Loading;
  const factory LoginState.success() = _Success;
  const factory LoginState.error({
    required String code,
  }) = _Error;
}
```

✅ brak logiki
✅ brak providerów
✅ brak dio

---

# 🧠 2️⃣ Notifier – `login_notifier.dart`

📍 **Odpowiedzialność**: cała logika

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/login_state.dart';

class LoginNotifier extends Notifier<LoginState> {
  @override
  LoginState build() {
    return const LoginState.idle();
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = const LoginState.loading();

    try {
      // symulacja API
      await Future.delayed(const Duration(seconds: 1));

      if (email != 'test@test.com') {
        throw 'login_invalid_credentials';
      }

      state = const LoginState.success();
    } catch (e) {
      state = LoginState.error(code: e.toString());
    }
  }

  void reset() {
    state = const LoginState.idle();
  }
}
```

✅ tylko logika
✅ brak UI
✅ zmienia tylko `state`

---

# 🧩 3️⃣ Provider – `login_provider.dart`

📍 **Odpowiedzialność**: **udostępnić notifier**

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'login_notifier.dart';
import '../domain/login_state.dart';

final loginNotifierProvider =
    NotifierProvider<LoginNotifier, LoginState>(
  LoginNotifier.new,
);
```

👉 Provider **nic nie wie** o UI
👉 Provider **nic nie wie** o API

---

# 🎨 4️⃣ UI – `login_page.dart`

📍 **Odpowiedzialność**: reagować na stan

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../application/login_provider.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(loginNotifierProvider);

    ref.listen(loginNotifierProvider, (prev, next) {
      next.whenOrNull(
        success: () {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Logged in')));
        },
        error: (code) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(code)));
        },
      );
    });

    return Scaffold(
      body: Center(
        child: state.when(
          idle: () => ElevatedButton(
            onPressed: () {
              ref
                  .read(loginNotifierProvider.notifier)
                  .login(email: 'test@test.com', password: '123');
            },
            child: const Text('Login'),
          ),
          loading: () => const CircularProgressIndicator(),
          success: () => const Text('Success'),
          error: (_) => const Text('Error'),
        ),
      ),
    );
  }
}
```

---

# 🧠 Zasady, których się TRZYMASZ

## ✅ 1 plik = 1 odpowiedzialność

* state → dane
* notifier → logika
* provider → DI
* ui → render + reakcje

## ✅ Notifier NIE:

* nie pokazuje toastów
* nie zna BuildContext
* nie importuje widgetów

## ✅ UI NIE:

* nie robi requestów
* nie mapuje errorów
* nie trzyma stanu logiki

---

# 🚨 Kiedy czego używać w Riverpod 3

| Sytuacja              | Co użyć          |
| --------------------- | ---------------- |
| Logika + state        | `Notifier`       |
| Async load (auto)     | `AsyncNotifier`  |
| Prosty stan           | `StateProvider`  |
| Serwis (dio, storage) | `Provider`       |
| Cache                 | `FutureProvider` |

---