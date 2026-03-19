# Базовые правила для Flutter
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class * extends io.flutter.plugin.common.Plugin { *; }

# Правила для Google Play Core и Firebase
-keep class com.google.android.play.core.** { *; }
-keep class com.google.firebase.** { *; }
-dontwarn com.google.android.play.core.**
-dontwarn com.google.firebase.**