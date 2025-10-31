```
flutter build apk --release --target-platform=android-arm --dart-define=DART_VM_PRODUCT=true
```

```
adb -s 5200d78bfa479449 install -r build/app/outputs/flutter-apk/app-release.apk
```

```
adb -s 5200d78bfa479449 reverse tcp:8081 tcp:8081
```

## 🧠 1. Sprawdź listę urządzeń ADB

| Komenda | Opis |
|----------|------|
| `adb devices` | Wyświetla wszystkie podłączone urządzenia i emulatory |
| **Przykład outputu:** |<pre>List of devices attached<br>5200d78bfa479449	device<br>emulator-5554	device</pre> |

> 💡 Skopiuj **ID urządzenia**, np. `5200d78bfa479449`

---

## ⚙️ 2. Sprawdź architekturę CPU urządzenia

| Komenda | Opis |
|----------|------|
| `adb -s 5200d78bfa479449 shell getprop ro.product.cpu.abi` | Pobiera główną architekturę procesora |
| **Przykład outputu:** | `armeabi-v7a` → oznacza ARMv7 (32-bit) |

---

## 🏗️ 3. Zbuduj aplikację Flutter tylko dla tej architektury


| Komenda | Opis |
|----------|------|
| `flutter build apk --release --target-platform=android-arm` | Buduje release APK dla `armeabi-v7a` |
| `flutter build apk --release --target-platform=android-arm64` | Buduje release APK dla `arm64-v8a` (urządzenia 64-bitowe) |
| `flutter build apk --release --target-platform=android-arm,android-arm64` | Buduje uniwersalny APK dla 32 i 64-bit |

📦 Wynikowy plik:  
`build/app/outputs/flutter-apk/app-release.apk`

---

## 📲 4. Zainstaluj aplikację na urządzeniu

| Komenda | Opis |
|----------|------|
| `adb -s 5200d78bfa479449 install -r build/app/outputs/flutter-apk/app-release.apk` | Instaluje APK na wybranym urządzeniu (zastępuje istniejącą wersję) |

---

## 🧾 5. (Opcjonalnie) Zbuduj App Bundle (AAB)

| Komenda | Opis |
|----------|------|
| `flutter build appbundle --release --target-platform=android-arm` | Tworzy `.aab` dla ARMv7 (do publikacji w Google Play) |



📦 Wynikowy plik:  
`build/app/outputs/bundle/release/app-release.aab`

---

## 📏 6. Sprawdź rozmiar gotowego APK

| Komenda | Opis |
|----------|------|
| `du -h build/app/outputs/flutter-apk/app-release.apk` | (Linux/macOS) pokazuje rozmiar pliku APK |
| `dir build\app\outputs\flutter-apk\app-release.apk` | (Windows PowerShell) pokazuje rozmiar pliku APK |

---

## ✅ Szybkie podsumowanie

| Cel | Komenda |
|------|----------|
| Sprawdź urządzenia | `adb devices` |
| Sprawdź architekturę CPU | `adb -s <device_id> shell getprop ro.product.cpu.abi` |
| Zbuduj APK dla ARMv7 | `flutter build apk --release --target-platform=android-arm` |
| Zainstaluj APK | `adb -s <device_id> install -r build/app/outputs/flutter-apk/app-release.apk` |
| Sprawdź rozmiar APK | `dir build\app\outputs\flutter-apk\app-release.apk` |

---