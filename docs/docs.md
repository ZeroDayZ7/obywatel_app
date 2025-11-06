adb devices

5200d78bfa479449 device
310008a89dd353f9 unauthorized

adb -s 5200d78bfa479449 reverse tcp:8081 tcp:8081

.\scrcpy -s 5200d78bfa479449

flutter run
.\scrcpy -s 5200d78bfa479449 --video-buffer 2 --max-fps 60

!D/ViewR, !D/InputM, !D/InputT, !V/InputMetho, !I/InputMetho, !I/AssistStr, !D/Surf, !W/libE, !D/vndksup, !E/ViewR, !W/ViewR

flutter pub get
flutter pub upgrade
flutter --version # Pokazuje aktualną wersję Fluttera i Dart
flutter doctor # Sprawdza środowisko Flutter/Dart, SDK, IDE, emulator
flutter channel # Wyświetla dostępne kanały i aktywny (\*)
flutter upgrade # Aktualizuje Fluttera do najnowszej wersji w aktywnym kanale
flutter clean # Czyści build (usuwa foldery build, .dart_tool)
flutter pub get # Pobiera zależności z pubspec.yaml
flutter pub upgrade # Aktualizuje zależności
flutter pub outdated # Sprawdza, które paczki mają nowsze wersje
flutter pub cache repair # Naprawia cache paczek
flutter analyze # Analizuje kod pod kątem błędów i ostrzeżeń
flutter channel <channel> # Zmienia kanał: stable, beta, dev, master
flutter upgrade # Po zmianie kanału aktualizuje Fluttera
flutter format . # Formatuje cały kod w projekcie
flutter devices # Lista podłączonych urządzeń/emulatorów
