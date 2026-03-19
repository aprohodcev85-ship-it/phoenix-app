import java.util.Properties
import java.io.FileInputStream

// Находим путь к Flutter SDK из local.properties
val flutterSdkPath = run {
    val localProperties = Properties()
    val localPropertiesFile = rootProject.file("local.properties")
    if (localPropertiesFile.exists()) {
        localProperties.load(FileInputStream(localPropertiesFile))
    }
    val sdkPath = localProperties.getProperty("flutter.sdk")
    sdkPath ?: throw GradleException("flutter.sdk not found in local.properties")
}

// Подключаем Gradle плагины из Flutter SDK
includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

pluginManagement {
    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    id("com.android.application") version "8.1.0" apply false
    id("org.jetbrains.kotlin.android") version "1.9.0" apply false
}

include(":app")