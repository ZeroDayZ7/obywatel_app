# Generate Localization Keys

This script generates `locale_keys.g.dart` based on your JSON translation files (`assets/translations`).  
Use the generated keys to access translations safely with `.tr()`.

---

## 1. Import in your Dart file

```dart
import 'package:easy_localization/easy_localization.dart';
import 'package:obywatel_plus/core/lang/locale_keys.g.dart';
```

---

## 2. Run the generator

Open terminal in the **project root** and run:

```bash
dart run scripts/generate_locale_keys.dart
```

This will generate `lib/generated/locale_keys.g.dart` with all translation keys.

---

## 3. Usage example

```dart
Text(
  LocaleKeys.login_title.tr(),
  style: AppTextStyles.subtitle.copyWith(
    color: isDark
        ? const Color.fromARGB(179, 211, 211, 211)
        : AppColors.textSecondary,
  ),
  textAlign: TextAlign.center,
),
```

---

## Notes

- Make sure all your JSON translation files (`pl-PL.json`, `en-US.json`, etc.) have **the same key structure**.
- `.tr()` will automatically use the translation according to the current locale.
