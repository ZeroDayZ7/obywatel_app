
```
core/security
├── domain
│ ├── auth_method.dart # enum AuthMethod
│ ├── security_config.dart # model konfiguracji
│ ├── security_state.dart # runtime state (locked, verified)
│ ├── security_exceptions.dart
│ └── verification_config.dart # config dla UI
│
├── application
│ ├── security_service.dart # ORKIESTRATOR (NOWA WERSJA)
│ ├── security_guard.dart # czy app jest odblokowana
│ ├── verification_service.dart # verifySecret()
│ └── security_migration_service.dart
│
├── infrastructure
│ ├── secret_storage.dart # zapis / odczyt hash
│ ├── security_config_storage.dart # zapis / odczyt configu
│ ├── pin_attempt_limiter.dart
│ └── local_auth_provider.dart
│
├── presentation
│ ├── security_verification_screen.dart
│ ├── security_setup_flow.dart
│ └── widgets
│ └── secret_input.dart
│
└── providers
├── security_provider.dart
├── verification_provider.dart
└── security_state_provider.dart
```