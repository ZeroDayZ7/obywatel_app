adb devices

5200d78bfa479449 device 17
310008a89dd353f9 unauthorized 16

adb -s 5200d78bfa479449 reverse tcp:8081 tcp:8081

.\scrcpy -s 5200d78bfa479449
.\scrcpy -s 310008a89dd353f9

flutter run
.\scrcpy -s 5200d78bfa479449 --video-buffer 2 --max-fps 60

!D/ViewR, !D/InputM, !D/InputT, !V/InputMetho, !I/InputMetho, !I/AssistStr, !D/Surf, !W/libE, !D/vndksup, !E/ViewR, !W/ViewR, !D/Profile, !I/Chor

adb -s 5200d78bfa479449 shell top

# Generate app icons

dart run flutter_launcher_icons:main
dart run build_runner build --delete-conflicting-outputs
dart run scripts/generate_locale_keys.dart

# Release

flutter build apk --obfuscate --split-debug-info=./debug_info
