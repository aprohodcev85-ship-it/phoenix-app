android {
    namespace = "com.phoenix.app"
    compileSdk = 34

    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        // Указываем Java 17 везде
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        // Указываем Kotlin JVM target 17
        jvmTarget = "17"
    }

    // Добавляем вот этот блок для синхронизации всех задач
    tasks.withType<org.jetbrains.kotlin.gradle.tasks.KotlinCompile>().configureEach {
        kotlinOptions {
            jvmTarget = "17"
        }
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
            isMinifyEnabled = false
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}