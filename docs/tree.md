lib/
├── main.dart
├── main_dev.dart                # (opcjonalnie) different env
├── app/
│   ├── app.dart                 # root app widget (ObywatelPlusApp)
│   ├── app_router.dart          # GoRouter / routing config
│   ├── config/
│   │   ├── app_config.dart      # baseUrl, env flags
│   │   └── routes.dart          # route names / paths (shared constants)
│   ├── di/
│   │   ├── injector.dart        # AppInjector.setup()
│   │   └── modules/
│   │       ├── network_module.dart
│   │       ├── storage_module.dart
│   │       └── logger_module.dart
│   └── widgets/
│       ├── app_shell.dart       # global scaffold / nav
│       └── splash_image.dart
│
├── core/
│   ├── logger/
│   │   ├── app_logger.dart
│   │   └── logger_config.dart
│   ├── network/
│   │   ├── api_client.dart      # Dio wrapper, interceptors
│   │   └── network_info.dart    # connectivity checks
│   ├── storage/
│   │   ├── secure_storage_service.dart  # flutter_secure_storage wrapper
│   │   └── local_storage_service.dart   # shared_preferences wrapper
│   ├── errors/
│   │   ├── exceptions.dart
│   │   └── failures.dart
│   └── utils/
│       ├── validators.dart
│       ├── date_utils.dart
│       └── formatters.dart
│
├── features/
│   ├── auth/
│   │   ├── presentation/
│   │   │   ├── screens/
│   │   │   │   ├── login_screen.dart
│   │   │   │   ├── twofa_screen.dart
│   │   │   │   └── register_screen.dart
│   │   │   └── widgets/
│   │   │       └── login_form.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── user.dart
│   │   │   ├── repositories/
│   │   │   │   └── auth_repository.dart
│   │   │   └── usecases/
│   │   │       └── login_usecase.dart
│   │   └── data/
│   │       ├── datasources/
│   │       │   └── auth_remote_datasource.dart
│   │       ├── models/
│   │       │   └── user_model.dart
│   │       └── repositories/
│   │           └── auth_repository_impl.dart
│   │
│   ├── pin/
│   │   ├── presentation/
│   │   │   ├── screens/
│   │   │   │   ├── pin_entry_screen.dart
│   │   │   │   └── set_pin_screen.dart
│   │   │   └── widgets/
│   │   │       └── pin_input.dart
│   │   ├── domain/
│   │   │   └── usecases/
│   │   │       ├── has_pin_usecase.dart
│   │   │       └── verify_pin_usecase.dart
│   │   └── data/
│   │       └── pin_repository_impl.dart
│   │
│   ├── home/
│   │   ├── presentation/screens/home_screen.dart
│   │   └── ...
│
├── shared/
│   ├── widgets/
│   │   ├── loading_indicator.dart
│   │   └── error_view.dart
│   ├── services/
│   │   ├── connectivity_service.dart   # wrapper for Connectivity plugin
│   │   └── notification_service.dart
│   └── providers/                      # global Riverpod providers
│       ├── auth_providers.dart
│       ├── pin_providers.dart
│       └── network_providers.dart
|
├── assets/
│   ├── images/
│   │   └── splash.png
│   └── ...
|
└── test/
    └── ... (unit / widget / integration)
