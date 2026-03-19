plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.phoenix.app"
    compileSdk = 34

    compileOptions {
        // Включаем поддержку Java 17 для всего проекта
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        // Kotlin тоже должен целеваться в Java 17
        jvmTarget = "17"
    }

    defaultConfig {
        applicationId = "com.phoenix.app"
        minSdk = 21
        targetSdk = 34
        versionCode = 1
        versionName = "1.0.0"
    }

    buildTypes {
        release {
            // Включаем сжатие кода
            isMinifyEnabled = true
            // Теперь можно безопасно включить удаление ресурсов
            isShrinkResources = true
            
            signingConfig = signingConfigs.getByName("debug")
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.3")
}