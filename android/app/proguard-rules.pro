# Базовые правила для Flutter
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class * extends io.flutter.plugin.common.Plugin { *; }

# Правила для библиотек (если используем)
-dontwarn com.google.common.**
-keep class com.google.errorprone.annotations.** { *; }