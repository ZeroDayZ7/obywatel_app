# Root path dla features
$root = "features/chat"

# Lista folderów
$folders = @(
    "$root/application/session",
    "$root/application/message",
    "$root/application/chat_provider",
    "$root/data/remote",
    "$root/data/local",
    "$root/domain/errors",
    "$root/domain/models",
    "$root/presentation/chat",
    "$root/presentation/chat/widgets",
    "$root/presentation/chat/screens"
)

# Tworzenie folderów
foreach ($folder in $folders) {
    if (!(Test-Path $folder)) {
        New-Item -ItemType Directory -Path $folder -Force
    }
}

# Lista plików startowych
$files = @(
    "$root/application/session/session_service.dart",
    "$root/application/message/message_service.dart",
    "$root/application/chat_provider/chat_provider.dart",
    "$root/data/remote/chat_api.dart",
    "$root/data/local/chat_local_storage.dart",
    "$root/domain/errors/chat_exceptions.dart",
    "$root/domain/models/message.dart",
    "$root/domain/models/chat.dart",
    "$root/presentation/chat/screens/chat_screen.dart",
    "$root/presentation/chat/widgets/message_bubble.dart",
    "$root/presentation/chat/widgets/chat_input.dart"
)

# Tworzenie pustych plików
foreach ($file in $files) {
    if (!(Test-Path $file)) {
        New-Item -ItemType File -Path $file -Force
    }
}

Write-Host "Chat feature folder structure created successfully!"
