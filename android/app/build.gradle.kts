plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

android {
    namespace = "com.phoenix.app"
    compileSdk = 34

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }

    kotlinOptions {
        jvmTarget = "1.8"
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
            // Явно отключаем всё сжатие
            isMinifyEnabled = false
            isShrinkResources = false
            
            // Отключаем псевдо-локализацию
            isPseudoLocalesEnabled = false
            
            signingConfig = signingConfigs.getByName("debug")
        }
    }
    
    // Добавляем этот блок, чтобы гарантировать отключение сжатия ресурсов
    aaptOptions {
        cruncherEnabled = false
    }
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")
}