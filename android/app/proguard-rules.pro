# Reguły dla Fluttera
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Zapobieganie problemom z paczkami security
-keep class com.ammar_ahmed.flutter_root_jailbreak_checker.** { *; }
-dontwarn com.google.android.play.core.**

# Dodatkowo dla spokoju z R8 i Flutterem
-ignorewarnings
-keepattributes *Annotation*
-keepattributes Signature 