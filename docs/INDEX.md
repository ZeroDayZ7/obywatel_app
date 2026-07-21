# Project Architecture Overview

## 1. Start & Initialization (Bootstrapping Flow)

- **[main.dart](https://www.google.com/search?q=../lib/main.dart)** — Application entry point, triggers `bootstrap(() => const ObywatelPlusApp())`.
- **[bootstrap.dart](https://www.google.com/search?q=../lib/app/bootstrap/main/bootstrap.dart)** — Environment orchestration & initialization sequence:
- **Execution steps & dependencies:**

1. **Error Handling Setup**

- `FlutterError.onError` — Intercepts framework-level Flutter errors (`_handleFlutterError`).
- `PlatformDispatcher.instance.onError` — Catches unhandled platform dispatcher errors (`_handleGlobalError`).
- `ErrorWidget.builder` — Custom error screen ([GlobalErrorScreen](https://www.google.com/search?q=../lib/core/errors/presentation/global_error_screen.dart)) for production builds.
- `runZonedGuarded` — Encapsulates the async execution zone for top-level uncaught exceptions.

2. **Core Bindings & Localization**

- `WidgetsFlutterBinding.ensureInitialized()` — Ensures native engine bindings are ready.
- `EasyLocalization.ensureInitialized()` — Initializes I18n subsystem based on [lang_config.dart](https://www.google.com/search?q=../lib/app/lang/lang_config.dart).

3. **Storage & Infrastructure Setup**

- [SharedPreferencesService](https://www.google.com/search?q=../lib/core/storage/shared_preferences_provider.dart) — Instantiates key-value storage service backed by `SharedPreferences`.
- [AppLogger](https://www.google.com/search?q=../lib/core/logger/app_logger.dart) — Initializes core logging utility instance.
- [AppObserver](https://www.google.com/search?q=../lib/app/bootstrap/main/app_observer.dart) — Configures state transition monitoring for Riverpod.

4. **Provider Overrides & Root Mounting**

- `EasyLocalization` wrapper — Injects language assets and locale settings.
- `ProviderScope` configuration — Overrides `activePrefsProvider` and `appLoggerProvider`, registers `AppObserver`.

- **[app.dart](https://www.google.com/search?q=../lib/app/bootstrap/main/app.dart)** — Root `ConsumerWidget` (`ObywatelPlusApp`) building the core `MaterialApp.router` tree and global providers context:
- **Injected Providers & Watchers:**
- [themeProvider](https://www.google.com/search?q=../lib/app/theme/theme_notifier.dart) — Dynamic theme switching (light/dark mode via [AppTheme](https://www.google.com/search?q=../lib/app/theme/app_theme.dart)).
- [appRouterProvider](https://www.google.com/search?q=../lib/app/router/app_router_provider.dart) — Declarative routing configuration (`GoRouter`).
- [appLifecycleObserverProvider](https://www.google.com/search?q=../lib/core/security/lifecycle/app_lifecycle_observer_provider.dart) — Application lifecycle monitoring for security and state events.

- **Widget Tree & Security Wrapper Pipeline:**

1. **`SecureApplication`** — Native screen protection controller, registers secure controller with [securityServiceProvider](https://www.google.com/search?q=../lib/core/security/security/security_service_provider.dart).
2. **`MaterialApp.router`** — App-level configuration (theme, locale via [LangConfig](https://www.google.com/search?q=../lib/app/lang/lang_config.dart), router config).
3. **`GlobalNotificationOverlay`** — Top-level overlay wrapper for global notifications and error banners.
4. **`AppBootstrapHandler`** — Post-launch initialization and runtime readiness checker.
5. **`SecureGate`** — Privacy blur and lock gate (renders [PrivacyOverlay](https://www.google.com/search?q=../lib/app/bootstrap/presentation/privacy_overlay.dart) when app is locked).
6. **`Listener` (Global User Activity)** — Intercepts pointer events (`onPointerDown`) to reset the user session timeout via [sessionObserverProvider](https://www.google.com/search?q=../lib/features/auth/application/session/session_observer.dart).
7. **`child`** — Router's active screen widget destination.

## 2. Navigation & Router Architecture

- **[app_router_provider.dart](https://www.google.com/search?q=../lib/app/router/app_router_provider.dart)** — Riverpod root provider returning the configured `GoRouter` instance (`keepAlive: true`).
- **[router_config.dart](https://www.google.com/search?q=../lib/app/router/router_config.dart)** — Factory function (`createRouter`) attaching `authRefreshListenableProvider` as a `refreshListenable`. Guarantees immediate route re-evaluation whenever auth/security state mutates.
- **[redirect_guards.dart](https://www.google.com/search?q=../lib/app/router/redirect/redirect_guards.dart)** — Centralized access-control engine (`rootGuard`) operating as a state guard chain:

1. **Initialization Gate**: Forces route to `/initial` if security or auth services are not ready.
2. **Security Lock Gate**: Redirects to `/pin` if `securityState.shouldShowLock` or `authState.isLocked` is `true`.
3. **Unauthenticated Access Gate**: Restricts unauthenticated users from non-public routes, redirecting to `/login`.
4. **Step-up Auth & Onboarding Flow**: Enforces intermediate stops like `/2fa` or `/security_setup` based on authentication state completeness.
5. **Authenticated Bypass**: Prevents authenticated users from accessing auth-flow routes (e.g., `/login`, `/pin`), rerouting them to `/home`.

- **[shell_route_builder.dart](https://www.google.com/search?q=../lib/app/router/builders/shell_route_builder.dart) & Extensions**:
- `buildShellRoute`: Wraps bottom-navigation tabs inside `StatefulShellRoute.indexedStack` to preserve branch navigation history and widget states across tabs.
- `FeatureModuleExtension` (`.asFeatureModule()`): Encapsulates feature routes inside a unified `FeatureShell` providing consistent scaffolding and dynamic `AppBar` titles.
- `GoRouteExtensions` (`.go()`, `.goWithState()`): Fluent helpers reducing repetitive `GoRoute` boilerplate.

## 3. Session Lifecycle & Security Management

- **[session_observer.dart](https://www.google.com/search?q=../lib/features/auth/application/session/session_observer.dart)** — Reactive lifecycle and activity monitoring engine:
- **Inactivity Handling**: Listens to user tap events bubble up from root `Listener` (`app.dart`). Automatically triggers `securityService.lockApp()` upon reaching `apiConstants.inactivityTimeout`.
- **401 / Session Expiry Interception**: Observes `sessionStatusProvider`. If flagged as `expired`, automatically triggers force logout via `authController.logout()`.
- **Memory & Timer Safety**: Properly disposes of active inactivity timers on provider unmount (`onDispose`) or when transitioning to unauthenticated states.

## 4. Security Subsystem & Device Integrity

- **[security_service_provider.dart](https://www.google.com/search?q=../lib/core/security/security/security_service_provider.dart)** — Central Security Orchestrator (`NotifierProvider<SecurityService, SecurityState>`, `keepAlive: true`) handling app locking, biometrics, and local privacy:
- **Lazy Initialization (`_initFuture`)**: Guarantees atomic, single-execution setup during cold boot. Prevents parallel initializations or race conditions.
- **Execution Steps & Security Flow:**

1. **State & Storage Binding**: Reads security flags from [SecureStorageService](https://www.google.com/search?q=../lib/core/storage/secure_storage_provider.dart) and validates device integrity via [deviceIntegrityFacadeProvider](https://www.google.com/search?q=../lib/core/security/integrity/device_integrity_facade_provider.dart).
2. **Privacy Shield Toggle**: Dynamically controls `SecureApplicationController` (`_enablePrivacyShield` / `_disablePrivacyShield`) to blur screen buffers in recent app switchers.
3. **Zero-Trace Memory Erasure**: Encrypted PIN operations sweep local memory buffers by zeroing array elements in place (`pinCodes[i] = 0`) before garbage collection.
4. **Lifecycle Auto-Lock**: Responds to `onAppHidden` / `onAppResumed` signals emitted by [appLifecycleObserverProvider](https://www.google.com/search?q=../lib/core/security/lifecycle/app_lifecycle_observer_provider.dart). Automatically sets `hasLocalLock = true` when background thresholds are breached.

- **[device_integrity_facade_provider.dart](https://www.google.com/search?q=../lib/core/security/integrity/device_integrity_facade_provider.dart)** — Platform integrity verification engine:
- **Root/Jailbreak Detection**: Integrates `FlutterRootJailbreakChecker` to intercept tampered runtime environments, active debuggers, or exposed su-binary paths.
- **Hardware Security Attestation**: Queries native secure enclave / keystore states to ensure cryptographic keys remain hardware-backed.

## 5. Network Architecture & Resilience Layer

- **[dio_factory.dart](https://www.google.com/search?q=../lib/core/network/dio_factory.dart)** — Factory provider producing isolated `Dio` instances bound to targeted security profiles (`DioProfile`):

| Profil `DioProfile` | Base URL Target  | Certificate Pinning | Interceptor Pipeline                                             | Target Scope                                          |
| ------------------- | ---------------- | ------------------- | ---------------------------------------------------------------- | ----------------------------------------------------- |
| `authenticated`     | Auth Base URL    | SHA-256 Public Key  | `Fresh`, `SecuritySync`, `Logging`, `GlobalError`, `Fingerprint` | Protected business & user domain endpoints            |
| `refreshToken`      | Auth Base URL    | SHA-256 Public Key  | `Logging`, `GlobalError`, `Fingerprint`                          | Token rotation endpoint (prevents recursive loops)    |
| `public`            | Version Base URL | SHA-256 Public Key  | `SecuritySync`, `Logging`, `GlobalError`, `Fingerprint`          | Unauthenticated public metadata (e.g., version check) |
| `noAuthAuth`        | Auth Base URL    | SHA-256 Public Key  | `SecuritySync`, `Logging`, `GlobalError`, `Fingerprint`          | Registration, initial login, password reset           |

- **[fresh_provider.dart](https://www.google.com/search?q=../lib/core/network/interceptors/fresh_provider.dart)** & **[secure_token_storage.dart](https://www.google.com/search?q=../lib/core/storage/secure_token_storage.dart)** — Dual-storage token management architecture:
- **In-Memory Access Token Strategy**: `AccessToken` resides exclusively inside volatile RAM memory (`OAuth2Token`). Never written to non-volatile disk storage.
- **Encrypted Refresh Token Persistence**: `RefreshToken` is securely stored inside platform hardware keystore via [SecureStorageService](https://www.google.com/search?q=../lib/core/storage/secure_storage_provider.dart).
- **Cold Start Token Rotation Sequence:**

1. App boots and reads `RefreshToken` from [SecureTokenStorage](https://www.google.com/search?q=../lib/core/storage/secure_token_storage.dart).
2. Instantiates `OAuth2Token(accessToken: '', refreshToken: token)`.
3. Blank `accessToken` forces `Fresh` interceptor to invoke auto-refresh against `/auth/refresh` using the isolated `refreshToken` Dio instance.

- **Network Interceptor Pipeline:**
- **[security_sync_interceptor.dart](https://www.google.com/search?q=../lib/core/network/interceptors/security_sync_interceptor.dart)**: Intercepts HTTP `Date` headers on incoming responses to calculate real-time server time offsets (`serverTime - localTime`). Injects `X-Device-Secure` headers into outgoing requests based on cached root checks.
- **[logging_interceptor.dart](https://www.google.com/search?q=../lib/core/network/interceptors/logging_interceptor.dart)**: Sanitizes console logs. Recursively redacts sensitive payload keys (`password`, `access_token`, `refresh_token`, `pesel`, `pin`, `email`) into `********`.
- **[global_error_interceptor.dart](https://www.google.com/search?q=../lib/core/network/interceptors/global_error_interceptor.dart)**: Intercepts network failures (5xx, 401, timeout), mapping raw exceptions into structured domain error models.

## 6. Persistence & Data Storage Architecture

- **[secure_storage_provider.dart](https://www.google.com/search?q=../lib/core/storage/secure_storage_provider.dart)** — Hardware-backed Key-Value storage abstraction (`FlutterSecureStorage`):
- Encrypts sensitive credentials, biometrics preferences, and refresh tokens.
- Uses `AndroidOptions(encryptedSharedPreferences: true)` on Android and `IOSOptions(accessibility: KeychainAccessibility.first_unlock)` on iOS.

- **[shared_preferences_provider.dart](https://www.google.com/search?q=../lib/core/storage/shared_preferences_provider.dart)** — High-speed non-sensitive preferences storage:
- Synchronous read cache for non-critical application flags (e.g., UI preferences, selected locale, onboarding tutorial status).

- **[database_provider.dart](https://www.google.com/search?q=../lib/core/database/database_provider.dart)** & **[crypto_keys_dao.dart](https://www.google.com/search?q=../lib/core/database/daos/crypto_keys_dao.dart)** — Encrypted Local Relational Database (`Drift / SQLite`):
- **Database Encryption**: SQLite database file protected via SQLCipher with keys generated and retrieved from [SecureStorageService](https://www.google.com/search?q=../lib/core/storage/secure_storage_provider.dart).
- **`CryptoKeysDao`**: Encapsulates CRUD operations for local symmetric/asymmetrical key pairs, signature certificates, and off-grid transaction verification records.

## 7. Authentication & Session Domain State

- **[auth_controller.dart](https://www.google.com/search?q=../lib/features/auth/application/auth/auth_controller.dart)** — Primary Authentication State Machine (`StateNotifier<AuthState>`):
- Orchestrates user state transitions (`unauthenticated`, `authenticated`, `stepUpRequired`, `locked`).
- Coordinates credentials verification, biometric handshake, and force-logout procedures across network, local storage, and router guards.

- **[auth_state.dart](https://www.google.com/search?q=../lib/features/auth/domain/auth_state.dart)** — Immutable domain state tree defining active session flags, authenticated user metadata, step-up requirements, and lock conditions.

WIP
