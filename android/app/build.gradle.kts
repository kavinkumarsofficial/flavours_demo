plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.flutter_flavours"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        // Fallback Application ID if not specified by flavor
        applicationId = "com.company.kgf"
        manifestPlaceholders["appName"] = "KGF"
        manifestPlaceholders["appNameSuffix"] = ""
        manifestPlaceholders["environmentName"] = "dev"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    flavorDimensions += listOf("environment", "tenant")

    productFlavors {
        // --- Environment Dimension ---
        create("dev") {
            dimension = "environment"
            applicationIdSuffix = ".dev"
            manifestPlaceholders["environmentName"] = "dev"
            manifestPlaceholders["appNameSuffix"] = " Dev"
        }
        create("staging") {
            dimension = "environment"
            applicationIdSuffix = ".staging"
            manifestPlaceholders["environmentName"] = "staging"
            manifestPlaceholders["appNameSuffix"] = " Staging"
        }
        create("prod") {
            dimension = "environment"
            // Production has no applicationId suffix and no name suffix
            manifestPlaceholders["environmentName"] = "prod"
            manifestPlaceholders["appNameSuffix"] = ""
        }

        // --- Tenant Dimension ---
        create("kgf") {
            dimension = "tenant"
            applicationId = "com.company.kgf"
            manifestPlaceholders["appName"] = "KGF"
        }
        create("fgk") {
            dimension = "tenant"
            applicationId = "com.company.fgk"
            manifestPlaceholders["appName"] = "FGK"
        }
        create("gkf") {
            dimension = "tenant"
            // Preserving exact specified package ID: com.cpompany.gkf
            applicationId = "com.cpompany.gkf"
            manifestPlaceholders["appName"] = "GKF"
        }
    }

    buildTypes {
        release {
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}
