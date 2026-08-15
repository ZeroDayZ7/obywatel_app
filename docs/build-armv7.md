```
flutter build apk --release --target-platform=android-arm --dart-define=DART_VM_PRODUCT=true
flutter build apk --release --target-platform=android-arm
adb -s 5200d78bfa479449 install -r build/app/outputs/flutter-apk/app-release.apk

adb -s 5200d78bfa479449 reverse tcp:8081 tcp:8081

flutter run -d 5200d78bfa479449 --release
flutter run -d 5200d78bfa479449 --release --verbose

adb connect 192.168.43.13:8081
```
