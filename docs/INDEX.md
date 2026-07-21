# Project Architecture Overview

## 1. Start & Initialization (Bootstrapping Flow)

- **[main.dart](../lib/main.dart)** — Application entry point, triggers `bootstrap(() => const ObywatelPlusApp())`.
- **[bootstrap.dart](../lib/app/bootstrap/main/bootstrap.dart)** — Environment orchestration & initialization sequence:
  - **Execution steps & dependencies:**
    1. **Error Handling Setup**
       - `FlutterError.onError` — Intercepts framework-level Flutter errors (`_handleFlutterError`).
       - `PlatformDispatcher.instance.onError` — Catches unhandled platform dispatcher errors (`_handleGlobalError`).
       - `ErrorWidget.builder` — Custom error screen ([GlobalErrorScreen](../lib/core/errors/presentation/global_error_screen.dart)) for production builds.
       - `runZonedGuarded` — Encapsulates the async execution zone for top-level uncaught exceptions.
    2. **Core Bindings & Localization**
       - `WidgetsFlutterBinding.ensureInitialized()` — Ensures native engine bindings are ready.
       - `EasyLocalization.ensureInitialized()` — Initializes I18n subsystem based on [lang_config.dart](../lib/app/lang/lang_config.dart).
    3. **Storage & Infrastructure Setup**
       - [SharedPreferencesService](../lib/core/storage/shared_preferences_provider.dart) — Instantiates key-value storage service backed by `SharedPreferences`.
       - [AppLogger](../lib/core/logger/app_logger.dart) — Initializes core logging utility instance.
       - [AppObserver](../lib/app/bootstrap/main/app_observer.dart) — Configures state transition monitoring for Riverpod.
    4. **Provider Overrides & Root Mounting**
       - `EasyLocalization` wrapper — Injects language assets and locale settings.
       - `ProviderScope` configuration — Overrides `activePrefsProvider` and `appLoggerProvider`, registers `AppObserver`.
- **[app.dart](../lib/app/app.dart)** — Root `ConsumerWidget` (`ObywatelPlusApp`) building the core `MaterialApp.router` tree and global providers context:
  - **Injected Providers & Watchers:**
    - [themeProvider](../lib/app/theme/theme_notifier.dart) — Dynamic theme switching (light/dark mode via [AppTheme](../lib/app/theme/app_theme.dart)).
    - [appRouterProvider](../lib/app/router/app_router_provider.dart) — Declarative routing configuration (`GoRouter`).
    - [appLifecycleObserverProvider](../lib/core/security/lifecycle/app_lifecycle_observer_provider.dart) — Application lifecycle monitoring for security and state events.
  - **Widget Tree & Security Wrapper Pipeline:**
    1. **`SecureApplication`** — Native screen protection controller, registers secure controller with [securityServiceProvider](../lib/core/security/security/security_service_provider.dart).
    2. **`MaterialApp.router`** — App-level configuration (theme, locale via [LangConfig](../lib/app/lang/lang_config.dart), router config).
    3. **`GlobalNotificationOverlay`** — Top-level overlay wrapper for global notifications and error banners.
    4. **`AppBootstrapHandler`** — Post-launch initialization and runtime readiness checker.
    5. **`SecureGate`** — Privacy blur and lock gate (renders [PrivacyOverlay](../lib/app/bootstrap/presentation/privacy_overlay.dart) when app is locked).
    6. **`Listener` (Global User Activity)** — Intercepts pointer events (`onPointerDown`) to reset the user session timeout via [sessionObserverProvider](../lib/features/auth/application/session/session_observer.dart).
    7. **`child`** — Router's active screen widget destination.
