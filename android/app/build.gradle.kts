plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.avijitmondal.saver"
    compileSdk = flutter.compileSdkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.avijitmondal.saver"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            val keystorePath = System.getenv("SAVER_UPLOAD_STORE_FILE") ?: ""
            val keystorePassword = System.getenv("SAVER_UPLOAD_STORE_PASSWORD") ?: ""
            val keystoreAlias = System.getenv("SAVER_UPLOAD_KEY_ALIAS") ?: ""
            val keystoreKeyPassword = System.getenv("SAVER_UPLOAD_KEY_PASSWORD") ?: ""
            storeFile = file(keystorePath)
            storePassword = keystorePassword
            keyAlias = keystoreAlias
            keyPassword = keystoreKeyPassword
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // Play Core library for deferred components support
    implementation("com.google.android.play:core:1.10.3")
    implementation("com.google.android.play:core-ktx:1.8.1")
}
